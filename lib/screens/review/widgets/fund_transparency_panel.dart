import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../models/user_role.dart';
import '../../../models/review/fund_transparency.dart';

class FundTransparencyPanel extends StatefulWidget {
  final String level; // centre, state, agency
  final String levelId;
  final String levelName;
  final UserRole userRole;

  const FundTransparencyPanel({
    super.key,
    required this.level,
    required this.levelId,
    required this.levelName,
    required this.userRole,
  });

  @override
  State<FundTransparencyPanel> createState() => _FundTransparencyPanelState();
}

class _FundTransparencyPanelState extends State<FundTransparencyPanel>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedTimeframe = '30days';
  final List<FundTransparencyRecord> _transactions = _getDemoTransactions();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        _buildSummaryCards(),
        _buildTabs(),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildAllocationTab(),
              _buildUtilizationTab(),
              _buildAuditTab(),
              _buildReportsTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Symbols.account_balance_wallet,
              color: Colors.green,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Fund Transparency Panel',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${widget.levelName} Level - Real-time Fund Tracking',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const Spacer(),
          DropdownButton<String>(
            value: _selectedTimeframe,
            items: const [
              DropdownMenuItem(value: '7days', child: Text('Last 7 Days')),
              DropdownMenuItem(value: '30days', child: Text('Last 30 Days')),
              DropdownMenuItem(value: '90days', child: Text('Last 90 Days')),
              DropdownMenuItem(value: 'year', child: Text('This Year')),
            ],
            onChanged: (value) {
              setState(() {
                _selectedTimeframe = value!;
              });
            },
            underline: const SizedBox(),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    final summary = _calculateSummary();
    
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[50],
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              'Total Allocated',
              '₹${_formatAmount(summary.totalAllocated)}',
              Icons.trending_up,
              Colors.blue,
              '+12% vs last period',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              'Total Utilized',
              '₹${_formatAmount(summary.totalUtilized)}',
              Icons.payments,
              Colors.green,
              '${summary.utilizationPercentage.toStringAsFixed(1)}% utilized',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              'Pending Audit',
              '₹${_formatAmount(summary.totalPending)}',
              Icons.pending,
              Colors.orange,
              '${summary.pendingAuditCount} transactions',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              'On Hold',
              '₹${_formatAmount(summary.totalOnHold)}',
              Icons.pause_circle,
              Colors.red,
              'Requires attention',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String amount, IconData icon, Color color, String subtitle) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.trending_up,
                    size: 12,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              amount,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        indicatorColor: Theme.of(context).primaryColor,
        labelColor: Theme.of(context).primaryColor,
        unselectedLabelColor: Colors.grey[600],
        isScrollable: true,
        tabs: const [
          Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Symbols.account_tree, size: 16),
                SizedBox(width: 8),
                Text('Allocation'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Symbols.payments, size: 16),
                SizedBox(width: 8),
                Text('Utilization'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Symbols.verified, size: 16),
                SizedBox(width: 8),
                Text('Audit Status'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Symbols.analytics, size: 16),
                SizedBox(width: 8),
                Text('Reports'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllocationTab() {
    final allocations = _transactions.where((t) => t.type == FundTransactionType.allocation).toList();
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Fund Flow Visualization',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.account_tree, size: 48, color: Colors.grey),
                          SizedBox(height: 8),
                          Text('Sankey Diagram'),
                          Text('Fund Flow Visualization', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Recent Allocations',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ...allocations.take(10).map((transaction) => _buildTransactionItem(transaction)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUtilizationTab() {
    final utilizations = _transactions.where((t) => t.type == FundTransactionType.utilization).toList();
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Utilization Breakdown',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildUtilizationChart(),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildCategoryBreakdown(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Recent Utilizations',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ...utilizations.take(10).map((transaction) => _buildTransactionItem(transaction)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuditTab() {
    final auditTransactions = _transactions.where((t) => t.requiresAuditApproval).toList();
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Audit Status Overview',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildAuditStatusCard('Pending Audit', '24', Colors.orange),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildAuditStatusCard('Approved', '156', Colors.green),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildAuditStatusCard('Flagged', '8', Colors.red),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Transactions Requiring Audit',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ...auditTransactions.map((transaction) => _buildAuditTransactionItem(transaction)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Generate Reports',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.5,
                    children: [
                      _buildReportCard('Fund Utilization Report', Icons.pie_chart, Colors.blue),
                      _buildReportCard('Audit Compliance Report', Icons.verified, Colors.green),
                      _buildReportCard('Transaction History', Icons.history, Colors.orange),
                      _buildReportCard('PFMS Integration Report', Icons.integration_instructions, Colors.purple),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Recent Reports',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildRecentReportItem('Monthly Fund Utilization - March 2024', 'Generated 2 days ago'),
                  _buildRecentReportItem('Audit Compliance Summary - Q1 2024', 'Generated 1 week ago'),
                  _buildRecentReportItem('PFMS Transaction Report - February 2024', 'Generated 2 weeks ago'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(FundTransparencyRecord transaction) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: _getTransactionColor(transaction.type).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          _getTransactionIcon(transaction.type),
          size: 20,
          color: _getTransactionColor(transaction.type),
        ),
      ),
      title: Text(
        transaction.description,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        '${transaction.sourceName} → ${transaction.targetName}',
        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '₹${_formatAmount(transaction.amount)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _getTransactionColor(transaction.type),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: _getStatusColor(transaction.status).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              transaction.status.name.toUpperCase(),
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.bold,
                color: _getStatusColor(transaction.status),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuditTransactionItem(FundTransparencyRecord transaction) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          Icons.pending,
          size: 20,
          color: Colors.orange,
        ),
      ),
      title: Text(
        transaction.description,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        'Submitted ${_formatDate(transaction.transactionDate)}',
        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '₹${_formatAmount(transaction.amount)}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
          const Text(
            'PENDING AUDIT',
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUtilizationChart() {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.pie_chart, size: 48, color: Colors.grey),
            SizedBox(height: 8),
            Text('Utilization Chart'),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryBreakdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Category Breakdown',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        _buildCategoryItem('Infrastructure', 45.2, Colors.blue),
        _buildCategoryItem('Healthcare', 32.8, Colors.green),
        _buildCategoryItem('Education', 15.5, Colors.orange),
        _buildCategoryItem('Administration', 6.5, Colors.purple),
      ],
    );
  }

  Widget _buildCategoryItem(String category, double percentage, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              category,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Text(
            '${percentage.toStringAsFixed(1)}%',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuditStatusCard(String title, String count, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard(String title, IconData icon, Color color) {
    return Card(
      child: InkWell(
        onTap: () => _generateReport(title),
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

  Widget _buildRecentReportItem(String title, String subtitle) {
    return ListTile(
      leading: const Icon(Icons.description, color: Colors.blue),
      title: Text(title, style: const TextStyle(fontSize: 14)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      trailing: IconButton(
        icon: const Icon(Icons.download, size: 20),
        onPressed: () => _downloadReport(title),
      ),
    );
  }

  FundUtilizationSummary _calculateSummary() {
    // Mock calculation - in real app, this would come from API
    return FundUtilizationSummary(
      levelId: widget.levelId,
      levelType: widget.level,
      levelName: widget.levelName,
      totalAllocated: 250000000, // 250 Cr
      totalUtilized: 187500000,  // 187.5 Cr
      totalPending: 25000000,    // 25 Cr
      totalOnHold: 12500000,     // 12.5 Cr
      utilizationPercentage: 75.0,
      totalTransactions: _transactions.length,
      pendingAuditCount: _transactions.where((t) => t.requiresAuditApproval).length,
      lastUpdated: DateTime.now(),
    );
  }

  Color _getTransactionColor(FundTransactionType type) {
    switch (type) {
      case FundTransactionType.allocation:
        return Colors.blue;
      case FundTransactionType.disbursement:
        return Colors.green;
      case FundTransactionType.utilization:
        return Colors.orange;
      case FundTransactionType.refund:
        return Colors.purple;
      case FundTransactionType.adjustment:
        return Colors.red;
    }
  }

  IconData _getTransactionIcon(FundTransactionType type) {
    switch (type) {
      case FundTransactionType.allocation:
        return Icons.trending_up;
      case FundTransactionType.disbursement:
        return Icons.payments;
      case FundTransactionType.utilization:
        return Icons.shopping_cart;
      case FundTransactionType.refund:
        return Icons.undo;
      case FundTransactionType.adjustment:
        return Icons.edit;
    }
  }

  Color _getStatusColor(FundTransactionStatus status) {
    switch (status) {
      case FundTransactionStatus.pending:
        return Colors.orange;
      case FundTransactionStatus.approved:
        return Colors.green;
      case FundTransactionStatus.rejected:
        return Colors.red;
      case FundTransactionStatus.onHold:
        return Colors.amber;
      case FundTransactionStatus.completed:
        return Colors.blue;
      case FundTransactionStatus.underAudit:
        return Colors.purple;
    }
  }

  String _formatAmount(double amount) {
    if (amount >= 10000000) {
      return '${(amount / 10000000).toStringAsFixed(1)} Cr';
    } else if (amount >= 100000) {
      return '${(amount / 100000).toStringAsFixed(1)} L';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)} K';
    }
    return amount.toStringAsFixed(0);
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _generateReport(String reportType) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Generating $reportType...')),
    );
  }

  void _downloadReport(String reportName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Downloading $reportName...')),
    );
  }

  static List<FundTransparencyRecord> _getDemoTransactions() {
    final now = DateTime.now();
    return [
      FundTransparencyRecord(
        id: 'TXN001',
        sourceLevel: 'centre',
        sourceId: 'centre_001',
        sourceName: 'Centre Government',
        targetLevel: 'state',
        targetId: 'MH',
        targetName: 'Maharashtra',
        type: FundTransactionType.allocation,
        status: FundTransactionStatus.approved,
        amount: 50000000,
        currency: 'INR',
        transactionDate: now.subtract(const Duration(days: 5)),
        approvalDate: now.subtract(const Duration(days: 3)),
        pfmsReference: 'PFMS-2024-001',
        budgetLineItem: 'PM-AJAY-Infrastructure',
        description: 'Q1 2024 Infrastructure Fund Allocation',
        requiresAuditApproval: false,
      ),
      FundTransparencyRecord(
        id: 'TXN002',
        sourceLevel: 'state',
        sourceId: 'MH',
        sourceName: 'Maharashtra',
        targetLevel: 'agency',
        targetId: 'MH_AGENCY_001',
        targetName: 'MH Healthcare Builders',
        type: FundTransactionType.disbursement,
        status: FundTransactionStatus.completed,
        amount: 15000000,
        currency: 'INR',
        transactionDate: now.subtract(const Duration(days: 2)),
        approvalDate: now.subtract(const Duration(days: 1)),
        pfmsReference: 'PFMS-2024-002',
        projectId: 'PRJ-2024-001',
        description: 'CHC Construction Project - Phase 1',
        requiresAuditApproval: true,
      ),
      FundTransparencyRecord(
        id: 'TXN003',
        sourceLevel: 'agency',
        sourceId: 'MH_AGENCY_001',
        sourceName: 'MH Healthcare Builders',
        targetLevel: 'vendor',
        targetId: 'VENDOR_001',
        targetName: 'Construction Materials Pvt Ltd',
        type: FundTransactionType.utilization,
        status: FundTransactionStatus.underAudit,
        amount: 5000000,
        currency: 'INR',
        transactionDate: now.subtract(const Duration(hours: 12)),
        description: 'Construction materials procurement',
        requiresAuditApproval: true,
      ),
    ];
  }
}
