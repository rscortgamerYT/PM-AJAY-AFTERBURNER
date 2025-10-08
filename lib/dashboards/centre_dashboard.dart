import 'package:flutter/material.dart';

class CentreDashboard extends StatefulWidget {
  const CentreDashboard({super.key});

  @override
  State<CentreDashboard> createState() => _CentreDashboardState();
}

class _CentreDashboardState extends State<CentreDashboard> {
  int _selectedIndex = 0;
  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _sectionKeys = List.generate(7, (index) => GlobalKey());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Centre Admin Dashboard'),
        backgroundColor: const Color(0xFF3F51B5),
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          // Communication Hub - Always Visible
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.forum, size: 28),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: const Text(
                      '5',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () => _showCommunicationHub(context),
            tooltip: 'Communication Hub',
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {},
          ),
        ],
      ),
      body: Row(
        children: [
          // Permanent Sidebar
          Container(
            width: 280,
            decoration: BoxDecoration(
              color: Colors.grey[50],
              border: const Border(
                right: BorderSide(color: Colors.grey, width: 0.5),
              ),
            ),
            child: _buildPermanentSidebar(),
          ),
          // Main Content with Infinite Scroll
          Expanded(
            child: _buildInfiniteScrollContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboardHome();
      case 1:
        return _buildStateRequests();
      case 2:
        return _buildAgencyOnboarding();
      case 3:
        return _buildFundFlow();
      case 4:
        return _buildAnalytics();
      case 5:
        return _buildAuditFlags();
      case 6:
        return _buildSettings();
      default:
        return _buildDashboardHome();
    }
  }

  Widget _buildDashboardHome() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'National Overview',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.5,
            children: [
              _buildStatCard('Total States', '28', Icons.location_city, Colors.blue),
              _buildStatCard('Active Projects', '2,450', Icons.work, Colors.green),
              _buildStatCard('Total Budget', '₹15,000 Cr', Icons.monetization_on, Colors.orange),
              _buildStatCard('Beneficiaries', '1.2M+', Icons.people, Colors.purple),
            ],
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Recent Activities',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildActivityItem('Maharashtra submitted new project proposal', '2 hours ago'),
                  _buildActivityItem('Karnataka fund utilization report approved', '4 hours ago'),
                  _buildActivityItem('Tamil Nadu requested budget revision', '6 hours ago'),
                  _buildActivityItem('Gujarat project milestone completed', '8 hours ago'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStateRequests() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Holistic State Request Panel',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.filter_list),
                    label: const Text('Multi-Filter'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.refresh),
                    label: const Text('Refresh Data'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3F51B5),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // State Requests Table with SLA Timers
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Incoming State Requests',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      final states = ['Maharashtra', 'Karnataka', 'Tamil Nadu', 'Gujarat', 'Rajasthan'];
                      final requestTypes = ['Fund Release', 'Agency Approval', 'Project Extension', 'Budget Revision', 'Emergency Fund'];
                      final priorities = ['High', 'Medium', 'High', 'Low', 'Critical'];
                      final slaHours = [12, 24, 8, 48, 4];
                      
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ExpansionTile(
                          leading: CircleAvatar(
                            backgroundColor: _getPriorityColor(priorities[index]),
                            child: Text(
                              states[index][0],
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Text('${states[index]} - ${requestTypes[index]}'),
                          subtitle: Row(
                            children: [
                              Icon(Icons.timer, size: 16, color: Colors.orange),
                              const SizedBox(width: 4),
                              Text('SLA: ${slaHours[index]}h remaining'),
                              const SizedBox(width: 16),
                              Chip(
                                label: Text(priorities[index]),
                                backgroundColor: _getPriorityColor(priorities[index]).withOpacity(0.2),
                              ),
                            ],
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // State Profile Viewer
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text('State Profile:', style: TextStyle(fontWeight: FontWeight.bold)),
                                            Text('Population: 11.2 Cr'),
                                            Text('Districts: 36'),
                                            Text('Active Projects: 245'),
                                            Text('Fund Utilization: 78%'),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text('Financial Proposal:', style: TextStyle(fontWeight: FontWeight.bold)),
                                            Text('Requested Amount: ₹500 Cr'),
                                            Text('Purpose: ${requestTypes[index]}'),
                                            Text('Expected ROI: 15%'),
                                            Text('Beneficiaries: 2.5 Lakh'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  
                                  // Decision Controls
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton.icon(
                                        onPressed: () => _showDecisionDialog(context, 'Approve', states[index]),
                                        icon: const Icon(Icons.check_circle),
                                        label: const Text('Approve'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          foregroundColor: Colors.white,
                                        ),
                                      ),
                                      ElevatedButton.icon(
                                        onPressed: () => _showDecisionDialog(context, 'Reject', states[index]),
                                        icon: const Icon(Icons.cancel),
                                        label: const Text('Reject'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          foregroundColor: Colors.white,
                                        ),
                                      ),
                                      ElevatedButton.icon(
                                        onPressed: () => _showDecisionDialog(context, 'On Hold', states[index]),
                                        icon: const Icon(Icons.pause_circle),
                                        label: const Text('On Hold'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.orange,
                                          foregroundColor: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAgencyOnboarding() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Agency Onboarding Hub',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.verified),
                    label: const Text('Bulk Verify'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.cancel),
                    label: const Text('Bulk Reject'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Agency Cards Grid by State
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
            ),
            itemCount: 6,
            itemBuilder: (context, index) {
              final agencies = [
                'Infrastructure Corp Ltd',
                'Rural Development Agency',
                'Urban Planning Solutions',
                'Healthcare Infrastructure',
                'Education Builders',
                'Digital Services Ltd'
              ];
              final states = ['Maharashtra', 'Karnataka', 'Tamil Nadu', 'Gujarat', 'Rajasthan', 'Punjab'];
              final capabilityScores = [85, 92, 78, 88, 95, 82];
              
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.blue[100],
                            child: Text(agencies[index][0]),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              agencies[index],
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('State: ${states[index]}', style: const TextStyle(fontSize: 11)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Text('Capability: ', style: TextStyle(fontSize: 11)),
                          Text(
                            '${capabilityScores[index]}%',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: _getScoreColor(capabilityScores[index]),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: capabilityScores[index] / 100,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(_getScoreColor(capabilityScores[index])),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: () => _showAgencyDetails(context, agencies[index]),
                            icon: const Icon(Icons.visibility, size: 16),
                            tooltip: 'View Details',
                          ),
                          IconButton(
                            onPressed: () => _approveAgency(agencies[index]),
                            icon: const Icon(Icons.check, size: 16, color: Colors.green),
                            tooltip: 'Approve',
                          ),
                          IconButton(
                            onPressed: () => _rejectAgency(agencies[index]),
                            icon: const Icon(Icons.close, size: 16, color: Colors.red),
                            tooltip: 'Reject',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFundFlow() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Global Fund Transparency Panel',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          
          // Sankey Diagram Placeholder
          Card(
            child: Container(
              height: 300,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    'Animated Sankey Flow: Centre → State → Agency',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.account_tree, size: 64, color: Colors.blue),
                            SizedBox(height: 16),
                            Text('Interactive Sankey Diagram'),
                            Text('Centre: ₹15,000 Cr → States → Agencies'),
                            Text('Click flows for drill-down details'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Choropleth Map Placeholder
          Card(
            child: Container(
              height: 400,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    'Interactive State Performance Map',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.map, size: 64, color: Colors.green),
                            SizedBox(height: 16),
                            Text('Choropleth Map with State Boundaries'),
                            Text('Live Performance Heatmaps'),
                            Text('Clickable State Popups'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Centre Admin Flag Review Section
  Widget _buildAuditFlags() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Audit Flags Review Dashboard',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          
          // Hero Cards for Flag Statistics
          Row(
            children: [
              Expanded(
                child: _buildFlagStatCard('Total Flags', '24', Icons.flag, Colors.blue),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildFlagStatCard('Pending Centre Review', '8', Icons.pending, Colors.orange),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildFlagStatCard('Pending State Review', '12', Icons.schedule, Colors.purple),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildFlagStatCard('Resolved', '4', Icons.check_circle, Colors.green),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Flags Table
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Audit Flags from Auditors',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _refreshFlags(),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Refresh'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3F51B5),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Flags List
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      final flagIds = ['FLG-001', 'FLG-002', 'FLG-003', 'FLG-004', 'FLG-005', 'FLG-006'];
                      final projects = ['Rural Road Project MH-001', 'Water Supply KA-045', 'School Building TN-023', 'Healthcare Center GJ-012', 'Digital Infrastructure RJ-089', 'Sanitation Project UP-156'];
                      final auditors = ['Dr. Sharma', 'Ms. Patel', 'Mr. Kumar', 'Dr. Singh', 'Ms. Gupta', 'Mr. Rao'];
                      final reasons = ['Financial Discrepancy', 'Evidence Mismatch', 'Compliance Issue', 'Project Delay', 'Documentation Gap', 'Quality Concern'];
                      final statuses = ['Pending Centre', 'Sent to State', 'Under Review', 'Pending Centre', 'Resolved', 'Sent to State'];
                      final dates = ['2024-01-15', '2024-01-14', '2024-01-13', '2024-01-12', '2024-01-11', '2024-01-10'];
                      
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: _getFlagStatusColor(statuses[index]).withOpacity(0.2),
                            child: Text(
                              flagIds[index].split('-')[1],
                              style: TextStyle(
                                color: _getFlagStatusColor(statuses[index]),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          title: Text(projects[index]),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Auditor: ${auditors[index]} • ${dates[index]}'),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Chip(
                                    label: Text(reasons[index]),
                                    backgroundColor: _getReasonColor(reasons[index]).withOpacity(0.1),
                                  ),
                                  const SizedBox(width: 8),
                                  Chip(
                                    label: Text(statuses[index]),
                                    backgroundColor: _getFlagStatusColor(statuses[index]).withOpacity(0.1),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) => _handleFlagAction(value, flagIds[index], projects[index]),
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'view',
                                child: ListTile(
                                  leading: Icon(Icons.visibility),
                                  title: Text('View Details'),
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'assign',
                                child: ListTile(
                                  leading: Icon(Icons.assignment),
                                  title: Text('Assign to State'),
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'resolve',
                                child: ListTile(
                                  leading: Icon(Icons.check_circle),
                                  title: Text('Resolve'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Assigned Flags View
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Flags Assigned to States',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // State Assignment Summary
                  Row(
                    children: [
                      Expanded(
                        child: _buildStateAssignmentCard('Maharashtra', 3, Colors.blue),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStateAssignmentCard('Karnataka', 2, Colors.green),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStateAssignmentCard('Tamil Nadu', 4, Colors.orange),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStateAssignmentCard('Gujarat', 1, Colors.purple),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlagStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStateAssignmentCard(String state, int count, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              state,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            CircleAvatar(
              backgroundColor: color,
              radius: 16,
              child: Text(
                '$count',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getFlagStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending centre':
        return Colors.orange;
      case 'sent to state':
        return Colors.blue;
      case 'under review':
        return Colors.purple;
      case 'resolved':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Color _getReasonColor(String reason) {
    switch (reason.toLowerCase()) {
      case 'financial discrepancy':
        return Colors.red;
      case 'evidence mismatch':
        return Colors.orange;
      case 'compliance issue':
        return Colors.purple;
      case 'project delay':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  void _handleFlagAction(String action, String flagId, String projectName) {
    switch (action) {
      case 'view':
        _viewFlagDetails(flagId, projectName);
        break;
      case 'assign':
        _assignFlagToState(flagId, projectName);
        break;
      case 'resolve':
        _resolveFlagDirectly(flagId, projectName);
        break;
    }
  }

  void _viewFlagDetails(String flagId, String projectName) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Flag Details - $flagId',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 16),
              
              Text('Project: $projectName', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('Auditor: Dr. Sharma'),
              const Text('Date Flagged: 2024-01-15'),
              const Text('Reason: Financial Discrepancy'),
              const SizedBox(height: 16),
              
              const Text('Description:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('Discrepancy found in fund utilization records. Amount allocated vs spent shows significant variance requiring investigation.'),
              const SizedBox(height: 16),
              
              const Text('Supporting Evidence:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Chip(
                    avatar: const Icon(Icons.attach_file, size: 16),
                    label: const Text('Financial_Report.pdf'),
                    onDeleted: () => _downloadEvidence('Financial_Report.pdf'),
                    deleteIcon: const Icon(Icons.download, size: 16),
                  ),
                  const SizedBox(width: 8),
                  Chip(
                    avatar: const Icon(Icons.photo, size: 16),
                    label: const Text('Site_Photo.jpg'),
                    onDeleted: () => _downloadEvidence('Site_Photo.jpg'),
                    deleteIcon: const Icon(Icons.download, size: 16),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _assignFlagToState(flagId, projectName);
                    },
                    child: const Text('Assign to State'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _assignFlagToState(String flagId, String projectName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Assign Flag to State - $flagId'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Assign flag for "$projectName" to responsible state officer:'),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Select State',
                border: OutlineInputBorder(),
              ),
              items: ['Maharashtra', 'Karnataka', 'Tamil Nadu', 'Gujarat', 'Rajasthan']
                  .map((state) => DropdownMenuItem(value: state, child: Text(state)))
                  .toList(),
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Assignment Comments',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Flag $flagId assigned to state. Notification sent to State Officer.'),
                  backgroundColor: Colors.blue,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: const Text('Assign'),
          ),
        ],
      ),
    );
  }

  void _resolveFlagDirectly(String flagId, String projectName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Resolve Flag - $flagId'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Mark flag for "$projectName" as resolved:'),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Resolution Comments (Required)',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Flag $flagId resolved successfully. Auditor notified.'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Resolve'),
          ),
        ],
      ),
    );
  }

  void _refreshFlags() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Refreshing audit flags...')),
    );
  }

  void _downloadEvidence(String filename) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Downloading $filename')),
    );
  }

  Widget _buildSettings() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Scheme Configuration & Settings',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          
          // Scheme Configuration
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Allocation Norms Editor',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Per Capita Allocation (₹)',
                      border: OutlineInputBorder(),
                    ),
                    initialValue: '1200',
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'State Matching Percentage (%)',
                      border: OutlineInputBorder(),
                    ),
                    initialValue: '25',
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Save Configuration'),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // PFMS Integration
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'PFMS Integration Settings',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'PFMS API Endpoint',
                      border: OutlineInputBorder(),
                    ),
                    initialValue: 'https://pfms.nic.in/api/v1',
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'API Key',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Test Connection'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjects() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Project Management',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('New Project'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3F51B5),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue[100],
                    child: Text('${index + 1}'),
                  ),
                  title: Text('Project ${index + 1}: Infrastructure Development'),
                  subtitle: Text('State: ${['Maharashtra', 'Karnataka', 'Tamil Nadu', 'Gujarat', 'Rajasthan'][index]}'),
                  trailing: Chip(
                    label: Text(['Active', 'Pending', 'Completed', 'Review', 'Active'][index]),
                    backgroundColor: [Colors.green, Colors.orange, Colors.blue, Colors.purple, Colors.green][index][100],
                  ),
                  onTap: () {},
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFunds() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Fund Management',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Allocated', style: TextStyle(fontSize: 16)),
                      const Text('₹15,000 Cr', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Utilized', style: TextStyle(fontSize: 16)),
                      const Text('₹12,500 Cr', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Remaining', style: TextStyle(fontSize: 16)),
                      const Text('₹2,500 Cr', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'State-wise Fund Distribution',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            itemBuilder: (context, index) {
              final states = ['Maharashtra', 'Karnataka', 'Tamil Nadu', 'Gujarat', 'Rajasthan'];
              final amounts = ['₹2,000 Cr', '₹1,800 Cr', '₹1,600 Cr', '₹1,400 Cr', '₹1,200 Cr'];
              return Card(
                child: ListTile(
                  title: Text(states[index]),
                  subtitle: Text('Allocated: ${amounts[index]}'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {},
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAnalytics() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Analytics & Reports',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildAnalyticsCard('Project Success Rate', '87%', Icons.trending_up, Colors.green),
              _buildAnalyticsCard('Fund Utilization', '83%', Icons.account_balance_wallet, Colors.blue),
              _buildAnalyticsCard('Avg. Completion Time', '18 months', Icons.schedule, Colors.orange),
              _buildAnalyticsCard('Beneficiary Satisfaction', '92%', Icons.sentiment_satisfied, Colors.purple),
            ],
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Performance Trends',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        'Chart Placeholder\n(Performance trends would be displayed here)',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(fontSize: 11),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(String activity, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFF3F51B5),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(activity, style: const TextStyle(fontSize: 14)),
                Text(time, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods for new functionality
  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'critical':
        return Colors.red[700]!;
      case 'high':
        return Colors.orange[600]!;
      case 'medium':
        return Colors.blue[600]!;
      case 'low':
        return Colors.green[600]!;
      default:
        return Colors.grey[600]!;
    }
  }

  Color _getScoreColor(int score) {
    if (score >= 90) return Colors.green;
    if (score >= 80) return Colors.blue;
    if (score >= 70) return Colors.orange;
    return Colors.red;
  }

  void _showDecisionDialog(BuildContext context, String action, String state) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$action Request - $state'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Are you sure you want to $action this request from $state?'),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Rationale (required)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$state request ${action.toLowerCase()}ed successfully'),
                  backgroundColor: action == 'Approve' ? Colors.green : Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: action == 'Approve' ? Colors.green : 
                             action == 'Reject' ? Colors.red : Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: Text(action),
          ),
        ],
      ),
    );
  }

  void _showAgencyDetails(BuildContext context, String agencyName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(agencyName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Agency Details:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Registration: Valid'),
            const Text('Experience: 8 years'),
            const Text('Completed Projects: 45'),
            const Text('Success Rate: 92%'),
            const Text('Financial Rating: A+'),
            const SizedBox(height: 16),
            const Text('Document Checklist:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildChecklistItem('Registration Certificate', true),
            _buildChecklistItem('Financial Statements', true),
            _buildChecklistItem('Experience Certificates', true),
            _buildChecklistItem('Technical Capability', false),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildChecklistItem(String item, bool completed) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            completed ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 16,
            color: completed ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 8),
          Text(item, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  void _approveAgency(String agencyName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$agencyName approved successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _rejectAgency(String agencyName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$agencyName rejected'),
        backgroundColor: Colors.red,
      ),
    );
  }

  // Communication Hub Implementation
  void _showCommunicationHub(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Hub Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFF3F51B5),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.forum, color: Colors.white, size: 24),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Centre Admin Communication Hub',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
              ),
              
              // Hub Content
              Expanded(
                child: DefaultTabController(
                  length: 4,
                  child: Column(
                    children: [
                      const TabBar(
                        labelColor: Color(0xFF3F51B5),
                        unselectedLabelColor: Colors.grey,
                        tabs: [
                          Tab(text: 'Channels'),
                          Tab(text: 'Documents'),
                          Tab(text: 'Tickets'),
                          Tab(text: 'Meetings'),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            _buildChannelsTab(),
                            _buildDocumentsTab(),
                            _buildTicketsTab(),
                            _buildMeetingsTab(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChannelsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Centre-State Requests Channel
        _buildChannelCard(
          'Centre–State Requests',
          'Active discussions with state officers',
          Icons.location_city,
          Colors.blue,
          3,
          [
            'Maharashtra: Fund release approved',
            'Karnataka: Agency verification pending',
            'Tamil Nadu: Project extension request',
          ],
        ),
        
        const SizedBox(height: 12),
        
        // Audit Liaison Channel
        _buildChannelCard(
          'Audit Liaison',
          'Communication with audit teams',
          Icons.verified,
          Colors.purple,
          2,
          [
            'Q3 audit report submitted',
            'Fund transfer flagged for review',
          ],
        ),
        
        const SizedBox(height: 12),
        
        // Policy Council Channel
        _buildChannelCard(
          'Policy Council',
          'High-level policy discussions',
          Icons.policy,
          Colors.green,
          0,
          [
            'New allocation norms discussion',
            'PFMS integration updates',
          ],
        ),
      ],
    );
  }

  Widget _buildChannelCard(String title, String subtitle, IconData icon, Color color, int unreadCount, List<String> recentMessages) {
    return Card(
      child: InkWell(
        onTap: () => _openChannel(title),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: color.withOpacity(0.1),
                    child: Icon(icon, color: color),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (unreadCount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$unreadCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              ...recentMessages.take(2).map((message) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  '• $message',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                  ),
                ),
              )).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Drag & Drop Area
        Container(
          height: 120,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue, style: BorderStyle.solid, width: 2),
            borderRadius: BorderRadius.circular(8),
            color: Colors.blue[50],
          ),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.cloud_upload, size: 32, color: Colors.blue),
                SizedBox(height: 8),
                Text('Drag & Drop Documents Here'),
                Text('or click to browse', style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 20),
        
        const Text(
          'Recent Documents',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        
        const SizedBox(height: 12),
        
        // Document List
        _buildDocumentItem('State_Request_MH_001.pdf', 'Maharashtra', '2 hours ago'),
        _buildDocumentItem('Agency_Verification_KA.xlsx', 'Karnataka', '4 hours ago'),
        _buildDocumentItem('Fund_Release_Guidelines.docx', 'Policy', '1 day ago'),
        _buildDocumentItem('Audit_Report_Q3.pdf', 'Audit', '2 days ago'),
      ],
    );
  }

  Widget _buildDocumentItem(String filename, String source, String time) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.orange[100],
          child: Icon(Icons.description, color: Colors.orange[700]),
        ),
        title: Text(filename),
        subtitle: Text('From: $source • $time'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () => _shareDocument(filename),
            ),
            IconButton(
              icon: const Icon(Icons.download),
              onPressed: () => _downloadDocument(filename),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Active Tickets',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ElevatedButton.icon(
              onPressed: () => _createTicket(),
              icon: const Icon(Icons.add),
              label: const Text('Create Ticket'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3F51B5),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        _buildTicketItem('TKT-001', 'Maharashtra Fund Release Delay', 'High', 'Open'),
        _buildTicketItem('TKT-002', 'Karnataka Agency Verification', 'Medium', 'In Progress'),
        _buildTicketItem('TKT-003', 'Audit Query - Q3 Reports', 'Low', 'Resolved'),
      ],
    );
  }

  Widget _buildTicketItem(String ticketId, String title, String priority, String status) {
    Color priorityColor = priority == 'High' ? Colors.red : 
                         priority == 'Medium' ? Colors.orange : Colors.green;
    Color statusColor = status == 'Open' ? Colors.red :
                       status == 'In Progress' ? Colors.blue : Colors.green;
    
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: priorityColor.withOpacity(0.1),
          child: Text(
            ticketId.split('-')[1],
            style: TextStyle(color: priorityColor, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(title),
        subtitle: Row(
          children: [
            Chip(
              label: Text(priority),
              backgroundColor: priorityColor.withOpacity(0.1),
            ),
            const SizedBox(width: 8),
            Chip(
              label: Text(status),
              backgroundColor: statusColor.withOpacity(0.1),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: () => _openTicket(ticketId),
        ),
      ),
    );
  }

  Widget _buildMeetingsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Scheduled Meetings',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ElevatedButton.icon(
              onPressed: () => _scheduleMeeting(),
              icon: const Icon(Icons.video_call),
              label: const Text('Schedule Meeting'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        _buildMeetingItem('State Officers Review', 'Today 3:00 PM', ['Maharashtra', 'Karnataka', 'Tamil Nadu']),
        _buildMeetingItem('Audit Committee', 'Tomorrow 10:00 AM', ['Audit Team', 'Finance']),
        _buildMeetingItem('Policy Council', 'Friday 2:00 PM', ['Policy Team', 'Legal']),
      ],
    );
  }

  Widget _buildMeetingItem(String title, String time, List<String> participants) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.green,
          child: Icon(Icons.video_call, color: Colors.white),
        ),
        title: Text(title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(time),
            const SizedBox(height: 4),
            Text('Participants: ${participants.join(', ')}'),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () => _joinMeeting(title),
          child: const Text('Join'),
        ),
      ),
    );
  }

  // Communication Hub Actions
  void _openChannel(String channelName) {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      channelName,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const Divider(),
              Expanded(
                child: ListView(
                  children: [
                    _buildChatMessage('State Officer (MH)', 'Fund release request submitted for review', '10:30 AM'),
                    _buildChatMessage('Centre Admin', 'Reviewing the proposal. Will respond by EOD.', '10:45 AM'),
                    _buildChatMessage('State Officer (MH)', 'Thank you. Urgent project needs funding.', '11:00 AM'),
                  ],
                ),
              ),
              const Divider(),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Type your message...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.send, color: Color(0xFF3F51B5)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatMessage(String sender, String message, String time) {
    bool isMe = sender.contains('Centre Admin');
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFF3F51B5) : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMe)
              Text(
                sender,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            Text(
              message,
              style: TextStyle(color: isMe ? Colors.white : Colors.black),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: TextStyle(
                fontSize: 10,
                color: isMe ? Colors.white70 : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _shareDocument(String filename) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$filename shared to channel')),
    );
  }

  void _downloadDocument(String filename) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Downloading $filename')),
    );
  }

  void _createTicket() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Create ticket dialog would open')),
    );
  }

  void _openTicket(String ticketId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening ticket $ticketId')),
    );
  }

  void _scheduleMeeting() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Schedule meeting dialog would open')),
    );
  }

  void _joinMeeting(String meetingTitle) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Joining $meetingTitle')),
    );
  }

  // Enhanced Fund Flow Helper Methods
  Widget _buildEnhancedStatCard(String title, String value, IconData icon, Color color, {String? trend, String? subtitle}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 24),
                if (trend != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      trend,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (subtitle != null)
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlowLegendItem(String label, Color color) {
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
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildMapLegendItem(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }

  Color _getTransferStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'in transit':
        return Colors.blue;
      case 'processing':
        return Colors.orange;
      case 'pending':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  IconData _getTransferStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Icons.check_circle;
      case 'in transit':
        return Icons.local_shipping;
      case 'processing':
        return Icons.hourglass_empty;
      case 'pending':
        return Icons.schedule;
      default:
        return Icons.help;
    }
  }

  void _openInteractiveMap() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening Interactive Fund Flow Map...')),
    );
  }

  void _exportFundFlowData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Exporting fund flow data...')),
    );
  }

  void _changeFundFlowLevel(String level) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Switching to $level view...')),
    );
  }

  void _refreshFundFlowData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Refreshing fund flow data...')),
    );
  }

  void _openFullScreenMap() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening full screen map...')),
    );
  }

  // Permanent Sidebar Implementation
  Widget _buildPermanentSidebar() {
    final sidebarItems = [
      {'title': 'Dashboard Home', 'icon': Icons.dashboard, 'index': 0},
      {'title': 'State Requests', 'icon': Icons.request_page, 'index': 1},
      {'title': 'Agency Onboarding', 'icon': Icons.business_center, 'index': 2},
      {'title': 'Fund Flow', 'icon': Icons.account_balance_wallet, 'index': 3},
      {'title': 'Analytics', 'icon': Icons.analytics, 'index': 4},
      {'title': 'Audit Flags', 'icon': Icons.flag, 'index': 5},
      {'title': 'Settings', 'icon': Icons.settings, 'index': 6},
    ];

    return Column(
      children: [
        // Profile Header
        Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Color(0xFF3F51B5),
          ),
          child: const Column(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.account_balance,
                  size: 30,
                  color: Color(0xFF3F51B5),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Centre Admin',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'admin@pmajay.gov.in',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        
        // Navigation Items
        Expanded(
          child: ListView.builder(
            itemCount: sidebarItems.length,
            itemBuilder: (context, index) {
              final item = sidebarItems[index];
              final isSelected = _selectedIndex == item['index'];
              
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: isSelected ? const Color(0xFF3F51B5).withOpacity(0.1) : null,
                ),
                child: ListTile(
                  leading: Icon(
                    item['icon'] as IconData,
                    color: isSelected ? const Color(0xFF3F51B5) : Colors.grey[600],
                  ),
                  title: Text(
                    item['title'] as String,
                    style: TextStyle(
                      color: isSelected ? const Color(0xFF3F51B5) : Colors.grey[800],
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  onTap: () => _scrollToSection(item['index'] as int),
                ),
              );
            },
          ),
        ),
        
        // Logout
        Container(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () => Navigator.pop(context),
          ),
        ),
      ],
    );
  }

  // Infinite Scroll Content
  Widget _buildInfiniteScrollContent() {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is ScrollUpdateNotification) {
          _updateSelectedIndex();
        }
        return false;
      },
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            // Dashboard Home Section
            Container(
              key: _sectionKeys[0],
              child: _buildDashboardHome(),
            ),
            
            // State Requests Section
            Container(
              key: _sectionKeys[1],
              child: _buildStateRequests(),
            ),
            
            // Agency Onboarding Section
            Container(
              key: _sectionKeys[2],
              child: _buildAgencyOnboarding(),
            ),
            
            // Fund Flow Section
            Container(
              key: _sectionKeys[3],
              child: _buildFundFlow(),
            ),
            
            // Analytics Section
            Container(
              key: _sectionKeys[4],
              child: _buildAnalytics(),
            ),
            
            // Audit Flags Section
            Container(
              key: _sectionKeys[5],
              child: _buildAuditFlags(),
            ),
            
            // Settings Section
            Container(
              key: _sectionKeys[6],
              child: _buildSettings(),
            ),
          ],
        ),
      ),
    );
  }

  void _scrollToSection(int index) {
    setState(() {
      _selectedIndex = index;
    });
    
    final context = _sectionKeys[index].currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _updateSelectedIndex() {
    final scrollOffset = _scrollController.offset;
    int newIndex = 0;
    
    for (int i = 0; i < _sectionKeys.length; i++) {
      final context = _sectionKeys[i].currentContext;
      if (context != null) {
        final box = context.findRenderObject() as RenderBox?;
        if (box != null) {
          final position = box.localToGlobal(Offset.zero);
          if (position.dy <= 100) {
            newIndex = i;
          }
        }
      }
    }
    
    if (newIndex != _selectedIndex) {
      setState(() {
        _selectedIndex = newIndex;
      });
    }
  }
}

