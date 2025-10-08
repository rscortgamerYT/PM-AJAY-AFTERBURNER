import 'package:flutter/material.dart';
import '../screens/auth_gate.dart';
import '../screens/dashboard_screen.dart';
import '../screens/centre/centre_dashboard_home.dart';
import '../screens/state/state_dashboard_home.dart';
import '../screens/agency/agency_dashboard_home.dart';
import '../screens/auditor/auditor_dashboard_home.dart';
import '../screens/public/public_portal_home.dart';
import '../screens/hub/communication_hub_screen.dart';
import '../screens/hub/messaging/messaging_screen.dart';
import '../screens/hub/tickets/tickets_screen.dart';
import '../screens/hub/documents/documents_screen.dart';
import '../screens/hub/meetings/meetings_screen.dart';
import '../screens/hub/notifications/notifications_screen.dart';
import '../screens/review/centre_review_panel.dart';
import '../screens/demo/communication_hub_demo.dart';
import '../models/user_role.dart';

class AppRoutes {
  static const String auth = '/';
  static const String dashboard = '/dashboard';
  
  // Centre Admin Routes
  static const String centreHome = '/centre/dashboard';
  static const String centreRequests = '/centre/requests';
  static const String centreAgencies = '/centre/agencies';
  static const String centreAlerts = '/centre/alerts';
  static const String centreAnalytics = '/centre/analytics';
  static const String centreReports = '/centre/reports';
  static const String centreFunds = '/centre/funds';
  static const String centreProjects = '/centre/projects';
  static const String centreSettings = '/centre/settings';
  
  // State Officer Routes
  static const String stateHome = '/state/dashboard';
  static const String stateRequestsPublic = '/state/requests/public';
  static const String stateRequestsAgency = '/state/requests/agency';
  static const String stateProjectsAllocate = '/state/projects/allocate';
  static const String stateFundsRelease = '/state/funds/release';
  static const String stateAgencies = '/state/agencies';
  static const String stateCompliance = '/state/compliance';
  static const String stateNotifications = '/state/notifications';
  static const String stateFunds = '/state/funds';
  static const String stateSettings = '/state/settings';
  
  // Agency User Routes
  static const String agencyHome = '/agency/dashboard';
  static const String agencyWorkorders = '/agency/workorders';
  static const String agencyProjects = '/agency/projects';
  static const String agencyProjectsProgress = '/agency/projects/progress';
  static const String agencyCapabilities = '/agency/capabilities';
  static const String agencyRegistration = '/agency/registration';
  static const String agencyFunds = '/agency/funds';
  static const String agencyProfile = '/agency/profile';
  
  // Auditor Routes
  static const String auditorHome = '/auditor/dashboard';
  static const String auditorFundLedger = '/auditor/fund-ledger';
  static const String auditorEvidence = '/auditor/evidence';
  static const String auditorCompliance = '/auditor/compliance';
  static const String auditorReports = '/auditor/reports';
  static const String auditorFlags = '/auditor/flags';
  static const String auditorQueue = '/auditor/queue';
  
  // Public Portal Routes
  static const String publicHome = '/public';
  static const String publicMap = '/public/map';
  static const String publicProjects = '/public/projects';
  static const String publicStories = '/public/stories';
  static const String publicRequest = '/public/request';
  static const String publicTrack = '/public/track';
  static const String publicForum = '/public/forum';
  
  // Communication Hub Routes
  static const String hub = '/hub';
  static const String hubMessages = '/hub/messages';
  static const String hubTickets = '/hub/tickets';
  static const String hubDocuments = '/hub/documents';
  static const String hubMeetings = '/hub/meetings';
  static const String hubNotifications = '/hub/notifications';
  
  // Review Panel Routes
  static const String review = '/review';
  
  // Demo Routes
  static const String demo = '/demo';

