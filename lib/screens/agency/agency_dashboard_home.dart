import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../widgets/components/hero_card.dart';
import '../../widgets/feature_access_panel.dart';
import '../../services/supabase_service.dart';
import '../../models/user_role.dart';
import '../../utils/navigation_helper.dart';

class AgencyDashboardHome extends StatefulWidget {
  final UserRole userRole;

  const AgencyDashboardHome({
    super.key,
    required this.userRole,
  });

  @override
  State<AgencyDashboardHome> createState() => _AgencyDashboardHomeState();
}

class _AgencyDashboardHomeState extends State<AgencyDashboardHome> {
  bool _isLoading = true;
  int _activeProjects = 0;
  double _fundUtilization = 0;
  double _onTimeRate = 0;
  double _qualityRating = 0;
  List<Map<String, dynamic>> _projects = [];
  List<Map<String, dynamic>> _milestones = [];

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);
    
    try {
      final agencyId = widget.userRole.agencyId ?? 'AGENCY_001';
      
      final results = await Future.wait([
        _getActiveProjectsCount(agencyId),
        _getFundUtilization(agencyId),
        _getOnTimeRate(agencyId),
        _getQualityRating(agencyId),
        SupabaseService.getAgencyProjects(agencyId),
        _getUpcomingMilestones(agencyId),
      ]);

      setState(() {
        _activeProjects = results[0] as int;
        _fundUtilization = results[1] as double;
        _onTimeRate = results[2] as double;
        _qualityRating = results[3] as double;
        _projects = List<Map<String, dynamic>>.from(results[4] as List);
        _milestones = results[5] as List<Map<String, dynamic>>;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading dashboard: $e')),
        );
      }
    }
  }

  Future<int> _getActiveProjectsCount(String agencyId) async {
    final projects = await SupabaseService.query(
      'project_assignments',
      filters: {
        'agency_id': agencyId,
        'status': 'active',
      },
    );
    return projects.length;
  }

  Future<double> _getFundUtilization(String agencyId) async {
    final utilization = await SupabaseService.query(
      'fund_utilization',
      filters: {'agency_id': agencyId},
    );
    return utilization.isNotEmpty ? utilization.first['utilization_percentage']?.toDouble() ?? 0 : 0;
  }

  Future<double> _getOnTimeRate(String agencyId) async {
    final performance = await SupabaseService.query(
      'agency_performance',
      filters: {'agency_id': agencyId},
    );
    return performance.isNotEmpty ? performance.first['on_time_rate']?.toDouble() ?? 0 : 0;
  }

  Future<double> _getQualityRating(String agencyId) async {
    final rating = await SupabaseService.query(
      'agency_ratings',
      filters: {'agency_id': agencyId},
    );
    return rating.isNotEmpty ? rating.first['average_rating']?.toDouble() ?? 0 : 0;
  }

  Future<List<Map<String, dynamic>>> _getUpcomingMilestones(String agencyId) async {
    return await SupabaseService.query(
      'project_milestones',
      filters: {
        'agency_id': agencyId,
        'status': 'pending',
      },
      orderBy: 'due_date',
      limit: 10,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agency Dashboard'),
        backgroundColor: const Color(0xFF26A69A),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _loadDashboardData,
            icon: const Icon(Symbols.refresh),
            tooltip: 'Refresh Data',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadDashboardData,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeroCards(),
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildCoverageMap(),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: _buildProjectsList(),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildGanttTimeline(),
              const SizedBox(height: 24),
              FeatureAccessPanel(userRole: widget.userRole),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroCards() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        HeroCard(
          title: 'Active Projects',
          value: _isLoading ? '...' : _activeProjects.toString(),
          subtitle: '2 due this week',
          icon: Symbols.work,
          color: Colors.blue,
          isLoading: _isLoading,
          onTap: () => _navigateToProjects(),
        ),
        HeroCard(
          title: 'Fund Utilization',
          value: _isLoading ? '...' : '${_fundUtilization.toInt()}%',
          subtitle: '₹65 Cr utilized',
          icon: Symbols.account_balance_wallet,
          color: Colors.green,
          isLoading: _isLoading,
          onTap: () => _navigateToFunds(),
        ),
        HeroCard(
          title: 'On-Time Rate',
          value: _isLoading ? '...' : '${_onTimeRate.toInt()}%',
          subtitle: 'Last 6 months',
          icon: Symbols.schedule,
          color: Colors.orange,
          isLoading: _isLoading,
          trendValue: 5.0,
          isPositiveTrend: true,
        ),
        HeroCard(
          title: 'Quality Rating',
          value: _isLoading ? '...' : '${_qualityRating.toStringAsFixed(1)}/5',
          subtitle: 'Audit average',
          icon: Symbols.star,
          color: Colors.purple,
          isLoading: _isLoading,
        ),
      ],
    );
  }

  Widget _buildCoverageMap() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Service Area Coverage',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: _editCoverage,
                  icon: const Icon(Symbols.edit_location, size: 16),
                  label: const Text('Edit'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: 300,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildCoverageMapView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoverageMapView() {
    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Symbols.location_on,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              const Text(
                'Coverage Area Map',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Editable geofence polygon - 42 sq km coverage',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 16,
          left: 16,
          child: Row(
            children: [
              _buildCoverageStats('Primary Zone', '25 sq km', Colors.green),
              const SizedBox(width: 12),
              _buildCoverageStats('Secondary Zone', '17 sq km', Colors.blue),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCoverageStats(String label, String area, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '$label: $area',
            style: TextStyle(fontSize: 10, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectsList() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Active Projects',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: _navigateToProjects,
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: _projects.isEmpty
                  ? Center(
                      child: Text(
                        'No active projects',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _projects.length,
                      itemBuilder: (context, index) {
                        final project = _projects[index];
                        return _buildProjectCard(project);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectCard(Map<String, dynamic> project) {
    final progress = project['progress_percentage']?.toDouble() ?? 0;
    final status = project['status'] ?? 'active';
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getStatusColor(status).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getStatusIcon(status),
            size: 20,
            color: _getStatusColor(status),
          ),
        ),
        title: Text(
          project['project_name'] ?? '',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: progress / 100,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(_getStatusColor(status)),
            ),
            const SizedBox(height: 4),
            Text(
              '${progress.toInt()}% complete',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Symbols.arrow_forward_ios, size: 16),
          onPressed: () => _openProject(project['id']),
        ),
        dense: true,
      ),
    );
  }

  Widget _buildGanttTimeline() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Project Timeline (Gantt View)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: _milestones.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Symbols.gantt_chart,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 8),
                          const Text('Gantt Chart Timeline'),
                          const SizedBox(height: 4),
                          Text(
                            'Project milestones and dependencies',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    )
                  : _buildTimelineView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineView() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: _milestones.length,
      itemBuilder: (context, index) {
        final milestone = _milestones[index];
        return Container(
          width: 150,
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                milestone['milestone_name'] ?? '',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                'Due: ${_formatDate(milestone['due_date'])}',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: _getMilestoneStatusColor(milestone['status']).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  milestone['status']?.toUpperCase() ?? '',
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: _getMilestoneStatusColor(milestone['status']),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickActions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: [
                _buildActionCard(
                  'Work Orders',
                  Symbols.assignment,
                  Colors.blue,
                  _navigateToWorkOrders,
                ),
                _buildActionCard(
                  'Submit Progress',
                  Symbols.upload,
                  Colors.green,
                  _navigateToProgressSubmission,
                ),
                _buildActionCard(
                  'Capabilities',
                  Symbols.settings,
                  Colors.orange,
                  _navigateToCapabilities,
                ),
                _buildActionCard(
                  'Registration',
                  Symbols.verified,
                  Colors.purple,
                  _navigateToRegistration,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.blue;
      case 'delayed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Symbols.play_circle;
      case 'pending':
        return Symbols.pending;
      case 'completed':
        return Symbols.check_circle;
      case 'delayed':
        return Symbols.warning;
      default:
        return Symbols.circle;
    }
  }

  Color _getMilestoneStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'in_progress':
        return Colors.blue;
      case 'pending':
        return Colors.orange;
      case 'overdue':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return '';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}';
    } catch (e) {
      return '';
    }
  }

  void _editCoverage() {
    NavigationHelper.navigateToAgencyCapabilities(context);
  }

  void _openProject(String projectId) {
    NavigationHelper.showInfoMessage(context, 'Opening project: $projectId');
    NavigationHelper.navigateToAgencyProjects(context);
  }

  void _navigateToProjects() {
    NavigationHelper.navigateToAgencyProjects(context);
  }

  void _navigateToFunds() {
    NavigationHelper.navigateToAgencyFunds(context);
  }

  void _navigateToWorkOrders() {
    NavigationHelper.navigateToAgencyWorkOrders(context);
  }

  void _navigateToProgressSubmission() {
    NavigationHelper.navigateToAgencyProgressSubmission(context);
  }

  void _navigateToCapabilities() {
    NavigationHelper.navigateToAgencyCapabilities(context);
  }

  void _navigateToRegistration() {
    NavigationHelper.navigateToAgencyRegistration(context);
  }
}
