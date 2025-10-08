import 'package:flutter/material.dart';

class AuditorDashboard extends StatefulWidget {
  final String auditorName;
  
  const AuditorDashboard({super.key, this.auditorName = 'Dr. Audit Sharma'});

  @override
  State<AuditorDashboard> createState() => _AuditorDashboardState();
}

class _AuditorDashboardState extends State<AuditorDashboard> {
  int _selectedIndex = 0;
  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _sectionKeys = List.generate(6, (index) => GlobalKey());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.auditorName} - Auditor Dashboard'),
        backgroundColor: const Color(0xFF7B1FA2),
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
                      '2',
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

  // Permanent Sidebar Implementation for Auditor Dashboard
  Widget _buildPermanentSidebar() {
    final sidebarItems = [
      {'title': 'Audit Overview', 'icon': Icons.dashboard, 'index': 0},
      {'title': 'Project Audits', 'icon': Icons.assignment_turned_in, 'index': 1},
      {'title': 'Flag Projects', 'icon': Icons.flag, 'index': 2},
      {'title': 'Transparency Panel', 'icon': Icons.visibility, 'index': 3},
      {'title': 'Reports & Analytics', 'icon': Icons.analytics, 'index': 4},
      {'title': 'Settings', 'icon': Icons.settings, 'index': 5},
    ];

    return Column(
      children: [
        // Profile Header
        Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Color(0xFF7B1FA2),
          ),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.verified,
                  size: 30,
                  color: Color(0xFF7B1FA2),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.auditorName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'auditor@pmajay.gov.in',
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
                  color: isSelected ? const Color(0xFF7B1FA2).withOpacity(0.1) : null,
                ),
                child: ListTile(
                  leading: Icon(
                    item['icon'] as IconData,
                    color: isSelected ? const Color(0xFF7B1FA2) : Colors.grey[600],
                  ),
                  title: Text(
                    item['title'] as String,
                    style: TextStyle(
                      color: isSelected ? const Color(0xFF7B1FA2) : Colors.grey[800],
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

  // Infinite Scroll Content for Auditor Dashboard
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
            // Audit Overview Section
            Container(
              key: _sectionKeys[0],
              child: _buildAuditOverview(),
            ),
            
            // Project Audits Section
            Container(
              key: _sectionKeys[1],
              child: _buildProjectAudits(),
            ),
            
            // Flag Projects Section
            Container(
              key: _sectionKeys[2],
              child: _buildFlagProjects(),
            ),
            
            // Transparency Panel Section
            Container(
              key: _sectionKeys[3],
              child: _buildTransparencyPanel(),
            ),
            
            // Reports & Analytics Section
            Container(
              key: _sectionKeys[4],
              child: _buildReportsAnalytics(),
            ),
            
            // Settings Section
            Container(
              key: _sectionKeys[5],
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

  // Audit Overview Section
  Widget _buildAuditOverview() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Audit Overview Dashboard',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          
          // Statistics Cards
          Row(
            children: [
              Expanded(
                child: _buildStatCard('Projects Audited', '156', Icons.assignment_turned_in, Colors.green),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard('Flags Raised', '24', Icons.flag, Colors.red),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard('Compliance Score', '87%', Icons.verified, Colors.blue),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard('Active Audits', '12', Icons.pending, Colors.orange),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Recent Audit Activities
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Recent Audit Activities',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildActivityItem('Financial audit completed for MH-001', '2 hours ago', Icons.check_circle, Colors.green),
                  _buildActivityItem('Flag raised for evidence mismatch in KA-045', '4 hours ago', Icons.flag, Colors.red),
                  _buildActivityItem('Compliance verification passed for TN-023', '6 hours ago', Icons.verified, Colors.blue),
                  _buildActivityItem('Site inspection scheduled for GJ-012', '1 day ago', Icons.schedule, Colors.orange),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Project Audits Section
  Widget _buildProjectAudits() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Project Audits',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _startNewAudit(),
                icon: const Icon(Icons.add),
                label: const Text('New Audit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7B1FA2),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Audit Projects List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            itemBuilder: (context, index) {
              final projects = [
                'Rural Road Project MH-001',
                'Water Supply System KA-045',
                'School Building TN-023',
                'Healthcare Center GJ-012',
                'Digital Infrastructure RJ-089'
              ];
              final statuses = ['Completed', 'In Progress', 'Flagged', 'Under Review', 'Scheduled'];
              final scores = [92, 78, 45, 85, 0];
              final colors = [Colors.green, Colors.blue, Colors.red, Colors.orange, Colors.grey];
              
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: colors[index].withOpacity(0.2),
                    child: Icon(
                      _getStatusIcon(statuses[index]),
                      color: colors[index],
                    ),
                  ),
                  title: Text(projects[index]),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Status: ${statuses[index]}'),
                      if (scores[index] > 0) Text('Compliance Score: ${scores[index]}%'),
                    ],
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) => _handleAuditAction(value, projects[index]),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'view',
                        child: ListTile(
                          leading: Icon(Icons.visibility),
                          title: Text('View Details'),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'flag',
                        child: ListTile(
                          leading: Icon(Icons.flag),
                          title: Text('Flag Project'),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'report',
                        child: ListTile(
                          leading: Icon(Icons.report),
                          title: Text('Generate Report'),
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
    );
  }

  // Flag Projects Section - Enhanced Auditor Transparency & Flagging
  Widget _buildFlagProjects() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Flag Project Section',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          
          // Flag Statistics
          Row(
            children: [
              Expanded(
                child: _buildFlagStatCard('Total Flags', '24', Icons.flag, Colors.blue),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildFlagStatCard('Pending Centre', '8', Icons.pending, Colors.orange),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildFlagStatCard('Sent to State', '12', Icons.send, Colors.purple),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildFlagStatCard('Resolved', '4', Icons.check_circle, Colors.green),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Flagged Projects List
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Flagged Projects',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      final flagIds = ['FLG-001', 'FLG-002', 'FLG-003', 'FLG-004'];
                      final projects = ['Rural Road Project MH-001', 'Water Supply KA-045', 'School Building TN-023', 'Healthcare Center GJ-012'];
                      final reasons = ['Financial Discrepancy', 'Evidence Mismatch', 'Compliance Issue', 'Project Delay'];
                      final statuses = ['Pending Centre', 'Sent to State', 'Under Review', 'Resolved'];
                      final dates = ['2024-01-15', '2024-01-14', '2024-01-13', '2024-01-12'];
                      
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ExpansionTile(
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
                              Text('Flag ID: ${flagIds[index]} • ${dates[index]}'),
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
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Flag Details:',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  Text('Reason: ${reasons[index]}'),
                                  const Text('Description: Discrepancy found in project documentation and fund utilization.'),
                                  const SizedBox(height: 16),
                                  
                                  const Text(
                                    'Supporting Evidence:',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Chip(
                                        avatar: const Icon(Icons.attach_file, size: 16),
                                        label: const Text('Audit_Report.pdf'),
                                        onDeleted: () => _downloadEvidence('Audit_Report.pdf'),
                                        deleteIcon: const Icon(Icons.download, size: 16),
                                      ),
                                      const SizedBox(width: 8),
                                      Chip(
                                        avatar: const Icon(Icons.photo, size: 16),
                                        label: const Text('Site_Evidence.jpg'),
                                        onDeleted: () => _downloadEvidence('Site_Evidence.jpg'),
                                        deleteIcon: const Icon(Icons.download, size: 16),
                                      ),
                                    ],
                                  ),
                                  
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        onPressed: () => _editFlag(flagIds[index]),
                                        child: const Text('Edit Flag'),
                                      ),
                                      const SizedBox(width: 8),
                                      ElevatedButton(
                                        onPressed: () => _escalateFlag(flagIds[index]),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.orange,
                                          foregroundColor: Colors.white,
                                        ),
                                        child: const Text('Escalate'),
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

  Widget _buildTransparencyPanel() {
    return const Center(child: Text('Auditor Transparency Panel'));
  }

  Widget _buildReportsAnalytics() {
    return const Center(child: Text('Reports & Analytics'));
  }

  Widget _buildSettings() {
    return const Center(child: Text('Auditor Settings'));
  }

  // Helper Widgets
  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
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

  Widget _buildFlagStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 28, color: color),
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
              style: const TextStyle(fontSize: 11),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(String activity, String time, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 16),
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

  // Helper Methods
  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Icons.check_circle;
      case 'in progress':
        return Icons.pending;
      case 'flagged':
        return Icons.flag;
      case 'under review':
        return Icons.search;
      default:
        return Icons.schedule;
    }
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

  // Action Methods
  void _startNewAudit() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Starting new audit process...')),
    );
  }

  void _handleAuditAction(String action, String projectName) {
    switch (action) {
      case 'view':
        _viewProjectDetails(projectName);
        break;
      case 'flag':
        _flagProject(projectName);
        break;
      case 'report':
        _generateReport(projectName);
        break;
    }
  }

  void _viewProjectDetails(String projectName) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.8,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Project Details - $projectName',
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
              
              // Content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Project Overview
                      _buildDetailSection('Project Overview', [
                        _buildDetailRow('Project ID', _getProjectId(projectName)),
                        _buildDetailRow('Project Name', projectName),
                        _buildDetailRow('State', _getProjectState(projectName)),
                        _buildDetailRow('Agency', _getProjectAgency(projectName)),
                        _buildDetailRow('Status', _getProjectStatus(projectName)),
                        _buildDetailRow('Start Date', _getProjectStartDate(projectName)),
                        _buildDetailRow('Expected Completion', _getProjectEndDate(projectName)),
                      ]),
                      
                      const SizedBox(height: 24),
                      
                      // Financial Details
                      _buildDetailSection('Financial Information', [
                        _buildDetailRow('Total Budget', _getProjectBudget(projectName)),
                        _buildDetailRow('Amount Released', _getAmountReleased(projectName)),
                        _buildDetailRow('Amount Utilized', _getAmountUtilized(projectName)),
                        _buildDetailRow('Remaining Balance', _getRemainingBalance(projectName)),
                        _buildDetailRow('Utilization %', _getUtilizationPercent(projectName)),
                      ]),
                      
                      const SizedBox(height: 24),
                      
                      // Audit History
                      _buildDetailSection('Audit History', [
                        _buildAuditHistoryItem('Initial Audit', '2024-01-15', 'Passed', Colors.green),
                        _buildAuditHistoryItem('Mid-term Review', '2024-06-20', 'Minor Issues', Colors.orange),
                        _buildAuditHistoryItem('Financial Audit', '2024-10-01', 'In Progress', Colors.blue),
                      ]),
                      
                      const SizedBox(height: 24),
                      
                      // Documents
                      _buildDetailSection('Project Documents', [
                        _buildDocumentItem('Project Proposal.pdf', '2.4 MB', Icons.picture_as_pdf),
                        _buildDocumentItem('Financial Report Q3.xlsx', '1.2 MB', Icons.table_chart),
                        _buildDocumentItem('Site Photos.zip', '15.6 MB', Icons.photo_library),
                        _buildDocumentItem('Compliance Certificate.pdf', '0.8 MB', Icons.verified),
                      ]),
                      
                      const SizedBox(height: 24),
                      
                      // Progress Milestones
                      _buildDetailSection('Progress Milestones', [
                        _buildMilestoneItem('Land Acquisition', true, '2024-02-15'),
                        _buildMilestoneItem('Environmental Clearance', true, '2024-03-20'),
                        _buildMilestoneItem('Construction Phase 1', true, '2024-07-10'),
                        _buildMilestoneItem('Construction Phase 2', false, 'Expected: 2024-12-15'),
                        _buildMilestoneItem('Final Inspection', false, 'Expected: 2025-01-30'),
                      ]),
                    ],
                  ),
                ),
              ),
              
              // Action Buttons
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _flagProject(projectName);
                    },
                    icon: const Icon(Icons.flag),
                    label: const Text('Flag Project'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _generateReport(projectName);
                    },
                    icon: const Icon(Icons.report),
                    label: const Text('Generate Report'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7B1FA2),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF7B1FA2),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: children,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildAuditHistoryItem(String auditType, String date, String status, Color statusColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  auditType,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  '$date • $status',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Chip(
            label: Text(status),
            backgroundColor: statusColor.withOpacity(0.1),
            labelStyle: TextStyle(color: statusColor, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentItem(String filename, String size, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF7B1FA2)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(filename, style: const TextStyle(fontWeight: FontWeight.w500)),
                Text(size, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _downloadDocument(filename),
            icon: const Icon(Icons.download),
            tooltip: 'Download',
          ),
        ],
      ),
    );
  }

  Widget _buildMilestoneItem(String milestone, bool completed, String date) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            completed ? Icons.check_circle : Icons.radio_button_unchecked,
            color: completed ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  milestone,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    decoration: completed ? TextDecoration.lineThrough : null,
                    color: completed ? Colors.grey : null,
                  ),
                ),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods for project data
  String _getProjectId(String projectName) {
    final ids = {'Rural Road Project MH-001': 'MH-001', 'Water Supply System KA-045': 'KA-045', 'School Building TN-023': 'TN-023', 'Healthcare Center GJ-012': 'GJ-012', 'Digital Infrastructure RJ-089': 'RJ-089'};
    return ids[projectName] ?? 'PROJ-001';
  }

  String _getProjectState(String projectName) {
    if (projectName.contains('MH-')) return 'Maharashtra';
    if (projectName.contains('KA-')) return 'Karnataka';
    if (projectName.contains('TN-')) return 'Tamil Nadu';
    if (projectName.contains('GJ-')) return 'Gujarat';
    if (projectName.contains('RJ-')) return 'Rajasthan';
    return 'Maharashtra';
  }

  String _getProjectAgency(String projectName) {
    if (projectName.contains('Road')) return 'Road Development Agency';
    if (projectName.contains('Water')) return 'Water Resources Agency';
    if (projectName.contains('School')) return 'Education Infrastructure Agency';
    if (projectName.contains('Healthcare')) return 'Health Infrastructure Agency';
    if (projectName.contains('Digital')) return 'Digital Infrastructure Agency';
    return 'Infrastructure Development Agency';
  }

  String _getProjectStatus(String projectName) {
    final statuses = ['In Progress', 'Under Review', 'Completed', 'On Hold', 'Planning'];
    return statuses[projectName.hashCode % statuses.length];
  }

  String _getProjectStartDate(String projectName) {
    return '2024-01-15';
  }

  String _getProjectEndDate(String projectName) {
    return '2025-01-30';
  }

  String _getProjectBudget(String projectName) {
    final budgets = ['₹50 Crores', '₹35 Crores', '₹25 Crores', '₹40 Crores', '₹60 Crores'];
    return budgets[projectName.hashCode % budgets.length];
  }

  String _getAmountReleased(String projectName) {
    final amounts = ['₹40 Crores', '₹28 Crores', '₹20 Crores', '₹32 Crores', '₹45 Crores'];
    return amounts[projectName.hashCode % amounts.length];
  }

  String _getAmountUtilized(String projectName) {
    final amounts = ['₹35 Crores', '₹25 Crores', '₹18 Crores', '₹28 Crores', '₹38 Crores'];
    return amounts[projectName.hashCode % amounts.length];
  }

  String _getRemainingBalance(String projectName) {
    final amounts = ['₹5 Crores', '₹3 Crores', '₹2 Crores', '₹4 Crores', '₹7 Crores'];
    return amounts[projectName.hashCode % amounts.length];
  }

  String _getUtilizationPercent(String projectName) {
    final percentages = ['87%', '89%', '90%', '87%', '84%'];
    return percentages[projectName.hashCode % percentages.length];
  }

  void _downloadDocument(String filename) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Downloading $filename')),
    );
  }

  void _flagProject(String projectName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Flag Project - $projectName'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Flag Reason',
                border: OutlineInputBorder(),
              ),
              items: ['Financial Discrepancy', 'Evidence Mismatch', 'Delay', 'Compliance Issue', 'Other']
                  .map((reason) => DropdownMenuItem(value: reason, child: Text(reason)))
                  .toList(),
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.attach_file),
              label: const Text('Attach Evidence'),
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
                  content: Text('Flag submitted for $projectName. Centre Admin notified.'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Submit Flag'),
          ),
        ],
      ),
    );
  }

  void _generateReport(String projectName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Generating audit report for $projectName')),
    );
  }

  void _editFlag(String flagId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Editing flag $flagId')),
    );
  }

  void _escalateFlag(String flagId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Flag $flagId escalated to Centre Admin'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _downloadEvidence(String filename) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Downloading $filename')),
    );
  }

  void _showCommunicationHub(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening Auditor Communication Hub')),
    );
  }
}
