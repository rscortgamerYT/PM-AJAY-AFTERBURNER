import 'package:flutter/material.dart';
import '../widgets/ai_assistant.dart';
import '../widgets/accessible_components.dart';
import '../widgets/collaboration_workspace.dart';
import '../widgets/smart_analytics_dashboard.dart';
import '../services/offline_first_service.dart';

class EnhancedCentreDashboard extends StatefulWidget {
  const EnhancedCentreDashboard({super.key});

  @override
  State<EnhancedCentreDashboard> createState() => _EnhancedCentreDashboardState();
}

class _EnhancedCentreDashboardState extends State<EnhancedCentreDashboard> {
  int _selectedIndex = 0;
  bool _highContrast = false;
  double _textScale = 1.0;
  bool _showAIInsights = true;
  final OfflineFirstService _offlineService = OfflineFirstService();

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  void _initializeServices() async {
    await _offlineService.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _highContrast 
          ? AccessibilityTheme.getHighContrastTheme()
          : AccessibilityTheme.getStandardTheme(),
      child: Builder(
        builder: (context) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: _textScale,
          ),
          child: Scaffold(
            appBar: _buildAppBar(),
            drawer: _buildAccessibleDrawer(),
            body: Stack(
              children: [
                _buildBody(),
                // Offline Status Indicator
                const Positioned(
                  top: 16,
                  right: 16,
                  child: OfflineStatusIndicator(),
                ),
              ],
            ),
            bottomNavigationBar: _buildAccessibleBottomNav(),
            floatingActionButton: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Collaboration FAB
                FloatingActionButton.small(
                  onPressed: _openCollaborationWorkspace,
                  backgroundColor: Colors.purple,
                  heroTag: 'collaboration',
                  child: const Icon(Icons.people, color: Colors.white),
                ),
                const SizedBox(height: 8),
                // AI Assistant FAB
                AIAssistantFAB(
                  userRole: 'Centre Admin',
                  context: 'dashboard',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Centre Admin Dashboard'),
      backgroundColor: _highContrast ? Colors.black : const Color(0xFF3F51B5),
      foregroundColor: _highContrast ? Colors.white : Colors.white,
      actions: [
        // AI Insights Toggle
        Semantics(
          label: 'Toggle AI insights ${_showAIInsights ? 'off' : 'on'}',
          child: IconButton(
            icon: Icon(
              _showAIInsights ? Icons.psychology : Icons.psychology_outlined,
              color: _showAIInsights 
                  ? (_highContrast ? Colors.yellow : Colors.white)
                  : Colors.white70,
            ),
            onPressed: () {
              setState(() {
                _showAIInsights = !_showAIInsights;
              });
            },
            tooltip: 'AI Insights',
          ),
        ),
        
        // Accessibility Settings
        Semantics(
          label: 'Open accessibility settings',
          child: IconButton(
            icon: const Icon(Icons.accessibility),
            onPressed: _showAccessibilitySettings,
            tooltip: 'Accessibility Settings',
          ),
        ),
        
        // Notifications
        Semantics(
          label: 'View notifications',
          child: IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
            tooltip: 'Notifications',
          ),
        ),
        
        // Profile
        Semantics(
          label: 'Open user profile',
          child: IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {},
            tooltip: 'Profile',
          ),
        ),
      ],
    );
  }

  Widget _buildAccessibleDrawer() {
    return Drawer(
      backgroundColor: _highContrast ? Colors.black : null,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: _highContrast ? Colors.grey[900] : const Color(0xFF3F51B5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: _highContrast ? Colors.yellow : Colors.white,
                  child: Icon(
                    Icons.account_balance,
                    size: 30,
                    color: _highContrast ? Colors.black : const Color(0xFF3F51B5),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Centre Admin',
                  style: TextStyle(
                    color: _highContrast ? Colors.white : Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'admin@pmajay.gov.in',
                  style: TextStyle(
                    color: _highContrast ? Colors.white70 : Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          // Navigation Items with Semantic Labels
          _buildDrawerItem(
            icon: Icons.dashboard,
            title: 'Dashboard',
            semanticLabel: 'Go to main dashboard',
            onTap: () => Navigator.pop(context),
          ),
          _buildDrawerItem(
            icon: Icons.location_city,
            title: 'State Management',
            semanticLabel: 'Manage state operations',
            onTap: () => Navigator.pop(context),
          ),
          _buildDrawerItem(
            icon: Icons.account_balance_wallet,
            title: 'Fund Allocation',
            semanticLabel: 'View and manage fund allocation',
            onTap: () => Navigator.pop(context),
          ),
          _buildDrawerItem(
            icon: Icons.people,
            title: 'User Management',
            semanticLabel: 'Manage system users',
            onTap: () => Navigator.pop(context),
          ),
          _buildDrawerItem(
            icon: Icons.analytics,
            title: 'AI Analytics',
            semanticLabel: 'View AI-powered analytics and insights',
            onTap: () => Navigator.pop(context),
          ),
          _buildDrawerItem(
            icon: Icons.settings,
            title: 'Settings',
            semanticLabel: 'Open application settings',
            onTap: () => Navigator.pop(context),
          ),
          const Divider(),
          _buildDrawerItem(
            icon: Icons.logout,
            title: 'Logout',
            semanticLabel: 'Sign out of the application',
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required String semanticLabel,
    required VoidCallback onTap,
  }) {
    return Semantics(
      label: semanticLabel,
      button: true,
      child: ListTile(
        leading: Icon(
          icon,
          color: _highContrast ? Colors.yellow : null,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: _highContrast ? Colors.white : null,
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildAccessibleBottomNav() {
    return AccessibleBottomNavigation(
      currentIndex: _selectedIndex,
      onTap: (index) => setState(() => _selectedIndex = index),
      highContrast: _highContrast,
      items: const [
        AccessibleNavItem(
          label: 'Overview',
          icon: Icons.dashboard,
          semanticLabel: 'Dashboard overview',
        ),
        AccessibleNavItem(
          label: 'Projects',
          icon: Icons.account_balance,
          semanticLabel: 'Project management',
        ),
        AccessibleNavItem(
          label: 'Funds',
          icon: Icons.monetization_on,
          semanticLabel: 'Fund management',
        ),
        AccessibleNavItem(
          label: 'Analytics',
          icon: Icons.analytics,
          semanticLabel: 'AI-powered analytics and reports',
        ),
      ],
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildEnhancedOverview();
      case 1:
        return _buildEnhancedProjects();
      case 2:
        return _buildEnhancedFunds();
      case 3:
        return _buildEnhancedAnalytics();
      default:
        return _buildEnhancedOverview();
    }
  }

  Widget _buildEnhancedOverview() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AI Insights Banner
          if (_showAIInsights) _buildAIInsightsBanner(),
          
          // Page Title with Semantic Label
          Semantics(
            header: true,
            child: Text(
              'National Overview',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: _highContrast ? Colors.white : null,
              ),
            ),
          ),
          const SizedBox(height: 20),
          
          // Enhanced Statistics Grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
            children: [
              AccessibleGovernmentCard(
                title: 'Total States',
                value: '28',
                icon: Icons.location_city,
                accentColor: Colors.blue,
                highContrast: _highContrast,
                description: 'Active participating states',
                semanticLabel: 'Total States: 28. All states are actively participating in PM-AJAY program',
                onTap: () => _showStateDetails(),
              ),
              AccessibleGovernmentCard(
                title: 'Active Projects',
                value: '2,450',
                icon: Icons.work,
                accentColor: Colors.green,
                highContrast: _highContrast,
                description: 'Currently running projects',
                semanticLabel: 'Active Projects: 2,450. These are currently running projects across all states',
                onTap: () => _showProjectDetails(),
              ),
              AccessibleGovernmentCard(
                title: 'Total Budget',
                value: '₹15,000 Cr',
                icon: Icons.monetization_on,
                accentColor: Colors.orange,
                highContrast: _highContrast,
                description: 'Allocated budget for current fiscal year',
                semanticLabel: 'Total Budget: 15,000 crores rupees allocated for current fiscal year',
                onTap: () => _showBudgetDetails(),
              ),
              AccessibleGovernmentCard(
                title: 'Beneficiaries',
                value: '1.2M+',
                icon: Icons.people,
                accentColor: Colors.purple,
                highContrast: _highContrast,
                description: 'Citizens benefited from schemes',
                semanticLabel: 'Beneficiaries: Over 1.2 million citizens have benefited from PM-AJAY schemes',
                onTap: () => _showBeneficiaryDetails(),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Real-time Performance Indicators
          _buildPerformanceIndicators(),
          
          const SizedBox(height: 24),
          
          // Recent Activities with Enhanced Accessibility
          _buildAccessibleActivitiesList(),
        ],
      ),
    );
  }

  Widget _buildAIInsightsBanner() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _highContrast 
              ? [Colors.grey[800]!, Colors.grey[900]!]
              : [Colors.blue[50]!, Colors.blue[100]!],
        ),
        borderRadius: BorderRadius.circular(12),
        border: _highContrast 
            ? Border.all(color: Colors.yellow, width: 2)
            : null,
      ),
      child: Semantics(
        label: 'AI generated insights for today',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.psychology,
                  color: _highContrast ? Colors.yellow : Colors.blue[700],
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'AI Insights for Today',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _highContrast ? Colors.white : Colors.blue[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInsightItem(
              '📈 Fund utilization improved by 15% this quarter',
              'Positive trend in budget execution across states',
            ),
            _buildInsightItem(
              '⚠️ 3 states showing concerning project delay patterns',
              'Bihar, Jharkhand, and Odisha need immediate attention',
            ),
            _buildInsightItem(
              '🎯 Predicted 95% target achievement for Q4',
              'Based on current performance trends and resource allocation',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightItem(String insight, String detail) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
              color: _highContrast ? Colors.yellow : Colors.blue[600],
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  insight,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _highContrast ? Colors.white : Colors.black87,
                  ),
                ),
                Text(
                  detail,
                  style: TextStyle(
                    fontSize: 12,
                    color: _highContrast ? Colors.white70 : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceIndicators() {
    return Card(
      color: _highContrast ? Colors.grey[900] : null,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Real-time Performance',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _highContrast ? Colors.white : null,
              ),
            ),
            const SizedBox(height: 16),
            
            // Fund Utilization Progress
            _buildProgressIndicator(
              'Fund Utilization',
              0.83,
              '₹12,500 Cr of ₹15,000 Cr',
              Colors.green,
            ),
            
            const SizedBox(height: 12),
            
            // Project Completion Progress
            _buildProgressIndicator(
              'Project Completion',
              0.68,
              '1,666 of 2,450 projects',
              Colors.blue,
            ),
            
            const SizedBox(height: 12),
            
            // Quality Score Progress
            _buildProgressIndicator(
              'Quality Score',
              0.91,
              '4.55 out of 5.0 average rating',
              Colors.purple,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(String label, double progress, String detail, Color color) {
    return Semantics(
      label: '$label: ${(progress * 100).toInt()}% complete. $detail',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _highContrast ? Colors.white : null,
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: _highContrast ? Colors.yellow : color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: _highContrast ? Colors.grey[700] : Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(
              _highContrast ? Colors.yellow : color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            detail,
            style: TextStyle(
              fontSize: 12,
              color: _highContrast ? Colors.white70 : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccessibleActivitiesList() {
    return Card(
      color: _highContrast ? Colors.grey[900] : null,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Activities',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _highContrast ? Colors.white : null,
              ),
            ),
            const SizedBox(height: 16),
            _buildActivityItem(
              'Maharashtra submitted new project proposal',
              '2 hours ago',
              Icons.upload_file,
              Colors.blue,
            ),
            _buildActivityItem(
              'Karnataka fund utilization report approved',
              '4 hours ago',
              Icons.check_circle,
              Colors.green,
            ),
            _buildActivityItem(
              'Tamil Nadu requested budget revision',
              '6 hours ago',
              Icons.edit,
              Colors.orange,
            ),
            _buildActivityItem(
              'Gujarat project milestone completed',
              '8 hours ago',
              Icons.flag,
              Colors.purple,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(String activity, String time, IconData icon, Color color) {
    return Semantics(
      label: '$activity, $time',
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: (_highContrast ? Colors.yellow : color).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 16,
                color: _highContrast ? Colors.yellow : color,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity,
                    style: TextStyle(
                      fontSize: 14,
                      color: _highContrast ? Colors.white : null,
                    ),
                  ),
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 12,
                      color: _highContrast ? Colors.white70 : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedProjects() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Semantics(
                header: true,
                child: Text(
                  'Project Management',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _highContrast ? Colors.white : null,
                  ),
                ),
              ),
              AccessibleElevatedButton(
                text: 'New Project',
                icon: Icons.add,
                highContrast: _highContrast,
                onPressed: () {},
                semanticLabel: 'Create new project',
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Project filters and search would go here
          _buildProjectsList(),
        ],
      ),
    );
  }

  Widget _buildProjectsList() {
    final projects = [
      {'name': 'Rural Infrastructure Development', 'state': 'Maharashtra', 'status': 'Active', 'progress': 0.75},
      {'name': 'Education Facility Upgrade', 'state': 'Karnataka', 'status': 'Pending', 'progress': 0.45},
      {'name': 'Healthcare Center Construction', 'state': 'Tamil Nadu', 'status': 'Completed', 'progress': 1.0},
      {'name': 'Water Supply Enhancement', 'state': 'Gujarat', 'status': 'Review', 'progress': 0.60},
      {'name': 'Digital Literacy Program', 'state': 'Rajasthan', 'status': 'Active', 'progress': 0.30},
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: projects.length,
      itemBuilder: (context, index) {
        final project = projects[index];
        return Card(
          color: _highContrast ? Colors.grey[900] : null,
          margin: const EdgeInsets.only(bottom: 12),
          child: Semantics(
            label: 'Project: ${project['name']}, State: ${project['state']}, Status: ${project['status']}, Progress: ${((project['progress'] as double) * 100).toInt()}%',
            button: true,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: _highContrast ? Colors.yellow : Colors.blue[100],
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    color: _highContrast ? Colors.black : Colors.blue[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                project['name'] as String,
                style: TextStyle(
                  color: _highContrast ? Colors.white : null,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'State: ${project['state']}',
                    style: TextStyle(
                      color: _highContrast ? Colors.white70 : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: project['progress'] as double,
                    backgroundColor: _highContrast ? Colors.grey[700] : null,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _highContrast ? Colors.yellow : Colors.green,
                    ),
                  ),
                ],
              ),
              trailing: Chip(
                label: Text(
                  project['status'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    color: _highContrast ? Colors.black : null,
                  ),
                ),
                backgroundColor: _highContrast ? Colors.yellow : _getStatusColor(project['status'] as String),
              ),
              onTap: () {},
            ),
          ),
        );
      },
    );
  }

  Widget _buildEnhancedFunds() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            child: Text(
              'Fund Management',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: _highContrast ? Colors.white : null,
              ),
            ),
          ),
          const SizedBox(height: 20),
          
          // Fund overview cards
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.5,
            children: [
              AccessibleGovernmentCard(
                title: 'Total Allocated',
                value: '₹15,000 Cr',
                highContrast: _highContrast,
                semanticLabel: 'Total allocated funds: 15,000 crores rupees',
              ),
              AccessibleGovernmentCard(
                title: 'Total Utilized',
                value: '₹12,500 Cr',
                highContrast: _highContrast,
                accentColor: Colors.green,
                semanticLabel: 'Total utilized funds: 12,500 crores rupees',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedAnalytics() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            child: Text(
              'AI-Powered Analytics',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: _highContrast ? Colors.white : null,
              ),
            ),
          ),
          const SizedBox(height: 20),
          
          // Smart Analytics Dashboard
          Expanded(
            child: SmartAnalyticsDashboard(
              userRole: 'Centre Admin',
              highContrast: _highContrast,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green[100]!;
      case 'pending':
        return Colors.orange[100]!;
      case 'completed':
        return Colors.blue[100]!;
      case 'review':
        return Colors.purple[100]!;
      default:
        return Colors.grey[100]!;
    }
  }

  void _showAccessibilitySettings() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: _highContrast ? Colors.black : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: AccessibilitySettings(
          initialHighContrast: _highContrast,
          initialTextScale: _textScale,
          onHighContrastChanged: (value) {
            setState(() {
              _highContrast = value;
            });
          },
          onTextScaleChanged: (value) {
            setState(() {
              _textScale = value;
            });
          },
        ),
      ),
    );
  }

  void _showStateDetails() {
    // Implementation for state details
  }

  void _showProjectDetails() {
    // Implementation for project details
  }

  void _showBudgetDetails() {
    // Implementation for budget details
  }

  void _showBeneficiaryDetails() {
    // Implementation for beneficiary details
  }

  void _openCollaborationWorkspace() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CollaborativeWorkspace(
          documentId: 'centre_policy_doc_001',
          userRole: 'Centre Admin',
          collaborators: [
            'State Officer - Maharashtra',
            'State Officer - Karnataka',
            'Agency User - Infrastructure Corp',
            'Auditor - Dr. Singh',
          ],
        ),
      ),
    );
  }
}
