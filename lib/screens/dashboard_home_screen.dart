import 'package:flutter/material.dart';
import 'package:pmajay_app/models/user_role.dart';
import 'package:pmajay_app/screens/requests/requests_dashboard_screen.dart';
import 'package:pmajay_app/repositories/state_request_repository.dart';
import 'package:pmajay_app/repositories/public_request_repository.dart';
import 'package:pmajay_app/repositories/agency_request_repository.dart';
import 'package:pmajay_app/models/requests/enums.dart';
import 'package:pmajay_app/widgets/communication_hub_button.dart';
import 'package:pmajay_app/screens/demo/communication_hub_demo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardHomeScreen extends StatefulWidget {
  final User user;
  final UserRole userRole;

  const DashboardHomeScreen({
    Key? key,
    required this.user,
    required this.userRole,
  }) : super(key: key);

  @override
  State<DashboardHomeScreen> createState() => _DashboardHomeScreenState();
}

class _DashboardHomeScreenState extends State<DashboardHomeScreen> {
  final StateRequestRepository _stateRepo = StateRequestRepository();
  final PublicRequestRepository _publicRepo = PublicRequestRepository();
  final AgencyRequestRepository _agencyRepo = AgencyRequestRepository();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeHeader(),
              const SizedBox(height: 32),
              _buildRoleSpecificContent(),
              // Add demo button
              const SizedBox(height: 32),
              _buildDemoButton(),
              // Add bottom padding to avoid overlap with floating button
              const SizedBox(height: 100),
            ],
          ),
        ),
        // Communication Hub Button (only for non-public users)
        if (widget.userRole.roleType != UserRoleType.publicViewer)
          CommunicationHubButton(
            userRole: widget.userRole,
            unreadCount: _getUnreadCount(),
            hasUrgentNotifications: _hasUrgentNotifications(),
          ),
      ],
    );
  }

  Widget _buildWelcomeHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome, ${widget.user.userMetadata?['display_name'] ?? 'User'}',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.userRole.roleType.displayName,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildRoleSpecificContent() {
    switch (widget.userRole.roleType) {
      case UserRoleType.centreAdmin:
        return _buildCentreAdminDashboard();
      case UserRoleType.stateOfficer:
        return _buildStateOfficerDashboard();
      case UserRoleType.agencyUser:
        return _buildAgencyDashboard();
      default:
        return _buildDefaultDashboard();
    }
  }

  // CENTRE ADMIN DASHBOARD - Reviews State Requests
  Widget _buildCentreAdminDashboard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'State Requests Pending Review',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        FutureBuilder(
          future: _stateRepo.getStateRequests(status: RequestStatus.submitted),
          builder: (context, snapshot) {
            final pendingCount = snapshot.data?.length ?? 0;
            return _buildReviewCard(
              title: 'State Requests Awaiting Review',
              subtitle: '$pendingCount requests need your attention',
              icon: Icons.pending_actions,
              color: Colors.orange,
              count: pendingCount,
              onTap: () => _navigateToRequests(0),
            );
          },
        ),
        const SizedBox(height: 16),
        FutureBuilder(
          future: _stateRepo.getStateRequests(status: RequestStatus.underReview),
          builder: (context, snapshot) {
            final reviewCount = snapshot.data?.length ?? 0;
            return _buildReviewCard(
              title: 'State Requests Under Review',
              subtitle: '$reviewCount requests in progress',
              icon: Icons.rate_review,
              color: Colors.blue,
              count: reviewCount,
              onTap: () => _navigateToRequests(0),
            );
          },
        ),
        const SizedBox(height: 32),
        _buildQuickStats(),
      ],
    );
  }

  // STATE OFFICER DASHBOARD - Reviews Public and Agency Requests
  Widget _buildStateOfficerDashboard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Requests Requiring Your Review',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        // Public Requests Section
        FutureBuilder(
          future: _publicRepo.getPublicRequests(
            stateCode: widget.userRole.stateCode,
            status: RequestStatus.submitted,
          ),
          builder: (context, snapshot) {
            final pendingCount = snapshot.data?.length ?? 0;
            return _buildReviewCard(
              title: 'Public Requests (Citizens)',
              subtitle: '$pendingCount citizen requests pending review',
              icon: Icons.people,
              color: Colors.green,
              count: pendingCount,
              onTap: () => _navigateToRequests(1),
            );
          },
        ),
        const SizedBox(height: 16),
        
        // Agency Registration Requests Section
        FutureBuilder(
          future: _agencyRepo.getAgencyRequests(
            stateCode: widget.userRole.stateCode,
            status: RequestStatus.submitted,
          ),
          builder: (context, snapshot) {
            final pendingCount = snapshot.data?.length ?? 0;
            return _buildReviewCard(
              title: 'Agency Registration Requests',
              subtitle: '$pendingCount agency applications pending',
              icon: Icons.business,
              color: Colors.purple,
              count: pendingCount,
              onTap: () => _navigateToRequests(2),
            );
          },
        ),
        const SizedBox(height: 32),
        _buildQuickStats(),
      ],
    );
  }

  // AGENCY DASHBOARD - Shows Own Projects and Submissions
  Widget _buildAgencyDashboard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Agency Dashboard',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildReviewCard(
          title: 'Active Projects',
          subtitle: 'View and manage your ongoing projects',
          icon: Icons.assignment,
          color: Colors.blue,
          count: 0,
          onTap: () {
            Navigator.of(context).pushNamed('/projects');
          },
        ),
        const SizedBox(height: 16),
        _buildReviewCard(
          title: 'Upload Evidence',
          subtitle: 'Submit project progress and evidence',
          icon: Icons.upload_file,
          color: Colors.green,
          count: 0,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Navigate to Evidence Upload')),
            );
          },
        ),
        const SizedBox(height: 16),
        _buildReviewCard(
          title: 'Project Timeline',
          subtitle: 'Track milestones and deadlines',
          icon: Icons.timeline,
          color: Colors.orange,
          count: 0,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Navigate to Timeline')),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDefaultDashboard() {
    return Column(
      children: [
        _buildReviewCard(
          title: 'View Projects',
          subtitle: 'Browse ongoing projects',
          icon: Icons.folder,
          color: Colors.blue,
          count: 0,
          onTap: () => Navigator.of(context).pushNamed('/projects'),
        ),
      ],
    );
  }

  Widget _buildReviewCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required int count,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.1),
                color.withOpacity(0.05),
              ],
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 40,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              if (count > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    count.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              const SizedBox(width: 12),
              Icon(
                Icons.arrow_forward_ios,
                color: color,
                size: 20,
              ),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: 'Total Requests',
                value: '---',
                icon: Icons.assignment,
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                title: 'Approved',
                value: '---',
                icon: Icons.check_circle,
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                title: 'Pending',
                value: '---',
                icon: Icons.pending,
                color: Colors.orange,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],

  void _navigateToRequests(int tabIndex) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const RequestsDashboardScreen(),
      ),
    );
  }

  Widget _buildDemoButton() {
    return Card(
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.hub,
            color: Colors.blue,
          ),
        ),
        title: const Text('Communication Hub Demo'),
        subtitle: const Text('Try the new inter-level communication features'),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const CommunicationHubDemo(),
            ),
          );
        },
      ),
    );
  }

  int _getUnreadCount() {
    // Mock unread count based on user role
    switch (widget.userRole.roleType) {
      case UserRoleType.centreAdmin:
        return 12;
      case UserRoleType.stateOfficer:
        return 8;
      case UserRoleType.agencyUser:
        return 5;
      default:
        return 3;
    }
  }

  bool _hasUrgentNotifications() {
    // Mock urgent notifications based on user role
    switch (widget.userRole.roleType) {
      case UserRoleType.centreAdmin:
        return true;
      case UserRoleType.stateOfficer:
        return false;
      case UserRoleType.agencyUser:
        return false;
      default:
        return true;
    }
  }