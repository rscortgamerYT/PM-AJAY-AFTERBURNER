import 'package:flutter/material.dart';

class StateDashboard extends StatefulWidget {
  final String stateName;
  
  const StateDashboard({super.key, this.stateName = 'Maharashtra'});

  @override
  State<StateDashboard> createState() => _StateDashboardState();
}

class _StateDashboardState extends State<StateDashboard> {
  int _selectedIndex = 0;
  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _sectionKeys = List.generate(7, (index) => GlobalKey());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.stateName} State Dashboard'),
        backgroundColor: const Color(0xFF1976D2),
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
                      '3',
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
          Expanded(
            child: _buildInfiniteScrollContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF1976D2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.location_city,
                    size: 30,
                    color: Color(0xFF1976D2),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${widget.stateName} Officer',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'state.officer@pmajay.gov.in',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('State Overview'),
            selected: _selectedIndex == 0,
            onTap: () {
              setState(() => _selectedIndex = 0);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.business_center),
            title: const Text('Agency Review Panel'),
            selected: _selectedIndex == 1,
            onTap: () {
              setState(() => _selectedIndex = 1);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.request_page),
            title: const Text('Public Requests'),
            selected: _selectedIndex == 2,
            onTap: () {
              setState(() => _selectedIndex = 2);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_balance_wallet),
            title: const Text('Fund Release'),
            selected: _selectedIndex == 3,
            onTap: () {
              setState(() => _selectedIndex = 3);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.analytics),
            title: const Text('District Analytics'),
            selected: _selectedIndex == 4,
            onTap: () {
              setState(() => _selectedIndex = 4);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.flag),
            title: const Text('Audit Flags'),
            selected: _selectedIndex == 5,
            onTap: () {
              setState(() => _selectedIndex = 5);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            selected: _selectedIndex == 6,
            onTap: () {
              setState(() => _selectedIndex = 6);
              Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildStateOverview();
      case 1:
        return _buildAgencyReviewPanel();
      case 2:
        return _buildPublicRequests();
      case 3:
        return _buildFundRelease();
      case 4:
        return _buildDistrictAnalytics();
      case 5:
        return _buildStateAuditFlags();
      case 6:
        return _buildSettings();
      default:
        return _buildStateOverview();
    }
  }

  Widget _buildStateOverview() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${widget.stateName} State Overview',
            style: const TextStyle(
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
              _buildStatCard('Districts', '36', Icons.location_on, Colors.blue),
              _buildStatCard('Active Projects', '245', Icons.work, Colors.green),
              _buildStatCard('Budget Allocated', '₹2,000 Cr', Icons.monetization_on, Colors.orange),
              _buildStatCard('Beneficiaries', '150K+', Icons.people, Colors.purple),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Fund Utilization',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        LinearProgressIndicator(
                          value: 0.75,
                          backgroundColor: Colors.grey[300],
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                        ),
                        const SizedBox(height: 8),
                        const Text('75% Utilized (₹1,500 Cr)'),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Project Progress',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        LinearProgressIndicator(
                          value: 0.68,
                          backgroundColor: Colors.grey[300],
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                        const SizedBox(height: 8),
                        const Text('68% Complete'),
                      ],
                    ),
                  ),
                ),
              ),
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
                    'Recent Updates',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildUpdateItem('Pune district project milestone achieved', '1 hour ago'),
                  _buildUpdateItem('Nashik agency submitted progress report', '3 hours ago'),
                  _buildUpdateItem('Mumbai infrastructure project approved', '5 hours ago'),
                  _buildUpdateItem('Nagpur fund request processed', '1 day ago'),
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
                'State Projects',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('New Request'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1976D2),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 6,
            itemBuilder: (context, index) {
              final projects = [
                'Rural Infrastructure Development',
                'Education Facility Upgrade',
                'Healthcare Center Construction',
                'Water Supply Enhancement',
                'Digital Literacy Program',
                'Skill Development Initiative'
              ];
              final districts = ['Mumbai', 'Pune', 'Nashik', 'Nagpur', 'Aurangabad', 'Solapur'];
              final statuses = ['Active', 'Pending', 'Completed', 'Review', 'Active', 'Planning'];
              final colors = [Colors.green, Colors.orange, Colors.blue, Colors.purple, Colors.green, Colors.grey];
              
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: colors[index][100],
                    child: Text('${index + 1}'),
                  ),
                  title: Text(projects[index]),
                  subtitle: Text('District: ${districts[index]}'),
                  trailing: Chip(
                    label: Text(statuses[index]),
                    backgroundColor: colors[index][100],
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

  Widget _buildDistricts() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'District Management',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
            ),
            itemCount: 6,
            itemBuilder: (context, index) {
              final districts = ['Mumbai', 'Pune', 'Nashik', 'Nagpur', 'Aurangabad', 'Solapur'];
              final projects = ['45', '32', '28', '35', '22', '18'];
              final budgets = ['₹400 Cr', '₹300 Cr', '₹250 Cr', '₹320 Cr', '₹200 Cr', '₹150 Cr'];
              
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_city, color: Colors.blue[600]),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              districts[index],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text('Projects: ${projects[index]}'),
                      Text('Budget: ${budgets[index]}'),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1976D2),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 32),
                        ),
                        child: const Text('View Details'),
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

  Widget _buildReports() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Reports & Analytics',
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
              _buildReportCard('Monthly Report', Icons.calendar_month, Colors.blue),
              _buildReportCard('Financial Report', Icons.account_balance_wallet, Colors.green),
              _buildReportCard('Progress Report', Icons.trending_up, Colors.orange),
              _buildReportCard('Compliance Report', Icons.verified, Colors.purple),
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
                    'Performance Metrics',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildMetricRow('Project Completion Rate', '68%', Colors.blue),
                  _buildMetricRow('Budget Utilization', '75%', Colors.green),
                  _buildMetricRow('Timeline Adherence', '82%', Colors.orange),
                  _buildMetricRow('Quality Score', '91%', Colors.purple),
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

  Widget _buildReportCard(String title, IconData icon, Color color) {
    return Card(
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpdateItem(String update, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFF1976D2),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(update, style: const TextStyle(fontSize: 14)),
                Text(time, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14)),
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

  // State Review Panel - Agency Registration Requests
  Widget _buildAgencyReviewPanel() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Agency Review Panel',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _bulkApproveAgencies(),
                    icon: const Icon(Icons.verified),
                    label: const Text('Bulk Approve'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () => _autoAssignTasks(),
                    icon: const Icon(Icons.auto_awesome),
                    label: const Text('Auto-Assign Tasks'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1976D2),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Agency Registration Requests
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            itemBuilder: (context, index) {
              final agencies = [
                'Tech Solutions Pvt Ltd',
                'Infrastructure Builders',
                'Rural Development Corp',
                'Digital Services Agency'
              ];
              final capabilities = [
                ['Software Development', 'Digital Infrastructure', 'Data Analytics'],
                ['Construction', 'Project Management', 'Quality Assurance'],
                ['Rural Planning', 'Community Engagement', 'Sustainability'],
                ['Digital Transformation', 'Cloud Services', 'Cybersecurity']
              ];
              final scores = [92, 85, 78, 88];
              final statuses = ['Pending Review', 'Documents Submitted', 'Under Verification', 'Ready for Approval'];
              
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ExpansionTile(
                  leading: CircleAvatar(
                    backgroundColor: _getStatusColor(statuses[index]).withOpacity(0.2),
                    child: Text(
                      agencies[index][0],
                      style: TextStyle(
                        color: _getStatusColor(statuses[index]),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(agencies[index]),
                  subtitle: Row(
                    children: [
                      Chip(
                        label: Text(statuses[index]),
                        backgroundColor: _getStatusColor(statuses[index]).withOpacity(0.1),
                      ),
                      const SizedBox(width: 8),
                      Text('Capability Score: ${scores[index]}%'),
                    ],
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Capability Checklist
                          const Text(
                            'Capability Checklist:',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 12),
                          ...capabilities[index].map((capability) => 
                            _buildCapabilityItem(capability, true)
                          ).toList(),
                          
                          const SizedBox(height: 16),
                          
                          // Document Verification
                          const Text(
                            'Document Verification:',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 12),
                          _buildDocumentItem('Registration Certificate', true),
                          _buildDocumentItem('Financial Statements', true),
                          _buildDocumentItem('Experience Portfolio', index < 2),
                          _buildDocumentItem('Technical Certifications', index == 0),
                          
                          const SizedBox(height: 16),
                          
                          // Onboarding Tasks
                          const Text(
                            'Onboarding Tasks:',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 12),
                          _buildOnboardingTask('Complete Profile Setup', index > 1),
                          _buildOnboardingTask('Digital Signature Setup', index > 2),
                          _buildOnboardingTask('PFMS Integration', false),
                          
                          const SizedBox(height: 20),
                          
                          // Action Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () => _issueOnboardingTasks(agencies[index]),
                                icon: const Icon(Icons.task_alt),
                                label: const Text('Issue Tasks'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: () => _approveAgencyRegistration(agencies[index]),
                                icon: const Icon(Icons.check_circle),
                                label: const Text('Approve'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: () => _rejectAgencyRegistration(agencies[index]),
                                icon: const Icon(Icons.cancel),
                                label: const Text('Reject'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
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
    );
  }

  Widget _buildCapabilityItem(String capability, bool verified) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            verified ? Icons.verified : Icons.pending,
            size: 16,
            color: verified ? Colors.green : Colors.orange,
          ),
          const SizedBox(width: 8),
          Text(capability),
        ],
      ),
    );
  }

  Widget _buildDocumentItem(String document, bool submitted) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            submitted ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 16,
            color: submitted ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 8),
          Text(document),
          if (submitted) ...[
            const Spacer(),
            TextButton(
              onPressed: () => _viewDocument(document),
              child: const Text('View'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOnboardingTask(String task, bool completed) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            completed ? Icons.task_alt : Icons.radio_button_unchecked,
            size: 16,
            color: completed ? Colors.blue : Colors.grey,
          ),
          const SizedBox(width: 8),
          Text(task),
          if (!completed) ...[
            const Spacer(),
            TextButton(
              onPressed: () => _assignTask(task),
              child: const Text('Assign'),
            ),
          ],
        ],
      ),
    );
  }

  // Placeholder methods for other sections
  Widget _buildPublicRequests() {
    return const Center(child: Text('Public Requests Management'));
  }

  Widget _buildFundRelease() {
    return const Center(child: Text('Fund Release Console'));
  }

  Widget _buildDistrictAnalytics() {
    return const Center(child: Text('District Analytics Dashboard'));
  }

  // State Audit Action Panel
  Widget _buildStateAuditFlags() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${widget.stateName} Audit Action Panel',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _refreshStateFlags(),
                icon: const Icon(Icons.refresh),
                label: const Text('Refresh'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1976D2),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Flag Statistics
          Row(
            children: [
              Expanded(
                child: _buildStateFlagCard('Incoming Flags', '5', Icons.flag, Colors.orange),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStateFlagCard('Under Review', '3', Icons.search, Colors.blue),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStateFlagCard('Awaiting Agency', '2', Icons.business, Colors.purple),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStateFlagCard('Resolved', '8', Icons.check_circle, Colors.green),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Incoming Flags Table
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Flags Assigned from Centre Admin',
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
                      final flagIds = ['FLG-001', 'FLG-003', 'FLG-007', 'FLG-009'];
                      final projects = ['Rural Road Project MH-001', 'School Building MH-023', 'Healthcare Center MH-045', 'Water Supply MH-067'];
                      final centreComments = [
                        'Financial discrepancy requires immediate investigation',
                        'Evidence mismatch detected in submitted documents',
                        'Compliance issue with safety standards',
                        'Project delay exceeding approved timeline'
                      ];
                      final reasons = ['Financial Discrepancy', 'Evidence Mismatch', 'Compliance Issue', 'Project Delay'];
                      final statuses = ['Under Review', 'Awaiting Agency Response', 'Under Review', 'Awaiting Agency Response'];
                      final dates = ['2024-01-15', '2024-01-14', '2024-01-13', '2024-01-12'];
                      final slaHours = [18, 36, 24, 12];
                      
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ExpansionTile(
                          leading: CircleAvatar(
                            backgroundColor: _getStateFlagStatusColor(statuses[index]).withOpacity(0.2),
                            child: Text(
                              flagIds[index].split('-')[1],
                              style: TextStyle(
                                color: _getStateFlagStatusColor(statuses[index]),
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
                                    backgroundColor: _getStateFlagReasonColor(reasons[index]).withOpacity(0.1),
                                  ),
                                  const SizedBox(width: 8),
                                  Chip(
                                    label: Text('SLA: ${slaHours[index]}h'),
                                    backgroundColor: slaHours[index] < 24 ? Colors.red.withOpacity(0.1) : Colors.green.withOpacity(0.1),
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
                                    'Centre Comments:',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(centreComments[index]),
                                  const SizedBox(height: 16),
                                  
                                  const Text(
                                    'Investigation Status:',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  LinearProgressIndicator(
                                    value: index == 0 ? 0.7 : index == 1 ? 0.4 : index == 2 ? 0.8 : 0.3,
                                    backgroundColor: Colors.grey[300],
                                    valueColor: AlwaysStoppedAnimation<Color>(_getStateFlagStatusColor(statuses[index])),
                                  ),
                                  const SizedBox(height: 16),
                                  
                                  // Action Buttons
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton.icon(
                                        onPressed: () => _investigateFlag(flagIds[index], projects[index]),
                                        icon: const Icon(Icons.search),
                                        label: const Text('Investigate'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                          foregroundColor: Colors.white,
                                        ),
                                      ),
                                      ElevatedButton.icon(
                                        onPressed: () => _requestAgencyInput(flagIds[index], projects[index]),
                                        icon: const Icon(Icons.business),
                                        label: const Text('Request Agency Input'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.purple,
                                          foregroundColor: Colors.white,
                                        ),
                                      ),
                                      ElevatedButton.icon(
                                        onPressed: () => _resolveStateFlag(flagIds[index], projects[index]),
                                        icon: const Icon(Icons.check_circle),
                                        label: const Text('Resolve'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
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
          
          const SizedBox(height: 24),
          
          // Flag Investigation Tickets
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Flag Investigation Tickets',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      final ticketIds = ['TKT-FLG-001', 'TKT-FLG-002', 'TKT-FLG-003'];
                      final agencies = ['Infrastructure Corp Ltd', 'Rural Development Agency', 'Tech Solutions Pvt Ltd'];
                      final ticketStatuses = ['Open', 'Awaiting Response', 'Resolved'];
                      
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _getTicketStatusColor(ticketStatuses[index]).withOpacity(0.2),
                          child: Icon(
                            Icons.assignment,
                            color: _getTicketStatusColor(ticketStatuses[index]),
                          ),
                        ),
                        title: Text(ticketIds[index]),
                        subtitle: Text('Agency: ${agencies[index]}'),
                        trailing: Chip(
                          label: Text(ticketStatuses[index]),
                          backgroundColor: _getTicketStatusColor(ticketStatuses[index]).withOpacity(0.1),
                        ),
                        onTap: () => _openFlagTicket(ticketIds[index]),
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

  Widget _buildStateFlagCard(String title, String value, IconData icon, Color color) {
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

  Color _getStateFlagStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'under review':
        return Colors.blue;
      case 'awaiting agency response':
        return Colors.purple;
      case 'resolved':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Color _getStateFlagReasonColor(String reason) {
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

  Color _getTicketStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return Colors.red;
      case 'awaiting response':
        return Colors.orange;
      case 'resolved':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  // State Flag Action Methods
  void _investigateFlag(String flagId, String projectName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Investigate Flag - $flagId'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Start investigation for "$projectName"?'),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Investigation Notes',
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
                  content: Text('Investigation started for $flagId. Status updated.'),
                  backgroundColor: Colors.blue,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: const Text('Start Investigation'),
          ),
        ],
      ),
    );
  }

  void _requestAgencyInput(String flagId, String projectName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Request Agency Input - $flagId'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Generate agency ticket for "$projectName"?'),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Request Details',
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
                  content: Text('Agency ticket generated for $flagId. Notification sent to agency.'),
                  backgroundColor: Colors.purple,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
            child: const Text('Generate Ticket'),
          ),
        ],
      ),
    );
  }

  void _resolveStateFlag(String flagId, String projectName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Resolve Flag - $flagId'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Mark flag for "$projectName" as resolved?'),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Resolution Notes (Required)',
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
                  content: Text('Flag $flagId resolved. Centre Admin and Auditor notified.'),
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

  void _openFlagTicket(String ticketId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening ticket $ticketId')),
    );
  }

  void _refreshStateFlags() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Refreshing state audit flags...')),
    );
  }

  Widget _buildSettings() {
    return const Center(child: Text('State Settings'));
  }

  // Helper methods
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending review':
        return Colors.orange;
      case 'documents submitted':
        return Colors.blue;
      case 'under verification':
        return Colors.purple;
      case 'ready for approval':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  // Action methods
  void _bulkApproveAgencies() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Bulk approval initiated for eligible agencies'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _autoAssignTasks() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Auto-assigning onboarding tasks based on agency profiles'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _issueOnboardingTasks(String agencyName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Issue Onboarding Tasks - $agencyName'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Select tasks to assign to this agency:'),
            SizedBox(height: 16),
            CheckboxListTile(
              title: Text('Complete Profile Setup'),
              value: true,
              onChanged: null,
            ),
            CheckboxListTile(
              title: Text('Digital Signature Setup'),
              value: true,
              onChanged: null,
            ),
            CheckboxListTile(
              title: Text('PFMS Integration'),
              value: false,
              onChanged: null,
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
                SnackBar(content: Text('Onboarding tasks issued to $agencyName')),
              );
            },
            child: const Text('Issue Tasks'),
          ),
        ],
      ),
    );
  }

  void _approveAgencyRegistration(String agencyName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Approve Agency - $agencyName'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Approve $agencyName for registration?'),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Approval Notes',
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
                  content: Text('$agencyName approved successfully. Notification sent to agency.'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Approve'),
          ),
        ],
      ),
    );
  }

  void _rejectAgencyRegistration(String agencyName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reject Agency - $agencyName'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Reject $agencyName registration?'),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Rejection Reason (Required)',
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
                  content: Text('$agencyName registration rejected. Notification sent.'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Reject'),
          ),
        ],
      ),
    );
  }

  void _viewDocument(String document) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening $document')),
    );
  }

  void _assignTask(String task) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$task assigned to agency')),
    );
  }

  // Communication Hub Implementation for State Officer
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
                  color: Color(0xFF1976D2),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.forum, color: Colors.white, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '${widget.stateName} State Communication Hub',
                        style: const TextStyle(
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
                        labelColor: Color(0xFF1976D2),
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
                            _buildStateChannelsTab(),
                            _buildStateDocumentsTab(),
                            _buildStateTicketsTab(),
                            _buildStateMeetingsTab(),
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

  Widget _buildStateChannelsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // State-Agency Coordination Channel
        _buildStateChannelCard(
          'State–Agency Coordination',
          'Active coordination with registered agencies',
          Icons.business,
          Colors.green,
          2,
          [
            'Tech Solutions: Profile setup completed',
            'Infrastructure Builders: Awaiting document verification',
          ],
        ),
        
        const SizedBox(height: 12),
        
        // State-Centre Queries Channel
        _buildStateChannelCard(
          'State–Centre Queries',
          'Communication with Centre Admin',
          Icons.account_balance,
          Colors.blue,
          1,
          [
            'Fund release request submitted',
            'Awaiting Centre approval for new project',
          ],
        ),
        
        const SizedBox(height: 12),
        
        // Public Requests Channel
        _buildStateChannelCard(
          'Public Requests',
          'Citizen requests and grievances',
          Icons.people,
          Colors.orange,
          0,
          [
            'Road repair request - District 12',
            'Water supply issue resolved',
          ],
        ),
      ],
    );
  }

  Widget _buildStateChannelCard(String title, String subtitle, IconData icon, Color color, int unreadCount, List<String> recentMessages) {
    return Card(
      child: InkWell(
        onTap: () => _openStateChannel(title),
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

  Widget _buildStateDocumentsTab() {
    return const Center(child: Text('State Documents & File Sharing'));
  }

  Widget _buildStateTicketsTab() {
    return const Center(child: Text('State Tickets & Escalations'));
  }

  Widget _buildStateMeetingsTab() {
    return const Center(child: Text('State Meetings & Coordination'));
  }

  void _openStateChannel(String channelName) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening $channelName channel')),
    );
  }

  // Permanent Sidebar Implementation for State Dashboard
  Widget _buildPermanentSidebar() {
    final sidebarItems = [
      {'title': 'State Overview', 'icon': Icons.dashboard, 'index': 0},
      {'title': 'Agency Review Panel', 'icon': Icons.business_center, 'index': 1},
      {'title': 'Public Requests', 'icon': Icons.request_page, 'index': 2},
      {'title': 'Fund Release', 'icon': Icons.account_balance_wallet, 'index': 3},
      {'title': 'District Analytics', 'icon': Icons.analytics, 'index': 4},
      {'title': 'Audit Flags', 'icon': Icons.flag, 'index': 5},
      {'title': 'Settings', 'icon': Icons.settings, 'index': 6},
    ];

    return Column(
      children: [
        // Profile Header
        Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Color(0xFF1976D2),
          ),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.location_city,
                  size: 30,
                  color: Color(0xFF1976D2),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '${widget.stateName} State',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'state.officer@pmajay.gov.in',
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
                  color: isSelected ? const Color(0xFF1976D2).withOpacity(0.1) : null,
                ),
                child: ListTile(
                  leading: Icon(
                    item['icon'] as IconData,
                    color: isSelected ? const Color(0xFF1976D2) : Colors.grey[600],
                  ),
                  title: Text(
                    item['title'] as String,
                    style: TextStyle(
                      color: isSelected ? const Color(0xFF1976D2) : Colors.grey[800],
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

  // Infinite Scroll Content for State Dashboard
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
            // State Overview Section
            Container(
              key: _sectionKeys[0],
              child: _buildStateOverview(),
            ),
            
            // Agency Review Panel Section
            Container(
              key: _sectionKeys[1],
              child: _buildAgencyReviewPanel(),
            ),
            
            // Public Requests Section
            Container(
              key: _sectionKeys[2],
              child: _buildPublicRequests(),
            ),
            
            // Fund Release Section
            Container(
              key: _sectionKeys[3],
              child: _buildFundRelease(),
            ),
            
            // District Analytics Section
            Container(
              key: _sectionKeys[4],
              child: _buildDistrictAnalytics(),
            ),
            
            // Audit Flags Section
            Container(
              key: _sectionKeys[5],
              child: _buildStateAuditFlags(),
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
