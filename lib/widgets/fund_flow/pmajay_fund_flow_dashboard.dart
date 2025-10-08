import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;

// Comprehensive Fund Flow Dashboard with Multi-Level Sankey Diagram
class PMajayFundFlowDashboard extends StatefulWidget {
  final String userRole;
  final String? filterState;

  const PMajayFundFlowDashboard({
    super.key,
    required this.userRole,
    this.filterState,
  });

  @override
  State<PMajayFundFlowDashboard> createState() => _PMajayFundFlowDashboardState();
}

class _PMajayFundFlowDashboardState extends State<PMajayFundFlowDashboard>
    with TickerProviderStateMixin {
  bool _isLoading = true;
  bool _hasError = false;
  FundFlowData? _fundFlowData;
  String _selectedLevel = 'national';
  String _selectedTimeRange = '1_year';
  StreamSubscription? _fundFlowSubscription;
  late AnimationController _sankeyAnimationController;
  
  SankeyNode? _selectedNode;
  SankeyLink? _selectedLink;

  @override
  void initState() {
    super.initState();
    _sankeyAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _loadFundFlowData();
    _subscribeToFundUpdates();
    
    // Preload data for smoother experience
    _preloadFundFlowData();
  }

  void _subscribeToFundUpdates() {
    // Simulate real-time fund flow updates
    _fundFlowSubscription = Stream.periodic(const Duration(seconds: 10))
        .listen((_) => _updateFundFlowData());
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
                child: _buildSankeyDiagram(),
              ),
              Expanded(
                flex: 1,
                child: _buildDetailsPanel(),
              ),
            ],
          ),
        ),
        _buildSummaryBar(),
      ],
    );
  }

  Widget _buildControlPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          // Level selector
          DropdownButton<String>(
            value: _selectedLevel,
            items: const [
              DropdownMenuItem(value: 'national', child: Text('National View')),
              DropdownMenuItem(value: 'state', child: Text('State Level')),
              DropdownMenuItem(value: 'district', child: Text('District Level')),
              DropdownMenuItem(value: 'project', child: Text('Project Level')),
            ],
            onChanged: (value) {
              setState(() => _selectedLevel = value!);
              _loadFundFlowData();
            },
          ),
          
          const SizedBox(width: 16),
          
          // Time range selector
          DropdownButton<String>(
            value: _selectedTimeRange,
            items: const [
              DropdownMenuItem(value: '1_month', child: Text('Last Month')),
              DropdownMenuItem(value: '3_months', child: Text('Last 3 Months')),
              DropdownMenuItem(value: '6_months', child: Text('Last 6 Months')),
              DropdownMenuItem(value: '1_year', child: Text('Last Year')),
            ],
            onChanged: (value) {
              setState(() => _selectedTimeRange = value!);
              _loadFundFlowData();
            },
          ),
          
          const Spacer(),
          
          // Action buttons
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _exportFundFlowData,
            tooltip: 'Export Data',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
            tooltip: 'Refresh',
          ),
        ],
      ),
    );
  }

  Widget _buildSankeyDiagram() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading fund flow data...'),
          ],
        ),
      );
    }
    
    if (_fundFlowData == null || _fundFlowData!.nodes.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('No fund flow data available'),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _loadFundFlowData,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      child: CustomPaint(
        painter: SankeyDiagramPainter(
          nodes: _fundFlowData!.nodes,
          links: _fundFlowData!.links,
          selectedNode: _selectedNode,
          selectedLink: _selectedLink,
          animationController: _sankeyAnimationController,
        ),
        child: GestureDetector(
          onTapDown: (details) => _handleSankeyTap(details.localPosition),
        ),
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
            'Fund Flow Details',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          
          const SizedBox(height: 16),
          
          if (_fundFlowData != null) ...[
            _buildFlowMetric(
              'Total Allocated',
              '₹${_formatCurrency(_fundFlowData!.totalAllocated)}',
              Colors.blue,
            ),
            _buildFlowMetric(
              'Total Utilized',
              '₹${_formatCurrency(_fundFlowData!.totalUtilized)}',
              Colors.green,
            ),
            _buildFlowMetric(
              'Utilization Rate',
              '${(_fundFlowData!.utilizationRate * 100).toStringAsFixed(1)}%',
              _getUtilizationColor(_fundFlowData!.utilizationRate),
            ),
            
            const SizedBox(height: 24),
            
            Text(
              'Recent Transactions',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            
            Expanded(
              child: _buildRecentTransactionsList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFlowMetric(String label, String value, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactionsList() {
    if (_fundFlowData?.recentTransactions.isEmpty ?? true) {
      return const Center(child: Text('No recent transactions'));
    }

    return ListView.builder(
      itemCount: _fundFlowData!.recentTransactions.length,
      itemBuilder: (context, index) {
        final transaction = _fundFlowData!.recentTransactions[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _getTransactionStatusColor(transaction.status),
              child: Icon(
                _getTransactionIcon(transaction.type),
                color: Colors.white,
                size: 16,
              ),
            ),
            title: Text(
              '₹${_formatCurrency(transaction.amount)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '${transaction.sourceLabel} → ${transaction.targetLabel}',
              style: const TextStyle(fontSize: 12),
            ),
            trailing: Text(
              _formatDate(transaction.createdAt),
              style: TextStyle(fontSize: 10, color: Colors.grey[600]),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummaryBar() {
    if (_fundFlowData == null) return const SizedBox();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem(
            'Active Flows',
            _fundFlowData!.links.where((l) => l.status == LinkStatus.active).length.toString(),
            Icons.trending_up,
            Colors.blue,
          ),
          _buildSummaryItem(
            'Completed',
            _fundFlowData!.links.where((l) => l.status == LinkStatus.completed).length.toString(),
            Icons.check_circle,
            Colors.green,
          ),
          _buildSummaryItem(
            'Flagged',
            _fundFlowData!.links.where((l) => l.status == LinkStatus.flagged).length.toString(),
            Icons.flag,
            Colors.red,
          ),
          _buildSummaryItem(
            'Avg Transfer Time',
            '3.2 days',
            Icons.schedule,
            Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  // Event Handlers
  void _handleSankeyTap(Offset position) {
    // Detect if tap is on node or link
    final tappedNode = _findNodeAtPosition(position);
    final tappedLink = _findLinkAtPosition(position);

    setState(() {
      _selectedNode = tappedNode;
      _selectedLink = tappedLink;
    });

    if (tappedNode != null) {
      _showNodeDetails(tappedNode);
    } else if (tappedLink != null) {
      _showLinkDetails(tappedLink);
    }
  }

  SankeyNode? _findNodeAtPosition(Offset position) {
    // Simplified node detection logic
    for (final node in _fundFlowData!.nodes) {
      final nodeRect = Rect.fromLTWH(
        node.x - 10,
        node.y - node.height / 2,
        20,
        node.height,
      );
      if (nodeRect.contains(position)) {
        return node;
      }
    }
    return null;
  }

  SankeyLink? _findLinkAtPosition(Offset position) {
    // Simplified link detection logic
    return null; // Implementation would check if position is within link path
  }

  void _showNodeDetails(SankeyNode node) {
    showDialog(
      context: context,
      builder: (context) => FundNodeDetailsDialog(
        node: node,
        fundFlowData: _fundFlowData!,
      ),
    );
  }

  void _showLinkDetails(SankeyLink link) {
    showDialog(
      context: context,
      builder: (context) => FundLinkDetailsDialog(
        link: link,
        transactions: _getTransactionsForLink(link),
      ),
    );
  }

  // Data Management
  Future<void> _loadFundFlowData() async {
    try {
      // Show loading state
      setState(() {
        _isLoading = true;
          );
        }
      });
    }
  }

  FundFlowData _generateMockFundFlowData() {
    final nodes = <SankeyNode>[
      SankeyNode(
        id: 'centre',
        label: 'Centre Government',
        type: NodeType.centre,
        value: 10000000000,
        color: Colors.blue,
        x: 50,
        y: 200,
        height: 100,
      ),
      SankeyNode(
        id: 'mh',
        label: 'Maharashtra',
        type: NodeType.state,
        value: 3000000000,
        color: Colors.green,
        x: 250,
        y: 150,
        height: 80,
      ),
      SankeyNode(
        id: 'ka',
        label: 'Karnataka',
        type: NodeType.state,
        value: 2500000000,
        color: Colors.green,
        x: 250,
        y: 250,
        height: 70,
      ),
    ];

    final links = <SankeyLink>[
      SankeyLink(
        sourceId: 'centre',
        targetId: 'mh',
        value: 3000000000,
        color: Colors.blue,
        status: LinkStatus.active,
        transactionIds: ['tx1', 'tx2'],
      ),
      SankeyLink(
        sourceId: 'centre',
        targetId: 'ka',
        value: 2500000000,
        color: Colors.green,
        status: LinkStatus.completed,
        transactionIds: ['tx3', 'tx4'],
      ),
    ];

    final transactions = <FundTransaction>[
      FundTransaction(
        id: 'tx1',
        amount: 1500000000,
        sourceId: 'centre',
        targetId: 'mh',
        sourceLabel: 'Centre Government',
        targetLabel: 'Maharashtra',
        status: TransactionStatus.completed,
        type: TransactionType.centreToState,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];

    return FundFlowData(
      nodes: nodes,
      links: links,
      totalAllocated: 10000000000,
      totalUtilized: 7500000000,
      utilizationRate: 0.75,
      recentTransactions: transactions,
    );
  }

  // Helper Methods
  Color _getUtilizationColor(double rate) {
    if (rate >= 0.8) return Colors.green;
    if (rate >= 0.6) return Colors.orange;
    return Colors.red;
  }

  Color _getTransactionStatusColor(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.pending:
        return Colors.orange;
      case TransactionStatus.completed:
        return Colors.green;
      case TransactionStatus.flagged:
        return Colors.red;
    }
  }

  IconData _getTransactionIcon(TransactionType type) {
    switch (type) {
      case TransactionType.centreToState:
        return Icons.arrow_downward;
      case TransactionType.stateToAgency:
        return Icons.arrow_forward;
      case TransactionType.agencyInternal:
        return Icons.swap_horiz;
    }
  }

  String _formatCurrency(double amount) {
    if (amount >= 10000000) {
      return '${(amount / 10000000).toStringAsFixed(1)} Cr';
    } else if (amount >= 100000) {
      return '${(amount / 100000).toStringAsFixed(1)} L';
    } else {
      return '${(amount / 1000).toStringAsFixed(0)} K';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  List<FundTransaction> _getTransactionsForLink(SankeyLink link) {
    return _fundFlowData?.recentTransactions
        .where((tx) => link.transactionIds.contains(tx.id))
        .toList() ?? [];
  }

  void _exportFundFlowData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Exporting fund flow data...')),
    );
  }

  void _refreshData() {
    _loadFundFlowData();
  }

  @override
  void dispose() {
    _sankeyAnimationController.dispose();
    _fundFlowSubscription?.cancel();
    super.dispose();
  }
}

// Custom Painter for Sankey Diagram
class SankeyDiagramPainter extends CustomPainter {
  final List<SankeyNode> nodes;
  final List<SankeyLink> links;
  final SankeyNode? selectedNode;
  final SankeyLink? selectedLink;
  final AnimationController animationController;

  SankeyDiagramPainter({
    required this.nodes,
    required this.links,
    this.selectedNode,
    this.selectedLink,
    required this.animationController,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw links first (behind nodes)
    for (final link in links) {
      _drawLink(canvas, link, size);
    }

    // Draw nodes on top
    for (final node in nodes) {
      _drawNode(canvas, node, size);
    }
  }

  void _drawNode(Canvas canvas, SankeyNode node, Size size) {
    final isSelected = selectedNode?.id == node.id;
    final paint = Paint()
      ..color = isSelected ? node.color : node.color.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    final rect = Rect.fromLTWH(
      node.x - 10,
      node.y - node.height / 2,
      20,
      node.height,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(4)),
      paint,
    );

    // Draw label
    final textPainter = TextPainter(
      text: TextSpan(
        text: node.label,
        style: TextStyle(
          color: Colors.black87,
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(node.x + 25, node.y - textPainter.height / 2),
    );
  }

  void _drawLink(Canvas canvas, SankeyLink link, Size size) {
    final sourceNode = nodes.firstWhere((n) => n.id == link.sourceId);
    final targetNode = nodes.firstWhere((n) => n.id == link.targetId);

    final isSelected = selectedLink?.sourceId == link.sourceId && 
                      selectedLink?.targetId == link.targetId;
    
    final paint = Paint()
      ..color = isSelected ? link.color : link.color.withOpacity(0.6)
      ..strokeWidth = _calculateLinkWidth(link.value)
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(sourceNode.x + 10, sourceNode.y);
    
    final controlX = (sourceNode.x + targetNode.x) / 2;
    path.quadraticBezierTo(
      controlX,
      sourceNode.y,
      targetNode.x - 10,
      targetNode.y,
    );

    canvas.drawPath(path, paint);
  }

  double _calculateLinkWidth(double value) {
    return (value / 100000000).clamp(2.0, 30.0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Dialog Widgets
class FundNodeDetailsDialog extends StatelessWidget {
  final SankeyNode node;
  final FundFlowData fundFlowData;

  const FundNodeDetailsDialog({
    super.key,
    required this.node,
    required this.fundFlowData,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('${node.label} Details'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Type: ${node.type.toString().split('.').last}'),
          Text('Total Value: ₹${(node.value / 10000000).toStringAsFixed(1)} Cr'),
          // Add more details as needed
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}

class FundLinkDetailsDialog extends StatelessWidget {
  final SankeyLink link;
  final List<FundTransaction> transactions;

  const FundLinkDetailsDialog({
    super.key,
    required this.link,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Fund Transfer Details'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Amount: ₹${(link.value / 10000000).toStringAsFixed(1)} Cr'),
          Text('Status: ${link.status.toString().split('.').last}'),
          Text('Transactions: ${transactions.length}'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
