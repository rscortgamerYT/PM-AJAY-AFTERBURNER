import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../widgets/components/hero_card.dart';
import '../../widgets/feature_access_panel.dart';
import '../../services/supabase_service.dart';
import '../../models/user_role.dart';
import '../../utils/navigation_helper.dart';

class AuditorDashboardHome extends StatefulWidget {
  final UserRole userRole;

  const AuditorDashboardHome({
    super.key,
    required this.userRole,
  });

  @override
  State<AuditorDashboardHome> createState() => _AuditorDashboardHomeState();
}

class _AuditorDashboardHomeState extends State<AuditorDashboardHome> {
  bool _isLoading = true;
  int _pendingTransfers = 0;
  int _evidenceItems = 0;
  int _complianceChecks = 0;
  int _flaggedItems = 0;
  Map<String, dynamic> _riskData = {};
  List<Map<String, dynamic>> _auditQueue = [];

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);
    
    try {
      final results = await Future.wait([
        _getPendingTransfersCount(),
        _getEvidenceItemsCount(),
        _getComplianceChecksCount(),
        _getFlaggedItemsCount(),
        SupabaseService.getAuditRisk(),
        _getAuditQueue(),
      ]);

      setState(() {
        _pendingTransfers = results[0] as int;
        _evidenceItems = results[1] as int;
        _complianceChecks = results[2] as int;
        _flaggedItems = results[3] as int;
        _riskData = results[4] as Map<String, dynamic>;
        _auditQueue = results[5] as List<Map<String, dynamic>>;
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

  Future<int> _getPendingTransfersCount() async {
    final transfers = await SupabaseService.query(
      'fund_transfers',
      filters: {'audit_status': 'pending'},
    );
    return transfers.length;
  }

  Future<int> _getEvidenceItemsCount() async {
    final evidence = await SupabaseService.query(
      'evidence_reports',
      filters: {'audit_status': 'pending'},
    );
    return evidence.length;
  }

  Future<int> _getComplianceChecksCount() async {
    final checks = await SupabaseService.query(
      'project_milestones',
      filters: {'compliance_status': 'pending_audit'},
    );
    return checks.length;
  }

  Future<int> _getFlaggedItemsCount() async {
    final flags = await SupabaseService.query(
      'audit_flags',
      filters: {'status': 'open'},
    );
    return flags.length;
  }

  Future<List<Map<String, dynamic>>> _getAuditQueue() async {
    return await SupabaseService.query(
      'audit_queue_view',
      orderBy: 'priority_score',
      ascending: false,
      limit: 10,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auditor Dashboard'),
        backgroundColor: const Color(0xFF7B1FA2),
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
                    child: _buildRiskMap(),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: _buildAuditQueue(),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildQuickActions(),
              const SizedBox(height: 24),
              FeatureAccessPanel(userRole: widget.userRole),
              const SizedBox(height: 24),
              _buildRecentActivity(),
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
          title: 'Pending Transfers',
          value: _isLoading ? '...' : _pendingTransfers.toString(),
          subtitle: '8 high priority',
          icon: Symbols.pending_actions,
          color: Colors.orange,
          isLoading: _isLoading,
          onTap: () => _navigateToFundLedger(),
        ),
        HeroCard(
          title: 'Evidence Items',
          value: _isLoading ? '...' : _evidenceItems.toString(),
          subtitle: 'Awaiting review',
          icon: Symbols.fact_check,
          color: Colors.blue,
          isLoading: _isLoading,
          onTap: () => _navigateToEvidenceAudit(),
        ),
        HeroCard(
          title: 'Compliance Checks',
          value: _isLoading ? '...' : _complianceChecks.toString(),
          subtitle: 'Due this week',
          icon: Symbols.verified,
          color: Colors.green,
          isLoading: _isLoading,
          onTap: () => _navigateToCompliance(),
        ),
        HeroCard(
          title: 'Flagged Items',
          value: _isLoading ? '...' : _flaggedItems.toString(),
          subtitle: 'Requires action',
          icon: Symbols.flag,
          color: Colors.red,
          isLoading: _isLoading,
          onTap: () => _navigateToFlaggedItems(),
        ),
      ],
    );
  }

  Widget _buildRiskMap() {
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
                  'Risk Assessment Heatmap',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DropdownButton<String>(
                  value: 'all',
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('All States')),
                    DropdownMenuItem(value: 'high_risk', child: Text('High Risk')),
                    DropdownMenuItem(value: 'medium_risk', child: Text('Medium Risk')),
                    DropdownMenuItem(value: 'low_risk', child: Text('Low Risk')),
                  ],
                  onChanged: (value) => _filterByRisk(value),
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
                  : _buildRiskMapView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRiskMapView() {
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
                'State Risk Choropleth',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Risk assessment visualization by state',
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
              _buildRiskLegend('High Risk', Colors.red),
              const SizedBox(width: 12),
              _buildRiskLegend('Medium Risk', Colors.orange),
              const SizedBox(width: 12),
              _buildRiskLegend('Low Risk', Colors.green),
            ],
          ),
        ),
        Positioned(
          top: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Risk Summary',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'High: ${_riskData['high_risk_count'] ?? 0}',
                  style: const TextStyle(fontSize: 10, color: Colors.red),
                ),
                Text(
                  'Medium: ${_riskData['medium_risk_count'] ?? 0}',
                  style: const TextStyle(fontSize: 10, color: Colors.orange),
                ),
                Text(
                  'Low: ${_riskData['low_risk_count'] ?? 0}',
                  style: const TextStyle(fontSize: 10, color: Colors.green),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRiskLegend(String label, Color color) {
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

  Widget _buildAuditQueue() {
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
                  'Priority Audit Queue',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: _viewFullQueue,
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: _auditQueue.isEmpty
                  ? Center(
                      child: Text(
                        'No items in queue',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _auditQueue.length,
                      itemBuilder: (context, index) {
                        final item = _auditQueue[index];
                        return _buildQueueItem(item);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQueueItem(Map<String, dynamic> item) {
    final priority = item['priority'] ?? 'medium';
    final type = item['audit_type'] ?? 'general';
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getPriorityColor(priority).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getAuditTypeIcon(type),
            size: 16,
            color: _getPriorityColor(priority),
          ),
        ),
        title: Text(
          item['item_name'] ?? '',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${item['entity_type']} • ${item['location']}',
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  decoration: BoxDecoration(
                    color: _getPriorityColor(priority).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    priority.toUpperCase(),
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      color: _getPriorityColor(priority),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Due: ${_formatDate(item['due_date'])}',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Symbols.arrow_forward_ios, size: 16),
          onPressed: () => _openAuditItem(item['id']),
        ),
        dense: true,
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
                  'Fund Ledger',
                  Symbols.account_balance,
                  Colors.blue,
                  _navigateToFundLedger,
                ),
                _buildActionCard(
                  'Evidence Audit',
                  Symbols.fact_check,
                  Colors.green,
                  _navigateToEvidenceAudit,
                ),
                _buildActionCard(
                  'Compliance',
                  Symbols.verified,
                  Colors.orange,
                  _navigateToCompliance,
                ),
                _buildActionCard(
                  'Generate Report',
                  Symbols.analytics,
                  Colors.purple,
                  _navigateToReports,
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

  Widget _buildRecentActivity() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Audit Activity',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildActivityTimeline(),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityTimeline() {
    final activities = [
      {
        'title': 'Fund Transfer Approved',
        'description': 'Maharashtra → MH_AGENCY_001 - ₹15 Cr',
        'time': '2 hours ago',
        'type': 'approval',
      },
      {
        'title': 'Evidence Flagged',
        'description': 'CHC Construction - Missing documentation',
        'time': '4 hours ago',
        'type': 'flag',
      },
      {
        'title': 'Compliance Check Completed',
        'description': 'Project PRJ-2024-001 - All requirements met',
        'time': '6 hours ago',
        'type': 'compliance',
      },
    ];

    return Column(
      children: activities.map((activity) => _buildActivityItem(activity)).toList(),
    );
  }

  Widget _buildActivityItem(Map<String, dynamic> activity) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getActivityColor(activity['type']).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              _getActivityIcon(activity['type']),
              size: 20,
              color: _getActivityColor(activity['type']),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity['title'],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  activity['description'],
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  activity['time'],
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getAuditTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'financial':
        return Symbols.account_balance;
      case 'physical':
        return Symbols.location_on;
      case 'compliance':
        return Symbols.verified;
      case 'evidence':
        return Symbols.fact_check;
      default:
        return Symbols.audit;
    }
  }

  Color _getActivityColor(String type) {
    switch (type) {
      case 'approval':
        return Colors.green;
      case 'flag':
        return Colors.red;
      case 'compliance':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getActivityIcon(String type) {
    switch (type) {
      case 'approval':
        return Symbols.check_circle;
      case 'flag':
        return Symbols.flag;
      case 'compliance':
        return Symbols.verified;
      default:
        return Symbols.circle;
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

  void _filterByRisk(String? risk) {
    // Implement risk filtering
  }

  void _viewFullQueue() {
    NavigationHelper.navigateToAuditorQueue(context);
  }

  void _openAuditItem(String itemId) {
    NavigationHelper.showInfoMessage(context, 'Opening audit item: $itemId');
    NavigationHelper.navigateToAuditorQueue(context);
  }

  void _navigateToFundLedger() {
    NavigationHelper.navigateToAuditorFundLedger(context);
  }

  void _navigateToEvidenceAudit() {
    NavigationHelper.navigateToAuditorEvidence(context);
  }

  void _navigateToCompliance() {
    NavigationHelper.navigateToAuditorCompliance(context);
  }

  void _navigateToFlaggedItems() {
    NavigationHelper.navigateToAuditorFlags(context);
  }

  void _navigateToReports() {
    NavigationHelper.navigateToAuditorReports(context);
  }
}