  static Map<String, WidgetBuilder> getRoutes(UserRole? userRole) {
    return {
      auth: (context) => const AuthGate(),
      dashboard: (context) => DashboardScreen(
        user: userRole!.user,
        userRole: userRole,
      ),
      
      // Centre Admin Routes
      centreHome: (context) => CentreDashboardHome(userRole: userRole!),
      centreRequests: (context) => _buildPlaceholder('Centre Requests', 'State request management with approval workflow'),
      centreAgencies: (context) => _buildPlaceholder('Centre Agencies', 'Agency onboarding and verification'),
      centreAlerts: (context) => _buildPlaceholder('Centre Alerts', 'Critical alerts and escalations management'),
      centreAnalytics: (context) => _buildPlaceholder('Centre Analytics', 'Performance analytics and reports'),
      centreReports: (context) => _buildPlaceholder('Centre Reports', 'Generate and download reports'),
      centreFunds: (context) => _buildPlaceholder('Centre Funds', 'Fund allocation and disbursement'),
      centreProjects: (context) => _buildPlaceholder('Centre Projects', 'Nationwide project overview'),
      centreSettings: (context) => _buildPlaceholder('Centre Settings', 'System configuration and user management'),
      
      // State Officer Routes
      stateHome: (context) => StateDashboardHome(userRole: userRole!),
      stateRequestsPublic: (context) => _buildPlaceholder('Public Requests', 'Review and approve citizen requests'),
      stateRequestsAgency: (context) => _buildPlaceholder('Agency Requests', 'Agency registration and verification'),
      stateProjectsAllocate: (context) => _buildPlaceholder('Project Allocation', 'Assign projects to agencies'),
      stateFundsRelease: (context) => _buildPlaceholder('Fund Release', 'Release funds to agencies'),
      stateAgencies: (context) => _buildPlaceholder('State Agencies', 'Manage registered agencies'),
      stateCompliance: (context) => _buildPlaceholder('State Compliance', 'Compliance monitoring and reports'),
      stateNotifications: (context) => _buildPlaceholder('State Notifications', 'All notifications and alerts'),
      stateFunds: (context) => _buildPlaceholder('State Funds', 'Fund management and tracking'),
      stateSettings: (context) => _buildPlaceholder('State Settings', 'State-level configuration'),
      
      // Agency User Routes
      agencyHome: (context) => AgencyDashboardHome(userRole: userRole!),
      agencyWorkorders: (context) => _buildPlaceholder('Work Orders', 'Accept and manage work assignments'),
      agencyProjects: (context) => _buildPlaceholder('Agency Projects', 'Active project management'),
      agencyProjectsProgress: (context) => _buildPlaceholder('Progress Submission', 'Submit project progress and evidence'),
      agencyCapabilities: (context) => _buildPlaceholder('Capabilities Manager', 'Manage service area and expertise'),
      agencyRegistration: (context) => _buildPlaceholder('Registration Status', 'Track registration progress'),
      agencyFunds: (context) => _buildPlaceholder('Agency Funds', 'Fund utilization tracking'),
      agencyProfile: (context) => _buildPlaceholder('Agency Profile', 'Profile and credentials management'),
      
      // Auditor Routes
      auditorHome: (context) => AuditorDashboardHome(userRole: userRole!),
      auditorFundLedger: (context) => _buildPlaceholder('Fund Transfer Ledger', 'Review and audit fund transfers'),
      auditorEvidence: (context) => _buildPlaceholder('Evidence Audit', 'Review project evidence and documentation'),
      auditorCompliance: (context) => _buildPlaceholder('Compliance Checks', 'Compliance verification and flagging'),
      auditorReports: (context) => _buildPlaceholder('Audit Reports', 'Generate audit reports'),
      auditorFlags: (context) => _buildPlaceholder('Flagged Items', 'Manage flagged issues and resolutions'),
      auditorQueue: (context) => _buildPlaceholder('Audit Queue', 'Priority audit queue management'),
      
      // Public Portal Routes
      publicHome: (context) => const PublicPortalHome(),
      publicMap: (context) => _buildPlaceholder('Public Map', 'Interactive project map'),
      publicProjects: (context) => _buildPlaceholder('Public Projects', 'Browse all public projects'),
      publicStories: (context) => _buildPlaceholder('Success Stories', 'Community success stories'),
      publicRequest: (context) => _buildPlaceholder('Submit Request', 'Submit new public request'),
      publicTrack: (context) => _buildPlaceholder('Track Request', 'Track request status'),
      publicForum: (context) => _buildPlaceholder('Public Forum', 'Community discussions'),
      
      // Communication Hub Routes
      hub: (context) => CommunicationHubScreen(userRole: userRole!),
      hubMessages: (context) => MessagingScreen(userRole: userRole!),
      hubTickets: (context) => TicketsScreen(userRole: userRole!),
      hubDocuments: (context) => DocumentsScreen(userRole: userRole!),
      hubMeetings: (context) => MeetingsScreen(userRole: userRole!),
      hubNotifications: (context) => NotificationsScreen(userRole: userRole!),
      
      // Review Panel Routes
      review: (context) => _getReviewPanel(userRole!),
      
      // Demo Routes
      demo: (context) => const CommunicationHubDemo(),
    };
  }

  static Widget _buildPlaceholder(String title, String description) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFF3F51B5),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.construction,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 24),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                description,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {
                  // Show coming soon message
                },
                icon: const Icon(Icons.info),
                label: const Text('Coming Soon'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3F51B5),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _getReviewPanel(UserRole userRole) {
    switch (userRole.roleType) {
      case UserRoleType.centreAdmin:
        return CentreReviewPanel(userRole: userRole);
      case UserRoleType.stateOfficer:
        return _buildPlaceholder(
          'State Review Panel',
          'Agency onboarding and management workflow',
        );
      case UserRoleType.agencyUser:
        return _buildPlaceholder(
          'Agency Review Panel',
          'Registration and project management workflow',
        );
      default:
        return _buildPlaceholder(
          'Review Panel',
          'Review panel not available for this role',
        );
    }
  }
}
