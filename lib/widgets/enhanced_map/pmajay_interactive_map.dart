import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;

// Enhanced Map System with Real-Time Data Integration
enum MapMode { overview, fund_flow, project_tracking, audit }

class PMajayInteractiveMap extends StatefulWidget {
  final MapMode mode;
  final String? userRole;
  final Map<String, dynamic>? filters;

  const PMajayInteractiveMap({
    super.key,
    this.mode = MapMode.overview,
    this.userRole,
    this.filters,
  });

  @override
  State<PMajayInteractiveMap> createState() => _PMajayInteractiveMapState();
}

class _PMajayInteractiveMapState extends State<PMajayInteractiveMap>
    with TickerProviderStateMixin {
  bool _isLoading = true;
  bool _hasError = false;
  String? _errorMessage;
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;
  
  List<GeofenceRegion> _geofences = [];
  List<ProjectMarker> _projects = [];
  List<FundFlowPath> _fundPaths = [];
  StreamSubscription? _realTimeSubscription;
  
  // Map interaction state
  Offset? _selectedPoint;
  ProjectMarker? _selectedProject;
  GeofenceRegion? _selectedGeofence;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeMap();
    _subscribeToRealTimeUpdates();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _animationController.repeat(reverse: true);
  }

  Future<void> _initializeMap() async {
    try {
      setState(() => _isLoading = true);
      
      // Load data in parallel for better performance
      await Future.wait([
        _loadGeofences(),
        _loadProjects(),
        if (widget.mode == MapMode.fund_flow) _loadFundFlowPaths(),
      ]);
      
      if (mounted) {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint('Error initializing map: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
        _showErrorSnackbar('Failed to load map data');
      }
    }
  }

  void _subscribeToRealTimeUpdates() {
    // Simulate real-time updates
    _realTimeSubscription = Stream.periodic(const Duration(seconds: 5))
        .listen((_) => _updateRealTimeData());
  }

  Future<void> _loadGeofences() async {
    try {
      // Simulate API call with realistic state data
      await Future.delayed(const Duration(milliseconds: 300));
      
      final states = [
        {
          'id': 'MH',
          'name': 'Maharashtra',
          'status': GeofenceStatus.active,
          'projects': 78,
          'budget': 45000000000, // 4,500 Cr
          'utilization': 0.82,
          'color': Colors.green,
        },
        {
          'id': 'KA',
          'name': 'Karnataka',
          'status': GeofenceStatus.warning,
          'projects': 65,
          'budget': 38000000000, // 3,800 Cr
          'utilization': 0.65,
          'color': Colors.orange,
        },
        {
          'id': 'TN',
          'name': 'Tamil Nadu',
          'status': GeofenceStatus.active,
          'projects': 72,
          'budget': 42000000000, // 4,200 Cr
          'utilization': 0.78,
          'color': Colors.green,
        },
        // Add more states as needed
      ];
      
      if (mounted) {
        setState(() {
          _geofences = states.map((state) => GeofenceRegion(
            id: state['id'],
            name: state['name'],
            coordinates: _generateStatePolygon(state['name']),
            status: state['status'],
            metadata: {
              'projects': state['projects'],
              'budget': '₹${(state['budget'] / 10000000).toStringAsFixed(0)} Cr',
              'utilization': state['utilization'],
              'color': state['color'],
            },
          )).toList();
        });
      }
    } catch (e) {
      debugPrint('Error loading geofences: $e');
      rethrow;
    }
        GeofenceRegion(
          id: 'TN',
          name: 'Tamil Nadu',
          coordinates: _generateStatePolygon('Tamil Nadu'),
          status: GeofenceStatus.active,
          metadata: {'projects': 38, 'budget': '₹2,100 Cr'},
        ),
      ];
    });
  }

  Future<void> _loadProjects() async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    setState(() {
      _projects = [
        ProjectMarker(
          id: 'MH-001',
          name: 'Rural Road Project MH-001',
          latitude: 19.0760,
          longitude: 72.8777,
          status: ProjectStatus.inProgress,
          component: ProjectComponent.infrastructure,
          budget: 50000000,
          utilization: 0.75,
        ),
        ProjectMarker(
          id: 'KA-045',
          name: 'Water Supply System KA-045',
          latitude: 12.9716,
          longitude: 77.5946,
          status: ProjectStatus.completed,
          component: ProjectComponent.water,
          budget: 35000000,
          utilization: 0.92,
        ),
        ProjectMarker(
          id: 'TN-023',
          name: 'School Building TN-023',
          latitude: 13.0827,
          longitude: 80.2707,
          status: ProjectStatus.flagged,
          component: ProjectComponent.education,
          budget: 25000000,
          utilization: 0.45,
        ),
      ];
    });
  }

  Future<void> _loadFundFlowPaths() async {
    await Future.delayed(const Duration(milliseconds: 400));
    
    setState(() {
      _fundPaths = [
        FundFlowPath(
          id: 'flow_1',
          source: const Offset(200, 100), // Centre
          destination: const Offset(300, 200), // Maharashtra
          amount: 50000000,
          color: Colors.blue,
          status: FundFlowStatus.active,
        ),
        FundFlowPath(
          id: 'flow_2',
          source: const Offset(200, 100), // Centre
          destination: const Offset(400, 300), // Karnataka
          amount: 35000000,
          color: Colors.green,
          status: FundFlowStatus.completed,
        ),
      ];
    });
  }

  void _updateRealTimeData() {
    // Simulate real-time project status updates
    if (_projects.isNotEmpty) {
      final random = math.Random();
      final projectIndex = random.nextInt(_projects.length);
      final project = _projects[projectIndex];
      
      setState(() {
        _projects[projectIndex] = project.copyWith(
          utilization: math.min(1.0, project.utilization + random.nextDouble() * 0.05),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue[50]!,
            Colors.white,
          ],
        ),
      ),
      child: Stack(
        children: [
          // Base Map
          CustomPaint(
            painter: IndiaMapPainter(
              geofences: _geofences,
              selectedGeofence: _selectedGeofence,
            ),
            size: Size.infinite,
          ),
          
          // Project Markers
          ...._buildProjectMarkers(),
          
          // Fund Flow Animation Layer
          if (widget.mode == MapMode.fund_flow)
            CustomPaint(
              painter: FundFlowPainter(
                paths: _fundPaths,
                animationValue: _pulseAnimation.value,
              ),
              size: Size.infinite,
            ),
          
          // Interactive Controls
          Positioned(
            top: 16,
            left: 16,
            child: _buildControlPanel(),
          ),
          
          // Legend
          Positioned(
            bottom: 16,
            right: 16,
            child: _buildLegend(),
          ),
          
          // Selected Item Details
          if (_selectedProject != null)
            Positioned(
              top: 80,
              left: 16,
              child: _buildProjectDetailsCard(_selectedProject!),
            ),
        ],
      ),
    );
  }

  List<Widget> _buildProjectMarkers() {
    return _projects.map((project) {
      return Positioned(
        left: _getProjectX(project) - 20,
        top: _getProjectY(project) - 20,
        child: GestureDetector(
          onTap: () => _selectProject(project),
          child: AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              final isSelected = _selectedProject?.id == project.id;
              final scale = isSelected ? _pulseAnimation.value : 1.0;
              
              return Transform.scale(
                scale: scale,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _getProjectStatusColor(project.status),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    _getProjectIcon(project.component),
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              );
            },
          ),
        ),
      );
    }).toList();
  }

  Widget _buildControlPanel() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Map Controls',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            
            // Mode selector
            DropdownButton<MapMode>(
              value: widget.mode,
              items: MapMode.values.map((mode) {
                return DropdownMenuItem(
                  value: mode,
                  child: Text(_getModeName(mode)),
                );
              }).toList(),
              onChanged: (mode) {
                // Handle mode change
              },
            ),
            
            const SizedBox(height: 8),
            
            // Refresh button
            IconButton(
              onPressed: _refreshData,
              icon: const Icon(Icons.refresh),
              tooltip: 'Refresh Data',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Legend',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            
            _buildLegendItem(Colors.green, 'Active Projects'),
            _buildLegendItem(Colors.blue, 'In Progress'),
            _buildLegendItem(Colors.orange, 'Under Review'),
            _buildLegendItem(Colors.red, 'Flagged'),
            
            if (widget.mode == MapMode.fund_flow) ...[
              const SizedBox(height: 8),
              _buildLegendItem(Colors.blue, 'Fund Flow'),
              _buildLegendItem(Colors.green, 'Completed Transfer'),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectDetailsCard(ProjectMarker project) {
    return Card(
      child: Container(
        width: 250,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    project.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => setState(() => _selectedProject = null),
                  icon: const Icon(Icons.close, size: 16),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            _buildDetailRow('Status', _getStatusName(project.status)),
            _buildDetailRow('Budget', '₹${(project.budget / 10000000).toStringAsFixed(1)} Cr'),
            _buildDetailRow('Utilization', '${(project.utilization * 100).toStringAsFixed(1)}%'),
            
            const SizedBox(height: 12),
            
            LinearProgressIndicator(
              value: project.utilization,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                _getProjectStatusColor(project.status),
              ),
            ),
            
            const SizedBox(height: 8),
            
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _viewProjectDetails(project),
                    child: const Text('View Details'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  // Helper Methods
  double _getProjectX(ProjectMarker project) {
    // Convert longitude to screen X coordinate
    return (project.longitude + 180) * 2; // Simplified conversion
  }

  double _getProjectY(ProjectMarker project) {
    // Convert latitude to screen Y coordinate
    return (90 - project.latitude) * 3; // Simplified conversion
  }

  Color _getProjectStatusColor(ProjectStatus status) {
    switch (status) {
      case ProjectStatus.completed:
        return Colors.green;
      case ProjectStatus.inProgress:
        return Colors.blue;
      case ProjectStatus.underReview:
        return Colors.orange;
      case ProjectStatus.flagged:
        return Colors.red;
      case ProjectStatus.planned:
        return Colors.grey;
    }
  }

  IconData _getProjectIcon(ProjectComponent component) {
    switch (component) {
      case ProjectComponent.infrastructure:
        return Icons.construction;
      case ProjectComponent.water:
        return Icons.water_drop;
      case ProjectComponent.education:
        return Icons.school;
      case ProjectComponent.healthcare:
        return Icons.local_hospital;
      case ProjectComponent.digital:
        return Icons.wifi;
    }
  }

  String _getModeName(MapMode mode) {
    switch (mode) {
      case MapMode.overview:
        return 'Overview';
      case MapMode.fund_flow:
        return 'Fund Flow';
      case MapMode.project_tracking:
        return 'Project Tracking';
      case MapMode.audit:
        return 'Audit View';
    }
  }

  String _getStatusName(ProjectStatus status) {
    switch (status) {
      case ProjectStatus.completed:
        return 'Completed';
      case ProjectStatus.inProgress:
        return 'In Progress';
      case ProjectStatus.underReview:
        return 'Under Review';
      case ProjectStatus.flagged:
        return 'Flagged';
      case ProjectStatus.planned:
        return 'Planned';
    }
  }

  List<Offset> _generateStatePolygon(String stateName) {
    // Generate simplified polygon coordinates for states
    final random = math.Random(stateName.hashCode);
    final centerX = 200 + random.nextDouble() * 400;
    final centerY = 150 + random.nextDouble() * 300;
    
    return List.generate(6, (index) {
      final angle = (index * 60) * math.pi / 180;
      final radius = 50 + random.nextDouble() * 30;
      return Offset(
        centerX + radius * math.cos(angle),
        centerY + radius * math.sin(angle),
      );
    });
  }

  void _selectProject(ProjectMarker project) {
    setState(() {
      _selectedProject = project;
    });
  }

  void _viewProjectDetails(ProjectMarker project) {
    // Navigate to detailed project view
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening details for ${project.name}')),
    );
  }

  void _refreshData() {
    _initializeMap();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _realTimeSubscription?.cancel();
    super.dispose();
  }
}

// Custom Painter for India Map
class IndiaMapPainter extends CustomPainter {
  final List<GeofenceRegion> geofences;
  final GeofenceRegion? selectedGeofence;

  IndiaMapPainter({
    required this.geofences,
    this.selectedGeofence,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw geofence regions
    for (final geofence in geofences) {
      _drawGeofence(canvas, geofence);
    }
  }

  void _drawGeofence(Canvas canvas, GeofenceRegion geofence) {
    final paint = Paint()
      ..color = _getGeofenceColor(geofence).withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = _getGeofenceColor(geofence)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final path = Path();
    if (geofence.coordinates.isNotEmpty) {
      path.moveTo(geofence.coordinates.first.dx, geofence.coordinates.first.dy);
      for (int i = 1; i < geofence.coordinates.length; i++) {
        path.lineTo(geofence.coordinates[i].dx, geofence.coordinates[i].dy);
      }
      path.close();
    }

    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);

    // Draw label
    if (geofence.coordinates.isNotEmpty) {
      final center = _calculateCenter(geofence.coordinates);
      final textPainter = TextPainter(
        text: TextSpan(
          text: geofence.name,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          center.dx - textPainter.width / 2,
          center.dy - textPainter.height / 2,
        ),
      );
    }
  }

  Color _getGeofenceColor(GeofenceRegion geofence) {
    switch (geofence.status) {
      case GeofenceStatus.active:
        return Colors.green;
      case GeofenceStatus.warning:
        return Colors.orange;
      case GeofenceStatus.critical:
        return Colors.red;
    }
  }

  Offset _calculateCenter(List<Offset> coordinates) {
    double x = 0, y = 0;
    for (final coord in coordinates) {
      x += coord.dx;
      y += coord.dy;
    }
    return Offset(x / coordinates.length, y / coordinates.length);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Custom Painter for Fund Flow Animation
class FundFlowPainter extends CustomPainter {
  final List<FundFlowPath> paths;
  final double animationValue;

  FundFlowPainter({
    required this.paths,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final path in paths) {
      _drawAnimatedFlow(canvas, path);
    }
  }

  void _drawAnimatedFlow(Canvas canvas, FundFlowPath fundPath) {
    final paint = Paint()
      ..color = fundPath.color
      ..strokeWidth = _calculateStrokeWidth(fundPath.amount)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Create curved path from source to destination
    final path = Path();
    final controlPoint = _calculateControlPoint(fundPath.source, fundPath.destination);
    
    path.moveTo(fundPath.source.dx, fundPath.source.dy);
    path.quadraticBezierTo(
      controlPoint.dx,
      controlPoint.dy,
      fundPath.destination.dx,
      fundPath.destination.dy,
    );

    // Draw the path
    canvas.drawPath(path, paint);

    // Draw animated flow particles
    _drawFlowParticles(canvas, path, fundPath);
  }

  void _drawFlowParticles(Canvas canvas, Path path, FundFlowPath fundPath) {
    final pathMetrics = path.computeMetrics();
    for (final metric in pathMetrics) {
      final particleCount = (fundPath.amount / 1000000).clamp(3, 15).toInt();
      
      for (int i = 0; i < particleCount; i++) {
        final progress = (animationValue + (i / particleCount)) % 1.0;
        final tangent = metric.getTangentForOffset(metric.length * progress);
        
        if (tangent != null) {
          final particlePaint = Paint()
            ..color = fundPath.color.withOpacity(0.8)
            ..style = PaintingStyle.fill;
          
          canvas.drawCircle(
            tangent.position,
            4.0,
            particlePaint,
          );
        }
      }
    }
  }

  double _calculateStrokeWidth(double amount) {
    return (amount / 10000000).clamp(2.0, 20.0);
  }

  Offset _calculateControlPoint(Offset source, Offset destination) {
    final midX = (source.dx + destination.dx) / 2;
    final midY = (source.dy + destination.dy) / 2;
    final distance = (destination - source).distance;
    
    return Offset(midX, midY - distance * 0.3);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Data Models
class GeofenceRegion {
  final String id;
  final String name;
  final List<Offset> coordinates;
  final GeofenceStatus status;
  final Map<String, dynamic> metadata;

  GeofenceRegion({
    required this.id,
    required this.name,
    required this.coordinates,
    required this.status,
    required this.metadata,
  });
}

class ProjectMarker {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final ProjectStatus status;
  final ProjectComponent component;
  final double budget;
  final double utilization;

  ProjectMarker({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.component,
    required this.budget,
    required this.utilization,
  });

  ProjectMarker copyWith({
    String? id,
    String? name,
    double? latitude,
    double? longitude,
    ProjectStatus? status,
    ProjectComponent? component,
    double? budget,
    double? utilization,
  }) {
    return ProjectMarker(
      id: id ?? this.id,
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      status: status ?? this.status,
      component: component ?? this.component,
      budget: budget ?? this.budget,
      utilization: utilization ?? this.utilization,
    );
  }
}

class FundFlowPath {
  final String id;
  final Offset source;
  final Offset destination;
  final double amount;
  final Color color;
  final FundFlowStatus status;

  FundFlowPath({
    required this.id,
    required this.source,
    required this.destination,
    required this.amount,
    required this.color,
    required this.status,
  });
}

// Enums
enum GeofenceStatus { active, warning, critical }
enum ProjectStatus { completed, inProgress, underReview, flagged, planned }
enum ProjectComponent { infrastructure, water, education, healthcare, digital }
enum FundFlowStatus { active, completed, pending, flagged }
