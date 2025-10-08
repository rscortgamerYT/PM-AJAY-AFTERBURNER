import 'package:flutter/material.dart';
import '../models/user_role.dart';
import '../widgets/responsive_layout.dart';
import '../widgets/dashboard_widgets.dart';
import 'complete_demo_screens.dart';
import 'dashboards/centre_admin_dashboard.dart';
import 'dashboards/state_officer_dashboard_enhanced.dart';
import 'dashboards/agency_dashboard_enhanced.dart';
import 'dashboards/auditor_dashboard_enhanced.dart';
import 'dashboards/public_portal_dashboard_enhanced.dart';

class DemoHomeScreen extends StatefulWidget {
  final UserRoleType demoRole;
  
  const DemoHomeScreen({
    super.key,
    required this.demoRole,
  });

  @override
  State<DemoHomeScreen> createState() => _DemoHomeScreenState();
}

class _DemoHomeScreenState extends State<DemoHomeScreen> {
  int _selectedIndex = 0;

  List<NavigationDestination> get _destinations {
    switch (widget.demoRole) {
      case UserRoleType.centreAdmin:
        return const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.folder_outlined), selectedIcon: Icon(Icons.folder), label: 'Projects'),
          NavigationDestination(icon: Icon(Icons.account_balance_outlined), selectedIcon: Icon(Icons.account_balance), label: 'Funds'),
          NavigationDestination(icon: Icon(Icons.business_outlined), selectedIcon: Icon(Icons.business), label: 'Agencies'),
          NavigationDestination(icon: Icon(Icons.analytics_outlined), selectedIcon: Icon(Icons.analytics), label: 'Analytics'),
        ];
      case UserRoleType.stateOfficer:
        return const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.folder_outlined), selectedIcon: Icon(Icons.folder), label: 'Projects'),
          NavigationDestination(icon: Icon(Icons.account_balance_outlined), selectedIcon: Icon(Icons.account_balance), label: 'Funds'),
          NavigationDestination(icon: Icon(Icons.business_outlined), selectedIcon: Icon(Icons.business), label: 'Agencies'),
          NavigationDestination(icon: Icon(Icons.assessment_outlined), selectedIcon: Icon(Icons.assessment), label: 'Reports'),
        ];
      case UserRoleType.agencyUser:
        return const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.folder_outlined), selectedIcon: Icon(Icons.folder), label: 'My Projects'),
          NavigationDestination(icon: Icon(Icons.upload_outlined), selectedIcon: Icon(Icons.upload), label: 'Evidence'),
          NavigationDestination(icon: Icon(Icons.timeline_outlined), selectedIcon: Icon(Icons.timeline), label: 'Progress'),
        ];
      case UserRoleType.auditor:
        return const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.folder_outlined), selectedIcon: Icon(Icons.folder), label: 'Projects'),
          NavigationDestination(icon: Icon(Icons.verified_outlined), selectedIcon: Icon(Icons.verified), label: 'Audits'),
          NavigationDestination(icon: Icon(Icons.assessment_outlined), selectedIcon: Icon(Icons.assessment), label: 'Reports'),
        ];
      case UserRoleType.publicViewer:
        return const [
          NavigationDestination(icon: Icon(Icons.public_outlined), selectedIcon: Icon(Icons.public), label: 'Public Dashboard'),
          NavigationDestination(icon: Icon(Icons.feedback_outlined), selectedIcon: Icon(Icons.feedback), label: 'Feedback'),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: _buildMobileLayout(),
      tabletBody: _buildTabletLayout(),
      desktopBody: _buildDesktopLayout(),
    );
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      appBar: AppBar(
        title: Text('PM-AJAY - ${widget.demoRole.displayName}'),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: _buildContent(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: _destinations,
      ),
    );
  }

  Widget _buildTabletLayout() {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            extended: true,
            destinations: _destinations.map((dest) => NavigationRailDestination(
              icon: dest.icon,
              selectedIcon: dest.selectedIcon,
              label: Text(dest.label),
            )).toList(),
            trailing: Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Chip(
                        label: Text(widget.demoRole.displayName),
                        avatar: const Icon(Icons.person, size: 16),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Exit Demo'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Column(
              children: [
                AppBar(
                  title: Text(_getPageTitle()),
                  automaticallyImplyLeading: false,
                ),
                Expanded(child: _buildContent()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return _buildTabletLayout();
  }

  String _getPageTitle() {
    if (_selectedIndex >= _destinations.length) return 'PM-AJAY';
    return _destinations[_selectedIndex].label;
  }

  Widget _buildContent() {
    switch (widget.demoRole) {
      case UserRoleType.centreAdmin:
        return _buildCentreAdminContent();
      case UserRoleType.stateOfficer:
        return _buildStateOfficerContent();
      case UserRoleType.agencyUser:
        return _buildAgencyUserContent();
      case UserRoleType.auditor:
        return _buildAuditorContent();
      case UserRoleType.publicViewer:
        return _buildPublicViewerContent();
    }
  }

  Widget _buildCentreAdminContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildCentreAdminDashboard();
      case 1:
        return _buildProjectsManagement();
      case 2:
        return _buildFundsManagement();
      case 3:
        return _buildAgencyManagement();
      case 4:
        return _buildAnalytics();
      default:
        return _buildCentreAdminDashboard();
    }
  }

  Widget _buildStateOfficerContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildStateOfficerDashboard();
      case 1:
        return _buildProjectsManagement();
      case 2:
        return _buildFundsManagement();
      case 3:
        return _buildAgencyManagement();
      case 4:
        return _buildReports();
      default:
        return _buildStateOfficerDashboard();
    }
  }

  Widget _buildAgencyUserContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildAgencyUserDashboard();
      case 1:
        return _buildMyProjects();
      case 2:
        return _buildEvidenceUpload();
      case 3:
        return _buildProgressTracking();
      default:
        return _buildAgencyUserDashboard();
    }
  }

  Widget _buildAuditorContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildAuditorDashboard();
      case 1:
        return _buildProjectsManagement();
      case 2:
        return _buildAuditManagement();
      case 3:
        return _buildReports();
      default:
        return _buildAuditorDashboard();
    }
  }

  Widget _buildPublicViewerContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildPublicDashboard();
      case 1:
        return _buildFeedbackSystem();
      default:
        return _buildPublicDashboard();
    }
  }

  // Centre Admin Dashboard
  Widget _buildCentreAdminDashboard() {
    return const CentreAdminDashboard();
  }

  // State Officer Dashboard
  Widget _buildStateOfficerDashboard() {
    return const StateOfficerDashboardEnhanced(
      stateId: 'demo-state-001',
    );
  }

  // Agency User Dashboard
  Widget _buildAgencyUserDashboard() {
    return const AgencyDashboardEnhanced(
      agencyId: 'demo-agency-001',
    );
  }

  // Auditor Dashboard
  Widget _buildAuditorDashboard() {
    return const AuditorDashboardEnhanced();
  }

  // Public Dashboard
  Widget _buildPublicDashboard() {
    return const PublicPortalDashboardEnhanced();
  }

  // Screen implementations using CompleteDemoScreens
  Widget _buildProjectsManagement() => CompleteDemoScreens.buildProjectsManagement(context);
  Widget _buildFundsManagement() => CompleteDemoScreens.buildFundsManagement(context);
  Widget _buildAgencyManagement() => CompleteDemoScreens.buildAgencyManagement(context);
  Widget _buildEvidenceUpload() => CompleteDemoScreens.buildEvidenceUpload(context);
  Widget _buildAnalytics() => CompleteDemoScreens.buildAnalytics(context);
  Widget _buildFeedbackSystem() => CompleteDemoScreens.buildFeedbackSystem(context);
  
  Widget _buildMyProjects() => CompleteDemoScreens.buildProjectsManagement(context);
  Widget _buildProgressTracking() => CompleteDemoScreens.buildAnalytics(context);
  Widget _buildAuditManagement() => CompleteDemoScreens.buildAnalytics(context);
  Widget _buildReports() => CompleteDemoScreens.buildAnalytics(context);

  // Helper methods for dashboard components
  Widget _buildRecentProjects() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recent Projects', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 1.2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            DashboardWidgets.buildProjectCard(context, 'Adarsh Gram Development', 'Village Rampur, UP', 'Active', Colors.green, 70.0),
            DashboardWidgets.buildProjectCard(context, 'Community Center', 'Lucknow, UP', 'In Progress', Colors.blue, 45.0),
          ],
        ),
      ],
    );
  }

  Widget _buildUpcomingDeadlines() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Upcoming Deadlines', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.schedule, color: Colors.orange),
                title: const Text('Milestone 3 - Adarsh Gram'),
                subtitle: const Text('Due in 5 days'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.schedule, color: Colors.red),
                title: const Text('Quality Inspection - Community Center'),
                subtitle: const Text('Due in 2 days'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPendingAudits() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Pending Audits', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.pending_actions, color: Colors.orange),
                title: const Text('Adarsh Gram Development - Phase 2'),
                subtitle: const Text('Assigned 3 days ago'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.pending_actions, color: Colors.orange),
                title: const Text('Hostel Construction - Quality Check'),
                subtitle: const Text('Assigned 1 week ago'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStateWiseProgress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('State-wise Progress', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildStateProgressCard('Uttar Pradesh', 387, 92),
            _buildStateProgressCard('Maharashtra', 245, 88),
            _buildStateProgressCard('Karnataka', 198, 95),
            _buildStateProgressCard('West Bengal', 156, 85),
          ],
        ),
      ],
    );
  }

  Widget _buildStateProgressCard(String state, int projects, int progress) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(state, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('$projects projects', style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: progress / 100,
                    backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
                ),
                const SizedBox(width: 8),
                Text('$progress%'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
