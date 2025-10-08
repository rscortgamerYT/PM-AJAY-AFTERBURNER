import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';

// Centralized Agency Mapping & Coordination Hub
class AgencyCoordinationHub extends StatefulWidget {
  final String userRole;
  final String? filterState;

  const AgencyCoordinationHub({
    super.key,
    required this.userRole,
    this.filterState,
  });

  @override
  State<AgencyCoordinationHub> createState() => _AgencyCoordinationHubState();
}

class _AgencyCoordinationHubState extends State<AgencyCoordinationHub>
    with TickerProviderStateMixin {
  late AnimationController _globeRotationController;
  late AnimationController _pulseController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;

  List<AgencyNode> _agencies = [];
  AgencyNode? _selectedAgency;
  String _filterComponent = 'all';
  String _viewMode = '3d_globe';
  bool _showHeatmap = true;
  StreamSubscription? _realTimeSubscription;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadAgencies();
    _subscribeToRealTimeUpdates();
  }

  void _initializeAnimations() {
    _globeRotationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _globeRotationController,
      curve: Curves.linear,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _globeRotationController.repeat();
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
                child: _buildMainVisualization(),
              ),
              Expanded(
                flex: 1,
                child: _buildAgencyDetailsPanel(),
              ),
            ],
          ),
        ),
        _buildBottomStatsBar(),
      ],
    );
  }

  Widget _buildControlPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.indigo[50]!, Colors.white],
        ),
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          // View Mode Toggle
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(
                value: '3d_globe',
                label: Text('3D Globe'),
                icon: Icon(Icons.public),
              ),
              ButtonSegment(
                value: 'heatmap',
                label: Text('Heatmap'),
                icon: Icon(Icons.map),
              ),
              ButtonSegment(
                value: 'network',
                label: Text('Network'),
                icon: Icon(Icons.hub),
              ),
            ],
            selected: {_viewMode},
            onSelectionChanged: (Set<String> selection) {
              setState(() => _viewMode = selection.first);
            },
          ),

          const SizedBox(width: 16),

          // Component Filter
          DropdownButton<String>(
            value: _filterComponent,
            items: const [
              DropdownMenuItem(value: 'all', child: Text('All Components')),
              DropdownMenuItem(value: 'adarsh_gram', child: Text('Adarsh Gram')),
              DropdownMenuItem(value: 'gia', child: Text('GIA')),
              DropdownMenuItem(value: 'hostel', child: Text('Hostel')),
              DropdownMenuItem(value: 'infrastructure', child: Text('Infrastructure')),
            ],
            onChanged: (value) => setState(() => _filterComponent = value!),
          ),

          const Spacer(),

          // Action Buttons
          ElevatedButton.icon(
            onPressed: () => _openLoadBalancer(),
            icon: const Icon(Icons.balance),
            label: const Text('Load Balancer'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
          ),
          
          const SizedBox(width: 8),
          
          ElevatedButton.icon(
            onPressed: () => _refreshAgencies(),
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3F51B5),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainVisualization() {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          colors: [
            Colors.indigo[900]!.withOpacity(0.1),
            Colors.indigo[50]!,
          ],
        ),
      ),
      child: Stack(
        children: [
          // Main Visualization
          if (_viewMode == '3d_globe')
            _build3DGlobe()
          else if (_viewMode == 'heatmap')
            _buildHeatmapView()
          else
            _buildNetworkView(),

          // Overlay Controls
          Positioned(
            top: 16,
            right: 16,
            child: _buildViewControls(),
          ),

          // Legend
          Positioned(
            bottom: 16,
            left: 16,
            child: _buildLegend(),
          ),
        ],
      ),
    );
  }

  Widget _build3DGlobe() {
    return AnimatedBuilder(
      animation: _rotationAnimation,
      builder: (context, child) {
        return CustomPaint(
          painter: Globe3DPainter(
            agencies: _agencies,
            rotation: _rotationAnimation.value,
            selectedAgency: _selectedAgency,
            showHeatmap: _showHeatmap,
            filterComponent: _filterComponent,
          ),
          child: GestureDetector(
            onTapDown: (details) => _handleGlobeTap(details.localPosition),
          ),
        );
      },
    );
  }

  Widget _buildHeatmapView() {
    return CustomPaint(
      painter: HeatmapPainter(
        agencies: _agencies,
        selectedAgency: _selectedAgency,
        filterComponent: _filterComponent,
      ),
      child: GestureDetector(
        onTapDown: (details) => _handleHeatmapTap(details.localPosition),
      ),
    );
  }

  Widget _buildNetworkView() {
    return CustomPaint(
      painter: NetworkPainter(
        agencies: _agencies,
        selectedAgency: _selectedAgency,
        filterComponent: _filterComponent,
      ),
      child: GestureDetector(
        onTapDown: (details) => _handleNetworkTap(details.localPosition),
      ),
    );
  }

  Widget _buildAgencyDetailsPanel() {
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
            'Agency Details',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          
          const SizedBox(height: 16),
          
          if (_selectedAgency != null) ...[
            _buildAgencyProfile(_selectedAgency!),
          ] else ...[
            const Center(
              child: Text(
                'Select an agency to view details',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAgencyProfile(AgencyNode agency) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Agency Header
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: agency.getStatusColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    agency.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${agency.state} • ${agency.component}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Capacity Metrics
            _buildMetricCard('Capacity Utilization', '${agency.capacityUtilization}%', 
                _getCapacityColor(agency.capacityUtilization)),
            _buildMetricCard('Active Projects', '${agency.activeProjects}', Colors.blue),
            _buildMetricCard('Performance Score', '${agency.performanceScore}/100', Colors.green),
            _buildMetricCard('Last Updated', _formatDate(agency.lastUpdated), Colors.grey),

            const SizedBox(height: 16),

            // Quick Actions
            const Text(
              'Quick Actions',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            
            _buildActionButton('View Projects', Icons.folder, () => _viewAgencyProjects(agency)),
            _buildActionButton('Contact Agency', Icons.phone, () => _contactAgency(agency)),
            _buildActionButton('Performance Report', Icons.analytics, () => _viewPerformanceReport(agency)),
            
            if (agency.capacityUtilization > 80)
              _buildActionButton('Suggest Rebalance', Icons.balance, () => _suggestRebalance(agency)),
          ],
        ),
      ),
    );
  }

  // Helper methods and event handlers
  void _handleGlobeTap(Offset position) {
    final agency = _findAgencyAtPosition(position);
    setState(() => _selectedAgency = agency);
  }

  void _handleHeatmapTap(Offset position) {
    final agency = _findAgencyAtPosition(position);
    setState(() => _selectedAgency = agency);
  }

  void _handleNetworkTap(Offset position) {
    final agency = _findAgencyAtPosition(position);
    setState(() => _selectedAgency = agency);
  }

  AgencyNode? _findAgencyAtPosition(Offset position) {
    // Simplified agency detection logic
    for (final agency in _agencies) {
      final agencyRect = Rect.fromCenter(
        center: Offset(agency.x, agency.y),
        width: 40,
        height: 40,
      );
      if (agencyRect.contains(position)) {
        return agency;
      }
    }
    return null;
  }

  void _loadAgencies() {
    // Simulate loading agencies
    setState(() {
      _agencies = _generateMockAgencies();
    });
  }

  List<AgencyNode> _generateMockAgencies() {
    final random = math.Random();
    return List.generate(25, (index) {
      return AgencyNode(
        id: 'agency_$index',
        name: 'Agency ${String.fromCharCode(65 + index)}',
        state: ['Maharashtra', 'Karnataka', 'Tamil Nadu', 'Gujarat', 'Rajasthan'][index % 5],
        component: ['adarsh_gram', 'gia', 'hostel', 'infrastructure'][index % 4],
        latitude: 8.0 + random.nextDouble() * 30,
        longitude: 68.0 + random.nextDouble() * 30,
        x: 50 + random.nextDouble() * 300,
        y: 50 + random.nextDouble() * 200,
        capacityUtilization: 20 + random.nextInt(80),
        activeProjects: 1 + random.nextInt(15),
        performanceScore: 60 + random.nextInt(40),
        lastUpdated: DateTime.now().subtract(Duration(hours: random.nextInt(24))),
        status: AgencyStatus.values[random.nextInt(AgencyStatus.values.length)],
      );
    });
  }

  @override
  void dispose() {
    _globeRotationController.dispose();
    _pulseController.dispose();
    _realTimeSubscription?.cancel();
    super.dispose();
  }
}

// Data Models
class AgencyNode {
  final String id;
  final String name;
  final String state;
  final String component;
  final double latitude;
  final double longitude;
  final double x;
  final double y;
  final int capacityUtilization;
  final int activeProjects;
  final int performanceScore;
  final DateTime lastUpdated;
  final AgencyStatus status;

  AgencyNode({
    required this.id,
    required this.name,
    required this.state,
    required this.component,
    required this.latitude,
    required this.longitude,
    required this.x,
    required this.y,
    required this.capacityUtilization,
    required this.activeProjects,
    required this.performanceScore,
    required this.lastUpdated,
    required this.status,
  });

  Color getStatusColor() {
    switch (status) {
      case AgencyStatus.active:
        return Colors.green;
      case AgencyStatus.overloaded:
        return Colors.red;
      case AgencyStatus.underutilized:
        return Colors.orange;
      case AgencyStatus.offline:
        return Colors.grey;
    }
  }
}

enum AgencyStatus { active, overloaded, underutilized, offline }