// Custom Painters for Enhanced Visualizations
class SimpleSankeyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    // Draw Centre node
    paint.color = Colors.blue;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(50, size.height / 2 - 40, 20, 80),
        const Radius.circular(4),
      ),
      paint,
    );

    // Draw State nodes
    paint.color = Colors.green;
    final statePositions = [
      size.height / 2 - 60,
      size.height / 2 - 20,
      size.height / 2 + 20,
    ];
    
    for (final pos in statePositions) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(size.width / 2, pos, 20, 30),
          const Radius.circular(4),
        ),
        paint,
      );
    }

    // Draw Agency nodes
    paint.color = Colors.orange;
    final agencyPositions = [
      size.height / 2 - 50,
      size.height / 2 - 10,
      size.height / 2 + 30,
    ];
    
    for (final pos in agencyPositions) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(size.width - 70, pos, 20, 25),
          const Radius.circular(4),
        ),
        paint,
      );
    }

    // Draw flow lines
    final flowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..color = Colors.blue.withOpacity(0.6);

    for (int i = 0; i < statePositions.length; i++) {
      final path = Path();
      path.moveTo(70, size.height / 2);
      path.quadraticBezierTo(
        size.width / 4,
        statePositions[i] + 15,
        size.width / 2,
        statePositions[i] + 15,
      );
      canvas.drawPath(path, flowPaint);
    }

    // Draw labels
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    textPainter.text = const TextSpan(
      text: 'Centre\n₹15,000 Cr',
      style: TextStyle(color: Colors.black, fontSize: 10),
    );
    textPainter.layout();
    textPainter.paint(canvas, const Offset(25, 20));

    textPainter.text = const TextSpan(
      text: 'States',
      style: TextStyle(color: Colors.black, fontSize: 10),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(size.width / 2 - 10, 20));

    textPainter.text = const TextSpan(
      text: 'Agencies',
      style: TextStyle(color: Colors.black, fontSize: 10),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(size.width - 80, 20));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class SimpleMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    // Draw simplified India outline
    final indiaPath = Path();
    indiaPath.moveTo(size.width * 0.3, size.height * 0.2);
    indiaPath.lineTo(size.width * 0.7, size.height * 0.15);
    indiaPath.lineTo(size.width * 0.8, size.height * 0.4);
    indiaPath.lineTo(size.width * 0.75, size.height * 0.8);
    indiaPath.lineTo(size.width * 0.4, size.height * 0.85);
    indiaPath.lineTo(size.width * 0.25, size.height * 0.6);
    indiaPath.close();

    paint.color = Colors.grey[300]!;
    canvas.drawPath(indiaPath, paint);

    // Draw state markers
    final stateMarkers = [
      {'pos': Offset(size.width * 0.4, size.height * 0.3), 'color': Colors.green, 'label': 'MH'},
      {'pos': Offset(size.width * 0.5, size.height * 0.5), 'color': Colors.orange, 'label': 'KA'},
      {'pos': Offset(size.width * 0.45, size.height * 0.7), 'color': Colors.green, 'label': 'TN'},
      {'pos': Offset(size.width * 0.35, size.height * 0.4), 'color': Colors.red, 'label': 'GJ'},
    ];

    for (final marker in stateMarkers) {
      paint.color = marker['color'] as Color;
      canvas.drawCircle(marker['pos'] as Offset, 12, paint);

      final textPainter = TextPainter(
        text: TextSpan(
          text: marker['label'] as String,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 8,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      final offset = marker['pos'] as Offset;
      textPainter.paint(
        canvas,
        Offset(
          offset.dx - textPainter.width / 2,
          offset.dy - textPainter.height / 2,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
