import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';

// Ultra-Transparent Real-Time Fund Flow with Live Flow Lens
class LiveFlowLens extends StatefulWidget {
  final String userRole;
  final String? filterState;

  const LiveFlowLens({
    super.key,
    required this.userRole,
    this.filterState,
  });

  @override
  State<LiveFlowLens> createState() => _LiveFlowLensState();
}

class _LiveFlowLensState extends State<LiveFlowLens>
    with TickerProviderStateMixin {
  late AnimationController _flowController;
  late AnimationController _pulseController;
  late Animation<double> _flowAnimation;
  late Animation<double> _pulseAnimation;

  List<FlowNode> _nodes = [];
  List<FlowLink> _links = [];
  List<FlaggedTransaction> _flaggedTransactions = [];
  FlowLink? _selectedLink;
  String _selectedComponent = 'all';
  String _selectedTimeframe = 'live';
  int _selectedTranche = 0;
  bool _showDepthMap = true;
  bool _showFlaggedAlerts = true;
  StreamSubscription? _liveFlowSubscription;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadFlowData();
    _subscribeToLiveUpdates();
  }

  void _initializeAnimations() {
    _flowController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _flowAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flowController, curve: Curves.easeInOut),
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _flowController.repeat();
    _pulseController.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildControlPanel(),
        Expanded(
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: _buildFlowVisualization(),
              ),
              Expanded(
                flex: 1,
                child: _buildDetailsPanel(),
              ),
            ],
          ),
        ),
        _buildLiveStatsBar(),
      ],
    );
  }

  Widget _buildControlPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.cyan[50]!, Colors.white],
        ),
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.visibility, color: Colors.cyan, size: 32),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Live Flow Lens',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Ultra-transparent real-time fund flow visualization',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
              
              const Spacer(),
              
              // Live Indicator
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _pulseAnimation.value,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'LIVE',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Layer Controls
          Row(
            children: [
              // Component Filter
              DropdownButton<String>(
                value: _selectedComponent,
                items: const [
                  DropdownMenuItem(value: 'all', child: Text('All Components')),
                  DropdownMenuItem(value: 'adarsh_gram', child: Text('Adarsh Gram')),
                  DropdownMenuItem(value: 'gia', child: Text('GIA')),
                  DropdownMenuItem(value: 'hostel', child: Text('Hostel')),
                  DropdownMenuItem(value: 'infrastructure', child: Text('Infrastructure')),
                ],
                onChanged: (value) => setState(() => _selectedComponent = value!),
              ),
              
              const SizedBox(width: 16),
              
              // Timeframe Filter
              DropdownButton<String>(
                value: _selectedTimeframe,
                items: const [
                  DropdownMenuItem(value: 'live', child: Text('Live')),
                  DropdownMenuItem(value: 'today', child: Text('Today')),
                  DropdownMenuItem(value: 'week', child: Text('This Week')),
                  DropdownMenuItem(value: 'month', child: Text('This Month')),
                ],
                onChanged: (value) => setState(() => _selectedTimeframe = value!),
              ),
              
              const SizedBox(width: 16),
              
              // Tranche Selector
              Text('Tranche: '),
              DropdownButton<int>(
                value: _selectedTranche,
                items: List.generate(5, (index) {
                  return DropdownMenuItem(
                    value: index,
                    child: Text(index == 0 ? 'All' : 'T$index'),
                  );
                }),
                onChanged: (value) => setState(() => _selectedTranche = value!),
              ),
              
              const Spacer(),
              
              // Toggle Controls
              Row(
                children: [
                  Checkbox(
                    value: _showDepthMap,
                    onChanged: (value) => setState(() => _showDepthMap = value!),
                  ),
                  const Text('Depth Map'),
                  
                  const SizedBox(width: 16),
                  
                  Checkbox(
                    value: _showFlaggedAlerts,
                    onChanged: (value) => setState(() => _showFlaggedAlerts = value!),
                  ),
                  const Text('Flagged Alerts'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFlowVisualization() {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          colors: [
            Colors.cyan[900]!.withOpacity(0.05),
            Colors.cyan[50]!,
          ],
        ),
      ),
      child: Stack(
        children: [
          // Animated Depth Map
          if (_showDepthMap)
            AnimatedBuilder(
              animation: _flowAnimation,
              builder: (context, child) {
                return CustomPaint(
                  painter: DepthMapPainter(
                    nodes: _nodes,
                    links: _links,
                    animationValue: _flowAnimation.value,
                    selectedLink: _selectedLink,
                    showFlagged: _showFlaggedAlerts,
                    flaggedTransactions: _flaggedTransactions,
                  ),
                  child: GestureDetector(
                    onTapDown: (details) => _handleFlowTap(details.localPosition),
                  ),
                );
              },
            ),
          
          // Flow Particles
          AnimatedBuilder(
            animation: _flowAnimation,
            builder: (context, child) {
              return CustomPaint(
                painter: FlowParticlesPainter(
                  links: _links,
                  animationValue: _flowAnimation.value,
                ),
              );
            },
          ),
          
          // Flagged Flow Alerts
          if (_showFlaggedAlerts)
            ..._buildFlaggedAlerts(),
          
          // Layer Controls Overlay
          Positioned(
            top: 16,
            right: 16,
            child: _buildLayerControls(),
          ),
          
          // Flow Legend
          Positioned(
            bottom: 16,
            left: 16,
            child: _buildFlowLegend(),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(left: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Flow Details',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          
          const SizedBox(height: 16),
          
          if (_selectedLink != null) ...[
            _buildLinkDetails(_selectedLink!),
          ] else ...[
            _buildOverallStats(),
          ],
        ],
      ),
    );
  }

  Widget _buildLinkDetails(FlowLink link) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Link Header
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: link.getStatusColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${link.sourceNode} → ${link.targetNode}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '₹${_formatAmount(link.amount)}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: link.getStatusColor(),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Transaction Details
            _buildDetailRow('Status', link.status),
            _buildDetailRow('Component', link.component),
            _buildDetailRow('Tranche', 'T${link.tranche}'),
            _buildDetailRow('Initiated', _formatDateTime(link.timestamp)),
            
            if (link.isFlagged) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  border: Border.all(color: Colors.red[300]!),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.flag, color: Colors.red, size: 16),
                        SizedBox(width: 4),
                        Text(
                          'FLAGGED',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      link.flagReason ?? 'Under audit review',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Drill-Down Chart Button
            ElevatedButton.icon(
              onPressed: () => _openDrillDownChart(link),
              icon: const Icon(Icons.analytics),
              label: const Text('Drill-Down Chart'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan,
                foregroundColor: Colors.white,
              ),
            ),

            const SizedBox(height: 8),

            // Geotagged Receipts Button
            OutlinedButton.icon(
              onPressed: () => _viewGeotaggedReceipts(link),
              icon: const Icon(Icons.location_on),
              label: const Text('Geotagged Receipts'),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFlaggedAlerts() {
    return _flaggedTransactions.map((transaction) {
      return Positioned(
        left: transaction.x - 15,
        top: transaction.y - 15,
        child: AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: GestureDetector(
                onTap: () => _showFlagDetails(transaction),
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.8),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.warning,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            );
          },
        ),
      );
    }).toList();
  }

  // Event Handlers
  void _handleFlowTap(Offset position) {
    final link = _findLinkAtPosition(position);
    setState(() => _selectedLink = link);
  }

  FlowLink? _findLinkAtPosition(Offset position) {
    for (final link in _links) {
      if (_isPositionOnLink(position, link)) {
        return link;
      }
    }
    return null;
  }

  bool _isPositionOnLink(Offset position, FlowLink link) {
    // Simplified link detection
    final sourceNode = _nodes.firstWhere((n) => n.id == link.sourceNodeId);
    final targetNode = _nodes.firstWhere((n) => n.id == link.targetNodeId);
    
    final linkRect = Rect.fromPoints(
      Offset(sourceNode.x, sourceNode.y),
      Offset(targetNode.x, targetNode.y),
    ).inflate(10);
    
    return linkRect.contains(position);
  }

  void _loadFlowData() {
    setState(() {
      _nodes = _generateMockNodes();
      _links = _generateMockLinks();
      _flaggedTransactions = _generateMockFlaggedTransactions();
    });
  }

  List<FlowNode> _generateMockNodes() {
    return [
      FlowNode(id: 'centre', name: 'Centre Government', x: 100, y: 200, type: NodeType.centre),
      FlowNode(id: 'mh', name: 'Maharashtra', x: 300, y: 150, type: NodeType.state),
      FlowNode(id: 'ka', name: 'Karnataka', x: 300, y: 250, type: NodeType.state),
      FlowNode(id: 'mh_agency_1', name: 'MH Agency A', x: 500, y: 120, type: NodeType.agency),
      FlowNode(id: 'mh_agency_2', name: 'MH Agency B', x: 500, y: 180, type: NodeType.agency),
      FlowNode(id: 'ka_agency_1', name: 'KA Agency A', x: 500, y: 220, type: NodeType.agency),
      FlowNode(id: 'ka_agency_2', name: 'KA Agency B', x: 500, y: 280, type: NodeType.agency),
    ];
  }

  List<FlowLink> _generateMockLinks() {
    final random = math.Random();
    return [
      FlowLink(
        id: 'link_1',
        sourceNodeId: 'centre',
        targetNodeId: 'mh',
        sourceNode: 'Centre Government',
        targetNode: 'Maharashtra',
        amount: 5000000000,
        status: 'active',
        component: 'infrastructure',
        tranche: 1,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isFlagged: false,
      ),
      FlowLink(
        id: 'link_2',
        sourceNodeId: 'centre',
        targetNodeId: 'ka',
        sourceNode: 'Centre Government',
        targetNode: 'Karnataka',
        amount: 3500000000,
        status: 'completed',
        component: 'education',
        tranche: 2,
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        isFlagged: true,
        flagReason: 'Documentation discrepancy flagged by auditor',
      ),
    ];
  }

  List<FlaggedTransaction> _generateMockFlaggedTransactions() {
    return [
      FlaggedTransaction(
        id: 'flag_1',
        x: 350,
        y: 200,
        reason: 'Amount mismatch in documentation',
        severity: FlagSeverity.high,
        flaggedBy: 'Auditor A',
        flaggedAt: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
    ];
  }

  @override
  void dispose() {
    _flowController.dispose();
    _pulseController.dispose();
    _liveFlowSubscription?.cancel();
    super.dispose();
  }
}

// Custom Painters
class DepthMapPainter extends CustomPainter {
  final List<FlowNode> nodes;
  final List<FlowLink> links;
  final double animationValue;
  final FlowLink? selectedLink;
  final bool showFlagged;
  final List<FlaggedTransaction> flaggedTransactions;

  DepthMapPainter({
    required this.nodes,
    required this.links,
    required this.animationValue,
    this.selectedLink,
    required this.showFlagged,
    required this.flaggedTransactions,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw nodes
    for (final node in nodes) {
      _drawNode(canvas, node);
    }

    // Draw links with pulsating effect
    for (final link in links) {
      _drawLink(canvas, link);
    }
  }

  void _drawNode(Canvas canvas, FlowNode node) {
    final paint = Paint()
      ..color = node.getTypeColor()
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(node.x, node.y),
      20,
      paint,
    );

    // Draw node label
    final textPainter = TextPainter(
      text: TextSpan(
        text: node.name,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(node.x - textPainter.width / 2, node.y + 25),
    );
  }

  void _drawLink(Canvas canvas, FlowLink link) {
    final sourceNode = nodes.firstWhere((n) => n.id == link.sourceNodeId);
    final targetNode = nodes.firstWhere((n) => n.id == link.targetNodeId);

    final isSelected = selectedLink?.id == link.id;
    final strokeWidth = (link.amount / 1000000000 * 10).clamp(2.0, 20.0);

    final paint = Paint()
      ..color = link.isFlagged 
          ? Colors.red.withOpacity(0.7)
          : link.getStatusColor().withOpacity(isSelected ? 1.0 : 0.6)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    // Create curved path
    final path = Path();
    final controlPoint = Offset(
      (sourceNode.x + targetNode.x) / 2,
      (sourceNode.y + targetNode.y) / 2 - 50,
    );

    path.moveTo(sourceNode.x, sourceNode.y);
    path.quadraticBezierTo(
      controlPoint.dx,
      controlPoint.dy,
      targetNode.x,
      targetNode.y,
    );

    canvas.drawPath(path, paint);

    // Draw amount label
    final textPainter = TextPainter(
      text: TextSpan(
        text: '₹${(link.amount / 10000000).toStringAsFixed(0)}Cr',
        style: TextStyle(
          color: link.getStatusColor(),
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        controlPoint.dx - textPainter.width / 2,
        controlPoint.dy - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class FlowParticlesPainter extends CustomPainter {
  final List<FlowLink> links;
  final double animationValue;

  FlowParticlesPainter({
    required this.links,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final link in links) {
      if (link.status == 'active') {
        _drawFlowParticles(canvas, link);
      }
    }
  }

  void _drawFlowParticles(Canvas canvas, FlowLink link) {
    // This would draw animated particles along the flow path
    final particlePaint = Paint()
      ..color = Colors.cyan.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    // Simplified particle drawing
    for (int i = 0; i < 3; i++) {
      final progress = (animationValue + i * 0.3) % 1.0;
      final x = 100 + progress * 400; // Simplified calculation
      final y = 200 + math.sin(progress * math.pi) * 50;
      
      canvas.drawCircle(Offset(x, y), 3, particlePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Data Models
class FlowNode {
  final String id;
  final String name;
  final double x;
  final double y;
  final NodeType type;

  FlowNode({
    required this.id,
    required this.name,
    required this.x,
    required this.y,
    required this.type,
  });

  Color getTypeColor() {
    switch (type) {
      case NodeType.centre:
        return Colors.blue;
      case NodeType.state:
        return Colors.green;
      case NodeType.agency:
        return Colors.orange;
      case NodeType.project:
        return Colors.purple;
    }
  }
}

class FlowLink {
  final String id;
  final String sourceNodeId;
  final String targetNodeId;
  final String sourceNode;
  final String targetNode;
  final double amount;
  final String status;
  final String component;
  final int tranche;
  final DateTime timestamp;
  final bool isFlagged;
  final String? flagReason;

  FlowLink({
    required this.id,
    required this.sourceNodeId,
    required this.targetNodeId,
    required this.sourceNode,
    required this.targetNode,
    required this.amount,
    required this.status,
    required this.component,
    required this.tranche,
    required this.timestamp,
    this.isFlagged = false,
    this.flagReason,
  });

  Color getStatusColor() {
    switch (status) {
      case 'active':
        return Colors.cyan;
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'failed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class FlaggedTransaction {
  final String id;
  final double x;
  final double y;
  final String reason;
  final FlagSeverity severity;
  final String flaggedBy;
  final DateTime flaggedAt;

  FlaggedTransaction({
    required this.id,
    required this.x,
    required this.y,
    required this.reason,
    required this.severity,
    required this.flaggedBy,
    required this.flaggedAt,
  });
}

enum NodeType { centre, state, agency, project }
enum FlagSeverity { low, medium, high, critical }
