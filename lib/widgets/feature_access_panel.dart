import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../models/user_role.dart';
import '../utils/navigation_helper.dart';

class FeatureAccessPanel extends StatelessWidget {
  final UserRole userRole;

  const FeatureAccessPanel({
    super.key,
    required this.userRole,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Symbols.dashboard,
                  color: _getRoleColor(),
                ),
                const SizedBox(width: 8),
                Text(
                  'Quick Access - ${_getRoleName()}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildFeatureGrid(context),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureGrid(BuildContext context) {
    final features = _getRoleFeatures();
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        final feature = features[index];
        return _buildFeatureCard(context, feature);
      },
    );
  }

  Widget _buildFeatureCard(BuildContext context, FeatureItem feature) {
    return Card(
      elevation: 1,
      child: InkWell(
        onTap: () => feature.onTap(context),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: feature.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  feature.icon,
                  size: 24,
                  color: feature.color,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                feature.title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (feature.badge != null) ...[
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    feature.badge!,
                    style: const TextStyle(
                      fontSize: 8,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  List<FeatureItem> _getRoleFeatures() {
    switch (userRole.roleType) {
      case UserRoleType.centreAdmin:
        return [
          FeatureItem(
            title: 'State Requests',
            icon: Symbols.gavel,
            color: Colors.orange,
            badge: '12',
            onTap: NavigationHelper.navigateToCentreRequests,
          ),
          FeatureItem(
            title: 'Fund Management',
            icon: Symbols.account_balance,
            color: Colors.green,
            onTap: NavigationHelper.navigateToCentreFunds,
          ),
          FeatureItem(
            title: 'Analytics',
            icon: Symbols.analytics,
            color: Colors.blue,
            onTap: NavigationHelper.navigateToCentreAnalytics,
          ),
          FeatureItem(
            title: 'Critical Alerts',
            icon: Symbols.warning,
            color: Colors.red,
            badge: '3',
            onTap: NavigationHelper.navigateToCentreAlerts,
          ),
          FeatureItem(
            title: 'Agency Onboarding',
            icon: Symbols.business,
            color: Colors.purple,
            onTap: NavigationHelper.navigateToCentreAgencies,
          ),
          FeatureItem(
            title: 'Reports',
            icon: Symbols.description,
            color: Colors.indigo,
            onTap: NavigationHelper.navigateToCentreReports,
          ),
          FeatureItem(
            title: 'Review Panel',
            icon: Symbols.fact_check,
            color: Colors.teal,
            onTap: NavigationHelper.navigateToReviewPanel,
          ),
          FeatureItem(
            title: 'Communication Hub',
            icon: Symbols.forum,
            color: Colors.deepOrange,
            badge: '8',
            onTap: NavigationHelper.navigateToHub,
          ),
        ];

      case UserRoleType.stateOfficer:
        return [
          FeatureItem(
            title: 'Public Requests',
            icon: Symbols.people,
            color: Colors.green,
            badge: '24',
            onTap: NavigationHelper.navigateToStatePublicRequests,
          ),
          FeatureItem(
            title: 'Agency Registration',
            icon: Symbols.business,
            color: Colors.blue,
            badge: '5',
            onTap: NavigationHelper.navigateToStateAgencyRequests,
          ),
          FeatureItem(
            title: 'Project Allocation',
            icon: Symbols.assignment,
            color: Colors.orange,
            onTap: NavigationHelper.navigateToStateProjectAllocation,
          ),
          FeatureItem(
            title: 'Fund Release',
            icon: Symbols.payments,
            color: Colors.purple,
            onTap: NavigationHelper.navigateToStateFundRelease,
          ),
          FeatureItem(
            title: 'Agencies',
            icon: Symbols.domain,
            color: Colors.indigo,
            onTap: NavigationHelper.navigateToStateAgencies,
          ),
          FeatureItem(
            title: 'Compliance',
            icon: Symbols.verified,
            color: Colors.teal,
            onTap: NavigationHelper.navigateToStateCompliance,
          ),
          FeatureItem(
            title: 'Review Panel',
            icon: Symbols.fact_check,
            color: Colors.deepPurple,
            onTap: NavigationHelper.navigateToReviewPanel,
          ),
          FeatureItem(
            title: 'Communication Hub',
            icon: Symbols.forum,
            color: Colors.deepOrange,
            badge: '6',
            onTap: NavigationHelper.navigateToHub,
          ),
        ];

      case UserRoleType.agencyUser:
        return [
          FeatureItem(
            title: 'Work Orders',
            icon: Symbols.assignment,
            color: Colors.blue,
            badge: '3',
            onTap: NavigationHelper.navigateToAgencyWorkOrders,
          ),
          FeatureItem(
            title: 'Active Projects',
            icon: Symbols.work,
            color: Colors.green,
            onTap: NavigationHelper.navigateToAgencyProjects,
          ),
          FeatureItem(
            title: 'Submit Progress',
            icon: Symbols.upload,
            color: Colors.orange,
            onTap: NavigationHelper.navigateToAgencyProgressSubmission,
          ),
          FeatureItem(
            title: 'Capabilities',
            icon: Symbols.settings,
            color: Colors.purple,
            onTap: NavigationHelper.navigateToAgencyCapabilities,
          ),
          FeatureItem(
            title: 'Registration',
            icon: Symbols.verified,
            color: Colors.indigo,
            onTap: NavigationHelper.navigateToAgencyRegistration,
          ),
          FeatureItem(
            title: 'Fund Tracking',
            icon: Symbols.account_balance_wallet,
            color: Colors.teal,
            onTap: NavigationHelper.navigateToAgencyFunds,
          ),
          FeatureItem(
            title: 'Review Panel',
            icon: Symbols.fact_check,
            color: Colors.deepPurple,
            onTap: NavigationHelper.navigateToReviewPanel,
          ),
          FeatureItem(
            title: 'Communication Hub',
            icon: Symbols.forum,
            color: Colors.deepOrange,
            badge: '4',
            onTap: NavigationHelper.navigateToHub,
          ),
        ];

      case UserRoleType.auditor:
        return [
          FeatureItem(
            title: 'Fund Ledger',
            icon: Symbols.account_balance,
            color: Colors.blue,
            badge: '15',
            onTap: NavigationHelper.navigateToAuditorFundLedger,
          ),
          FeatureItem(
            title: 'Evidence Audit',
            icon: Symbols.fact_check,
            color: Colors.green,
            badge: '8',
            onTap: NavigationHelper.navigateToAuditorEvidence,
          ),
          FeatureItem(
            title: 'Compliance',
            icon: Symbols.verified,
            color: Colors.orange,
            badge: '12',
            onTap: NavigationHelper.navigateToAuditorCompliance,
          ),
          FeatureItem(
            title: 'Flagged Items',
            icon: Symbols.flag,
            color: Colors.red,
            badge: '6',
            onTap: NavigationHelper.navigateToAuditorFlags,
          ),
          FeatureItem(
            title: 'Audit Queue',
            icon: Symbols.queue,
            color: Colors.purple,
            onTap: NavigationHelper.navigateToAuditorQueue,
          ),
          FeatureItem(
            title: 'Reports',
            icon: Symbols.analytics,
            color: Colors.indigo,
            onTap: NavigationHelper.navigateToAuditorReports,
          ),
          FeatureItem(
            title: 'Communication Hub',
            icon: Symbols.forum,
            color: Colors.deepOrange,
            badge: '2',
            onTap: NavigationHelper.navigateToHub,
          ),
        ];

      case UserRoleType.publicUser:
        return [
          FeatureItem(
            title: 'Interactive Map',
            icon: Symbols.map,
            color: Colors.green,
            onTap: NavigationHelper.navigateToPublicMap,
          ),
          FeatureItem(
            title: 'All Projects',
            icon: Symbols.work,
            color: Colors.blue,
            onTap: NavigationHelper.navigateToPublicProjects,
          ),
          FeatureItem(
            title: 'Success Stories',
            icon: Symbols.star,
            color: Colors.orange,
            onTap: NavigationHelper.navigateToPublicStories,
          ),
          FeatureItem(
            title: 'Submit Request',
            icon: Symbols.add_circle,
            color: Colors.purple,
            onTap: NavigationHelper.navigateToPublicRequest,
          ),
          FeatureItem(
            title: 'Track Request',
            icon: Symbols.track_changes,
            color: Colors.indigo,
            onTap: NavigationHelper.navigateToPublicTrack,
          ),
          FeatureItem(
            title: 'Public Forum',
            icon: Symbols.forum,
            color: Colors.teal,
            onTap: NavigationHelper.navigateToPublicForum,
          ),
        ];

      default:
        return [];
    }
  }

  Color _getRoleColor() {
    switch (userRole.roleType) {
      case UserRoleType.centreAdmin:
        return const Color(0xFF3F51B5);
      case UserRoleType.stateOfficer:
        return const Color(0xFF1976D2);
      case UserRoleType.agencyUser:
        return const Color(0xFF26A69A);
      case UserRoleType.auditor:
        return const Color(0xFF7B1FA2);
      case UserRoleType.publicUser:
        return const Color(0xFF388E3C);
      default:
        return Colors.grey;
    }
  }

  String _getRoleName() {
    switch (userRole.roleType) {
      case UserRoleType.centreAdmin:
        return 'Centre Admin';
      case UserRoleType.stateOfficer:
        return 'State Officer';
      case UserRoleType.agencyUser:
        return 'Agency User';
      case UserRoleType.auditor:
        return 'Auditor';
      case UserRoleType.publicUser:
        return 'Public User';
      default:
        return 'User';
    }
  }
}

class FeatureItem {
  final String title;
  final IconData icon;
  final Color color;
  final String? badge;
  final Function(BuildContext) onTap;

  const FeatureItem({
    required this.title,
    required this.icon,
    required this.color,
    this.badge,
    required this.onTap,
  });
}
