import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../widgets/components/hero_card.dart';
import '../../widgets/feature_access_panel.dart';
import '../../services/supabase_service.dart';
import '../../models/user_role.dart';
import '../../utils/navigation_helper.dart';

class StateDashboardHome extends StatefulWidget {
  final UserRole userRole;

  const StateDashboardHome({
    super.key,
    required this.userRole,
  });

  @override
  State<StateDashboardHome> createState() => _StateDashboardHomeState();
}

class _StateDashboardHomeState extends State<StateDashboardHome> {
  bool _isLoading = true;
  double _fundBalance = 0;
  int _publicRequestsPending = 0;
  int _activeAgencies = 0;
  double _complianceScore = 0;
  List<Map<String, dynamic>> _recentNotifications = [];

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
    _subscribeToNotifications();
  }

  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);
    
    try {
      final stateCode = widget.userRole.stateCode ?? 'MH';
      
      final results = await Future.wait([
        _getFundBalance(stateCode),
        _getPublicRequestsCount(stateCode),
        _getActiveAgenciesCount(stateCode),
        _getComplianceScore(stateCode),
        _getRecentNotifications(),
      ]);

      setState(() {
        _fundBalance = results[0] as double;
        _publicRequestsPending = results[1] as int;
        _activeAgencies = results[2] as int;
        _complianceScore = results[3] as double;
        _recentNotifications = results[4] as List<Map<String, dynamic>>;
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

  Future<double> _getFundBalance(String stateCode) async {
    final balance = await SupabaseService.query(
      'fund_balances',
      filters: {'state_code': stateCode},
    );
    return balance.isNotEmpty ? balance.first['available_amount']?.toDouble() ?? 0 : 0;
  }

  Future<int> _getPublicRequestsCount(String stateCode) async {
    final requests = await SupabaseService.query(
      'public_requests',
      filters: {
        'state_code': stateCode,
        'status': 'submitted',
      },
    );
    return requests.length;
  }

  Future<int> _getActiveAgenciesCount(String stateCode) async {
    final agencies = await SupabaseService.query(
      'agencies',
      filters: {
        'state_code': stateCode,
        'status': 'active',
      },
    );
    return agencies.length;
  }

  Future<double> _getComplianceScore(String stateCode) async {
    final analytics = await SupabaseService.getStateAnalytics(stateCode);
    return analytics['compliance_score']?.toDouble() ?? 0;
  }

  Future<List<Map<String, dynamic>>> _getRecentNotifications() async {
    return await SupabaseService.query(
      'notifications',
      filters: {
        'recipient_role': 'state_officer',
        'recipient_id': widget.userRole.userId,
      },
      orderBy: 'created_at',
      ascending: false,
      limit: 10,
    );
  }

  void _subscribeToNotifications() {
    SupabaseService.subscribeToUserNotifications(
      widget.userRole.userId,
      (payload) {
        if (mounted) {
          setState(() {
            _recentNotifications.insert(0, payload.newRecord);
            if (_recentNotifications.length > 10) {
              _recentNotifications.removeLast();
            }
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.userRole.stateCode} State Dashboard'),
        backgroundColor: const Color(0xFF1976D2),
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
                    child: _buildDistrictMap(),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: _buildActivityFeed(),
                  ),
                ],
              ),
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
          title: 'Fund Balance',
          value: _isLoading ? '...' : '₹${_formatAmount(_fundBalance)}',
          subtitle: '78% utilized',
          icon: Symbols.account_balance_wallet,
          color: Colors.green,
          isLoading: _isLoading,
          onTap: () => _navigateToFunds(),
        ),
        HeroCard(
          title: 'Public Requests Pending',
          value: _isLoading ? '...' : _publicRequestsPending.toString(),
          subtitle: 'From 12 districts',
          icon: Symbols.pending_actions,
          color: Colors.orange,
          isLoading: _isLoading,
          onTap: () => _navigateToPublicRequests(),
        ),
        HeroCard(
          title: 'Active Agencies',
          value: _isLoading ? '...' : _activeAgencies.toString(),
          subtitle: 'Across 36 districts',
          icon: Symbols.business,
          color: Colors.blue,
          isLoading: _isLoading,
          onTap: () => _navigateToAgencies(),
        ),
        HeroCard(
          title: 'Compliance Score',
          value: _isLoading ? '...' : '${_complianceScore.toInt()}%',
          subtitle: '+5% this month',
          icon: Symbols.verified,
          color: Colors.purple,
          isLoading: _isLoading,
          trendValue: 5.0,
          isPositiveTrend: true,
          onTap: () => _navigateToCompliance(),
        ),
      ],
    );
  }

  Widget _buildDistrictMap() {
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
                  'District-wise Performance',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DropdownButton<String>(
                  value: 'all',
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('All Districts')),
                    DropdownMenuItem(value: 'mumbai', child: Text('Mumbai')),
                    DropdownMenuItem(value: 'pune', child: Text('Pune')),
                    DropdownMenuItem(value: 'nagpur', child: Text('Nagpur')),
                  ],
                  onChanged: (value) => _filterByDistrict(value),
                  underline: const SizedBox(),
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
                  : _buildDistrictMapView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDistrictMapView() {
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
              Text(
                '${widget.userRole.stateCode} District Map',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Interactive district performance visualization',
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
              _buildMapLegend('High Performance', Colors.green),
              const SizedBox(width: 12),
              _buildMapLegend('Medium Performance', Colors.orange),
              const SizedBox(width: 12),
              _buildMapLegend('Needs Attention', Colors.red),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMapLegend(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 10),
        ),
      ],
    );
  }

  Widget _buildActivityFeed() {
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
                  'Activity Feed',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: _viewAllNotifications,
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: _recentNotifications.isEmpty
                  ? Center(
                      child: Text(
                        'No recent activity',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _recentNotifications.length,
                      itemBuilder: (context, index) {
                        final notification = _recentNotifications[index];
                        return _buildNotificationItem(notification);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> notification) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: _getNotificationColor(notification['type']).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          _getNotificationIcon(notification['type']),
          size: 16,
          color: _getNotificationColor(notification['type']),
        ),
      ),
      title: Text(
        notification['title'] ?? '',
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        notification['message'] ?? '',
        style: const TextStyle(fontSize: 12),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        _formatTime(notification['created_at']),
        style: TextStyle(fontSize: 10, color: Colors.grey[500]),
      ),
      dense: true,
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
                  'Review Public Requests',
                  Symbols.people,
                  Colors.green,
                  _navigateToPublicRequests,
                ),
                _buildActionCard(
                  'Agency Registration',
                  Symbols.business,
                  Colors.blue,
                  _navigateToAgencyRequests,
                ),
                _buildActionCard(
                  'Project Allocation',
                  Symbols.assignment,
                  Colors.orange,
                  _navigateToProjectAllocation,
                ),
                _buildActionCard(
                  'Fund Release',
                  Symbols.payments,
                  Colors.purple,
                  _navigateToFundRelease,
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

  Color _getNotificationColor(String? type) {
    switch (type) {
      case 'request':
        return Colors.blue;
      case 'approval':
        return Colors.green;
      case 'alert':
        return Colors.red;
      case 'info':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getNotificationIcon(String? type) {
    switch (type) {
      case 'request':
        return Symbols.article;
      case 'approval':
        return Symbols.check_circle;
      case 'alert':
        return Symbols.warning;
      case 'info':
        return Symbols.info;
      default:
        return Symbols.notifications;
    }
  }

  String _formatAmount(double amount) {
    if (amount >= 10000000) {
      return '${(amount / 10000000).toStringAsFixed(1)} Cr';
    } else if (amount >= 100000) {
      return '${(amount / 100000).toStringAsFixed(1)} L';
    }
    return amount.toStringAsFixed(0);
  }

  String _formatTime(String? timestamp) {
    if (timestamp == null) return '';
    try {
      final dateTime = DateTime.parse(timestamp);
      final now = DateTime.now();
      final difference = now.difference(dateTime);
      
      if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h';
      } else {
        return '${difference.inDays}d';
      }
    } catch (e) {
      return '';
    }
  }

  void _filterByDistrict(String? district) {
    // Implement district filtering
  }

  void _viewAllNotifications() {
    NavigationHelper.navigateToStateNotifications(context);
  }

  void _navigateToFunds() {
    NavigationHelper.navigateToStateFunds(context);
  }

  void _navigateToPublicRequests() {
    NavigationHelper.navigateToStatePublicRequests(context);
  }

  void _navigateToAgencies() {
    NavigationHelper.navigateToStateAgencies(context);
  }

  void _navigateToCompliance() {
    NavigationHelper.navigateToStateCompliance(context);
  }

  void _navigateToAgencyRequests() {
    NavigationHelper.navigateToStateAgencyRequests(context);
  }

  void _navigateToProjectAllocation() {
    NavigationHelper.navigateToStateProjectAllocation(context);
  }

  void _navigateToFundRelease() {
    NavigationHelper.navigateToStateFundRelease(context);
  }
}
