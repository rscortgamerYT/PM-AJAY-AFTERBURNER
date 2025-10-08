import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../widgets/components/hero_card.dart';
import '../../widgets/components/filter_bar.dart';
import '../../widgets/feature_access_panel.dart';
import '../../services/supabase_service.dart';
import '../../models/user_role.dart';
import '../../utils/navigation_helper.dart';

class CentreDashboardHome extends StatefulWidget {
  final UserRole userRole;

  const CentreDashboardHome({
    super.key,
    required this.userRole,
  });

  @override
  State<CentreDashboardHome> createState() => _CentreDashboardHomeState();
}

class _CentreDashboardHomeState extends State<CentreDashboardHome> {
  bool _isLoading = true;
  Map<String, dynamic> _budgetData = {};
  Map<String, dynamic> _performanceData = {};
  List<dynamic> _fundFlowData = [];
  int _pendingRequests = 0;
  int _activeProjects = 0;
  int _criticalAlerts = 0;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);
    
    try {
      final results = await Future.wait([
        SupabaseService.getCentreBudget(),
        SupabaseService.getStatePerformance(),
        SupabaseService.getFundFlow(),
        _getPendingRequestsCount(),
        _getActiveProjectsCount(),
        _getCriticalAlertsCount(),
      ]);

      setState(() {
        _budgetData = results[0] as Map<String, dynamic>;
        _performanceData = results[1] as Map<String, dynamic>;
        _fundFlowData = results[2] as List<dynamic>;
        _pendingRequests = results[3] as int;
        _activeProjects = results[4] as int;
        _criticalAlerts = results[5] as int;
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

  Future<int> _getPendingRequestsCount() async {
    final requests = await SupabaseService.query(
      'state_requests',
      filters: {'status': 'submitted'},
    );
    return requests.length;
  }

  Future<int> _getActiveProjectsCount() async {
    final projects = await SupabaseService.query(
      'projects',
      filters: {'status': 'active'},
    );
    return projects.length;
  }

  Future<int> _getCriticalAlertsCount() async {
    final alerts = await SupabaseService.query(
      'notifications',
      filters: {
        'priority': 'high',
        'related_entity_type': 'audit',
        'is_resolved': false,
      },
    );
    return alerts.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Centre Admin Dashboard'),
        backgroundColor: const Color(0xFF3F51B5),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _loadDashboardData,
            icon: const Icon(Symbols.refresh),
            tooltip: 'Refresh Data',
          ),
          IconButton(
            onPressed: _navigateToReports,
            icon: const Icon(Symbols.analytics),
            tooltip: 'View Reports',
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
              _buildMapPanel(),
              const SizedBox(height: 24),
              _buildFundFlowSection(),
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
          title: 'Total Budget Disbursed',
          value: _isLoading 
              ? '...' 
              : '₹${_formatAmount(_budgetData['total_disbursed']?.toDouble() ?? 0)}',
          subtitle: 'Across all states',
          icon: Symbols.account_balance_wallet,
          color: Colors.green,
          isLoading: _isLoading,
          trendValue: _budgetData['growth_rate']?.toDouble(),
          isPositiveTrend: (_budgetData['growth_rate']?.toDouble() ?? 0) > 0,
          trend: '+12% vs last quarter',
          onTap: () => _navigateToFunds(),
        ),
        HeroCard(
          title: 'States Pending Review',
          value: _isLoading ? '...' : _pendingRequests.toString(),
          subtitle: '${_getPriorityCount()} high priority',
          icon: Symbols.pending_actions,
          color: Colors.orange,
          isLoading: _isLoading,
          onTap: () => _navigateToRequests(),
        ),
        HeroCard(
          title: 'Active Projects',
          value: _isLoading ? '...' : _activeProjects.toString(),
          subtitle: 'Nationwide',
          icon: Symbols.work,
          color: Colors.blue,
          isLoading: _isLoading,
          onTap: () => _navigateToProjects(),
        ),
        HeroCard(
          title: 'Critical Alerts',
          value: _isLoading ? '...' : _criticalAlerts.toString(),
          subtitle: 'Requires attention',
          icon: Symbols.warning,
          color: Colors.red,
          isLoading: _isLoading,
          onTap: () => _navigateToAlerts(),
        ),
      ],
    );
  }

  Widget _buildMapPanel() {
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
                  'Nationwide Performance Heatmap',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    _buildLegendItem('High Performance', Colors.green),
                    const SizedBox(width: 16),
                    _buildLegendItem('Medium Performance', Colors.orange),
                    const SizedBox(width: 16),
                    _buildLegendItem('Needs Attention', Colors.red),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: 400,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildInteractiveMap(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInteractiveMap() {
    // This would integrate with flutter_map or similar
    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Symbols.map,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              const Text(
                'Interactive India Map',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Choropleth visualization with state performance data',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _loadMapData,
                icon: const Icon(Symbols.refresh),
                label: const Text('Load Map Data'),
              ),
            ],
          ),
        ),
        Positioned(
          top: 16,
          right: 16,
          child: Column(
            children: [
              IconButton(
                onPressed: _zoomIn,
                icon: const Icon(Symbols.add),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
              ),
              IconButton(
                onPressed: _zoomOut,
                icon: const Icon(Symbols.remove),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFundFlowSection() {
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
                  'Fund Flow: Centre → States → Agencies',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: _viewDetailedFlow,
                  icon: const Icon(Symbols.open_in_new),
                  label: const Text('View Details'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: 300,
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildSankeyChart(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSankeyChart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Symbols.account_tree,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          const Text(
            'Sankey Chart Visualization',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Centre (₹2,450 Cr) → 28 States → 450+ Agencies',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            children: [
              _buildFlowStat('Total Allocated', '₹2,450 Cr', Colors.blue),
              _buildFlowStat('Disbursed', '₹1,960 Cr', Colors.green),
              _buildFlowStat('Utilized', '₹1,470 Cr', Colors.orange),
              _buildFlowStat('Pending', '₹490 Cr', Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFlowStat(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
            ),
          ),
        ],
      ),
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
                  'Review Requests',
                  Symbols.gavel,
                  Colors.orange,
                  _navigateToRequests,
                ),
                _buildActionCard(
                  'Fund Allocation',
                  Symbols.account_balance,
                  Colors.green,
                  _navigateToFunds,
                ),
                _buildActionCard(
                  'View Analytics',
                  Symbols.analytics,
                  Colors.blue,
                  _navigateToAnalytics,
                ),
                _buildActionCard(
                  'Manage Alerts',
                  Symbols.warning,
                  Colors.red,
                  _navigateToAlerts,
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

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  String _formatAmount(double amount) {
    if (amount >= 10000000) {
      return '${(amount / 10000000).toStringAsFixed(1)} Cr';
    } else if (amount >= 100000) {
      return '${(amount / 100000).toStringAsFixed(1)} L';
    }
    return amount.toStringAsFixed(0);
  }

  int _getPriorityCount() {
    // Mock calculation - would come from actual data
    return (_pendingRequests * 0.3).round();
  }

  void _loadMapData() {
    // Implement map data loading
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Loading map data...')),
    );
  }

  void _zoomIn() {
    // Implement map zoom in
  }

  void _zoomOut() {
    // Implement map zoom out
  }

  void _viewDetailedFlow() {
    // Navigate to detailed fund flow analysis
  }

  void _navigateToRequests() {
    NavigationHelper.navigateToCentreRequests(context);
  }

  void _navigateToFunds() {
    NavigationHelper.navigateToCentreFunds(context);
  }

  void _navigateToProjects() {
    NavigationHelper.navigateToCentreProjects(context);
  }

  void _navigateToAlerts() {
    NavigationHelper.navigateToCentreAlerts(context);
  }

  void _navigateToAnalytics() {
    NavigationHelper.navigateToCentreAnalytics(context);
  }

  void _navigateToReports() {
    NavigationHelper.navigateToCentreReports(context);
  }
}
