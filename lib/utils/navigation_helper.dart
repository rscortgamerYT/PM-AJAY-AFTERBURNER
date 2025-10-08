import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class NavigationHelper {
  static void navigateToRoute(BuildContext context, String route) {
    Navigator.pushNamed(context, route);
  }

  static void navigateAndReplace(BuildContext context, String route) {
    Navigator.pushReplacementNamed(context, route);
  }

  static void navigateAndClearStack(BuildContext context, String route) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      route,
      (Route<dynamic> route) => false,
    );
  }

  static void showFeatureComingSoon(BuildContext context, String featureName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.construction,
              color: Colors.orange,
            ),
            const SizedBox(width: 8),
            Text('Coming Soon'),
          ],
        ),
        content: Text(
          '$featureName is currently under development and will be available in the next update.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  static void showSuccessMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void showInfoMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.info, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Centre Admin Navigation
  static void navigateToCentreRequests(BuildContext context) {
    navigateToRoute(context, AppRoutes.centreRequests);
  }

  static void navigateToCentreFunds(BuildContext context) {
    navigateToRoute(context, AppRoutes.centreFunds);
  }

  static void navigateToCentreProjects(BuildContext context) {
    navigateToRoute(context, AppRoutes.centreProjects);
  }

  static void navigateToCentreAlerts(BuildContext context) {
    navigateToRoute(context, AppRoutes.centreAlerts);
  }

  static void navigateToCentreAnalytics(BuildContext context) {
    navigateToRoute(context, AppRoutes.centreAnalytics);
  }

  static void navigateToCentreReports(BuildContext context) {
    navigateToRoute(context, AppRoutes.centreReports);
  }

  // State Officer Navigation
  static void navigateToStatePublicRequests(BuildContext context) {
    navigateToRoute(context, AppRoutes.stateRequestsPublic);
  }

  static void navigateToStateAgencyRequests(BuildContext context) {
    navigateToRoute(context, AppRoutes.stateRequestsAgency);
  }

  static void navigateToStateProjectAllocation(BuildContext context) {
    navigateToRoute(context, AppRoutes.stateProjectsAllocate);
  }

  static void navigateToStateFundRelease(BuildContext context) {
    navigateToRoute(context, AppRoutes.stateFundsRelease);
  }

  static void navigateToStateAgencies(BuildContext context) {
    navigateToRoute(context, AppRoutes.stateAgencies);
  }

  static void navigateToStateCompliance(BuildContext context) {
    navigateToRoute(context, AppRoutes.stateCompliance);
  }

  static void navigateToStateFunds(BuildContext context) {
    navigateToRoute(context, AppRoutes.stateFunds);
  }

  static void navigateToStateNotifications(BuildContext context) {
    navigateToRoute(context, AppRoutes.stateNotifications);
  }

  // Agency User Navigation
  static void navigateToAgencyWorkOrders(BuildContext context) {
    navigateToRoute(context, AppRoutes.agencyWorkorders);
  }

  static void navigateToAgencyProjects(BuildContext context) {
    navigateToRoute(context, AppRoutes.agencyProjects);
  }

  static void navigateToAgencyProgressSubmission(BuildContext context) {
    navigateToRoute(context, AppRoutes.agencyProjectsProgress);
  }

  static void navigateToAgencyCapabilities(BuildContext context) {
    navigateToRoute(context, AppRoutes.agencyCapabilities);
  }

  static void navigateToAgencyRegistration(BuildContext context) {
    navigateToRoute(context, AppRoutes.agencyRegistration);
  }

  static void navigateToAgencyFunds(BuildContext context) {
    navigateToRoute(context, AppRoutes.agencyFunds);
  }

  static void navigateToAgencyProfile(BuildContext context) {
    navigateToRoute(context, AppRoutes.agencyProfile);
  }

  // Auditor Navigation
  static void navigateToAuditorFundLedger(BuildContext context) {
    navigateToRoute(context, AppRoutes.auditorFundLedger);
  }

  static void navigateToAuditorEvidence(BuildContext context) {
    navigateToRoute(context, AppRoutes.auditorEvidence);
  }

  static void navigateToAuditorCompliance(BuildContext context) {
    navigateToRoute(context, AppRoutes.auditorCompliance);
  }

  static void navigateToAuditorReports(BuildContext context) {
    navigateToRoute(context, AppRoutes.auditorReports);
  }

  static void navigateToAuditorFlags(BuildContext context) {
    navigateToRoute(context, AppRoutes.auditorFlags);
  }

  static void navigateToAuditorQueue(BuildContext context) {
    navigateToRoute(context, AppRoutes.auditorQueue);
  }

  // Public Portal Navigation
  static void navigateToPublicMap(BuildContext context) {
    navigateToRoute(context, AppRoutes.publicMap);
  }

  static void navigateToPublicProjects(BuildContext context) {
    navigateToRoute(context, AppRoutes.publicProjects);
  }

  static void navigateToPublicStories(BuildContext context) {
    navigateToRoute(context, AppRoutes.publicStories);
  }

  static void navigateToPublicRequest(BuildContext context) {
    navigateToRoute(context, AppRoutes.publicRequest);
  }

  static void navigateToPublicTrack(BuildContext context) {
    navigateToRoute(context, AppRoutes.publicTrack);
  }

  static void navigateToPublicForum(BuildContext context) {
    navigateToRoute(context, AppRoutes.publicForum);
  }

  // Communication Hub Navigation
  static void navigateToHub(BuildContext context) {
    navigateToRoute(context, AppRoutes.hub);
  }

  static void navigateToHubMessages(BuildContext context) {
    navigateToRoute(context, AppRoutes.hubMessages);
  }

  static void navigateToHubTickets(BuildContext context) {
    navigateToRoute(context, AppRoutes.hubTickets);
  }

  static void navigateToHubDocuments(BuildContext context) {
    navigateToRoute(context, AppRoutes.hubDocuments);
  }

  static void navigateToHubMeetings(BuildContext context) {
    navigateToRoute(context, AppRoutes.hubMeetings);
  }

  static void navigateToHubNotifications(BuildContext context) {
    navigateToRoute(context, AppRoutes.hubNotifications);
  }

  // Review Panel Navigation
  static void navigateToReviewPanel(BuildContext context) {
    navigateToRoute(context, AppRoutes.review);
  }

  // Demo Navigation
  static void navigateToDemo(BuildContext context) {
    navigateToRoute(context, AppRoutes.demo);
  }
}
