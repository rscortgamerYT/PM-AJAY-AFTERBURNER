import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_role.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../widgets/responsive_layout.dart';
import '../widgets/navigation_destinations.dart' as nav;
import 'dashboard_home_screen.dart';
import 'projects/projects_screen.dart';
import 'requests/requests_dashboard_screen.dart';
import 'funds/funds_screen.dart';
import 'states/states_screen.dart';
import 'agencies/agencies_screen.dart';
import 'analytics/analytics_screen.dart';
import 'profile/profile_screen.dart';
import 'demo/communication_hub_demo.dart';
import 'hub/communication_hub_screen.dart';
import 'review/centre_review_panel.dart';
import 'centre/centre_dashboard_home.dart';
import 'state/state_dashboard_home.dart';
import 'agency/agency_dashboard_home.dart';
import 'auditor/auditor_dashboard_home.dart';
import 'public/public_portal_home.dart';

class DashboardScreen extends StatefulWidget {
  final User user;
  final UserRole userRole;

  const DashboardScreen({
    super.key,
    required this.user,
    required this.userRole,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  List<nav.NavigationDestination> get _destinations {
    return nav.getNavigationDestinations(widget.userRole.roleType);
  }

  Widget _getSelectedScreen() {
    final destination = _destinations[_selectedIndex];
    
    switch (destination.route) {
      case '/dashboard':
        return DashboardHomeScreen(user: widget.user, userRole: widget.userRole);
      case '/projects':
        return const ProjectsScreen();
      case '/requests':
        return const RequestsDashboardScreen();
      case '/funds':
        return const FundsScreen();
      case '/states':
        return const StatesScreen();
      case '/agencies':
        return const AgenciesScreen();
      case '/analytics':
        return const AnalyticsScreen();
      case '/profile':
        return ProfileScreen(user: widget.user, userRole: widget.userRole);
      case '/hub':
        return CommunicationHubScreen(userRole: widget.userRole);
      case '/demo':
        return const CommunicationHubDemo();
      case '/review':
        return _getReviewPanel();
      default:
        return _getRoleSpecificHome();
    }
  }

  Widget _getReviewPanel() {
    switch (widget.userRole.roleType) {
      case UserRoleType.centreAdmin:
        return CentreReviewPanel(userRole: widget.userRole);
      case UserRoleType.stateOfficer:
        // TODO: Implement StateReviewPanel
        return Container(
          padding: const EdgeInsets.all(24),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.construction, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'State Review Panel',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text('Coming Soon - Agency Onboarding & Management'),
              ],
            ),
          ),
        );
      case UserRoleType.agencyUser:
        // TODO: Implement AgencyReviewPanel
        return Container(
          padding: const EdgeInsets.all(24),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.construction, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Agency Review Panel',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text('Coming Soon - Registration & Project Management'),
              ],
            ),
          ),
        );
      default:
        return Container(
          padding: const EdgeInsets.all(24),
          child: const Center(
            child: Text('Review Panel not available for this role'),
          ),
        );
    }
  }

  Widget _getRoleSpecificHome() {
    switch (widget.userRole.roleType) {
      case UserRoleType.centreAdmin:
        return CentreDashboardHome(userRole: widget.userRole);
      case UserRoleType.stateOfficer:
        return StateDashboardHome(userRole: widget.userRole);
      case UserRoleType.agencyUser:
        return AgencyDashboardHome(userRole: widget.userRole);
      case UserRoleType.auditor:
        return AuditorDashboardHome(userRole: widget.userRole);
      case UserRoleType.publicUser:
        return const PublicPortalHome();
      default:
        return DashboardHomeScreen(user: widget.user, userRole: widget.userRole);
    }
  }

  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _signOut() {
    context.read<AuthBloc>().add(AuthSignOutRequested());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return ResponsiveLayout(
      mobileBody: _buildMobileLayout(),
      tabletBody: _buildTabletLayout(),
      desktopBody: _buildDesktopLayout(),
    );
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      appBar: AppBar(
        title: Text(_destinations[_selectedIndex].label),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'signout') {
                _signOut();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'profile',
                child: ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(widget.user.userMetadata?['display_name'] ?? 'User'),
                  subtitle: Text(widget.userRole.roleType.displayName),
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'signout',
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Sign Out'),
                ),
              ),
            ],
          ),
        ],
      ),
      body: _getSelectedScreen(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onDestinationSelected,
        destinations: _destinations
            .map((dest) => NavigationDestination(
                  icon: Icon(dest.icon),
                  selectedIcon: Icon(dest.selectedIcon),
                  label: dest.label,
                ))
            .toList(),
      ),
    );
  }

  Widget _buildTabletLayout() {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onDestinationSelected,
            extended: true,
            destinations: _destinations
                .map((dest) => NavigationRailDestination(
                      icon: Icon(dest.icon),
                      selectedIcon: Icon(dest.selectedIcon),
                      label: Text(dest.label),
                    ))
                .toList(),
            trailing: Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        child: Text(
                          (widget.user.userMetadata?['display_name'] ?? 'U')[0]
                              .toUpperCase(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.user.userMetadata?['display_name'] ?? 'User',
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                      TextButton(
                        onPressed: _signOut,
                        child: const Text('Sign Out'),
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
                  title: Text(_destinations[_selectedIndex].label),
                  automaticallyImplyLeading: false,
                ),
                Expanded(child: _getSelectedScreen()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return _buildTabletLayout(); // Same layout for desktop
  }
}
