import 'package:flutter/material.dart';
import '../models/user_role.dart';

class NavigationDestination {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final String route;

  const NavigationDestination({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.route,
  });
}

List<NavigationDestination> getNavigationDestinations(UserRoleType roleType) {
  final baseDestinations = [
    const NavigationDestination(
      icon: Icons.dashboard_outlined,
      selectedIcon: Icons.dashboard,
      label: 'Dashboard',
      route: '/dashboard',
    ),
    const NavigationDestination(
      icon: Icons.folder_outlined,
      selectedIcon: Icons.folder,
      label: 'Projects',
      route: '/projects',
    ),
  ];

  switch (roleType) {
    case UserRoleType.centreAdmin:
      return [
        ...baseDestinations,
        const NavigationDestination(
          icon: Icons.article_outlined,
          selectedIcon: Icons.article,
          label: 'Requests',
          route: '/requests',
        ),
        const NavigationDestination(
          icon: Icons.gavel_outlined,
          selectedIcon: Icons.gavel,
          label: 'Review Panel',
          route: '/review',
        ),
        const NavigationDestination(
          icon: Icons.account_balance_outlined,
          selectedIcon: Icons.account_balance,
          label: 'Funds',
          route: '/funds',
        ),
        const NavigationDestination(
          icon: Icons.location_city_outlined,
          selectedIcon: Icons.location_city,
          label: 'States',
          route: '/states',
        ),
        const NavigationDestination(
          icon: Icons.analytics_outlined,
          selectedIcon: Icons.analytics,
          label: 'Analytics',
          route: '/analytics',
        ),
        const NavigationDestination(
          icon: Icons.person_outlined,
          selectedIcon: Icons.person,
          label: 'Profile',
          route: '/profile',
        ),
      ];

    case UserRoleType.stateOfficer:
      return [
        ...baseDestinations,
        const NavigationDestination(
          icon: Icons.article_outlined,
          selectedIcon: Icons.article,
          label: 'Requests',
          route: '/requests',
        ),
        const NavigationDestination(
          icon: Icons.gavel_outlined,
          selectedIcon: Icons.gavel,
          label: 'Review Panel',
          route: '/review',
        ),
        const NavigationDestination(
          icon: Icons.account_balance_outlined,
          selectedIcon: Icons.account_balance,
          label: 'Funds',
          route: '/funds',
        ),
        const NavigationDestination(
          icon: Icons.business_outlined,
          selectedIcon: Icons.business,
          route: '/agencies',
        ),
        const NavigationDestination(
          icon: Icons.analytics_outlined,
          selectedIcon: Icons.analytics,
          label: 'Analytics',
          route: '/analytics',
        ),
      ];

    case UserRoleType.agencyUser:
      return [
        ...baseDestinations,
        const NavigationDestination(
          icon: Icons.upload_outlined,
          selectedIcon: Icons.upload,
          label: 'Evidence',
          route: '/evidence',
        ),
        const NavigationDestination(
          icon: Icons.gavel_outlined,
          selectedIcon: Icons.gavel,
          label: 'Review Panel',
          route: '/review',
        ),
        const NavigationDestination(
          icon: Icons.timeline_outlined,
          selectedIcon: Icons.timeline,
          label: 'Progress',
          route: '/progress',
        ),
        const NavigationDestination(
          icon: Icons.person_outlined,
          selectedIcon: Icons.person,
          label: 'Profile',
          route: '/profile',
        ),
      ];

    case UserRoleType.auditor:
      return [
        ...baseDestinations,
        const NavigationDestination(
          icon: Icons.verified_outlined,
          selectedIcon: Icons.verified,
          label: 'Audits',
          route: '/audits',
        ),
        const NavigationDestination(
          icon: Icons.analytics_outlined,
          selectedIcon: Icons.analytics,
          label: 'Reports',
          route: '/analytics',
        ),
        const NavigationDestination(
          icon: Icons.person_outlined,
          selectedIcon: Icons.person,
          label: 'Profile',
          route: '/profile',
        ),
      ];

    case UserRoleType.publicViewer:
      return [
        const NavigationDestination(
          icon: Icons.public_outlined,
          selectedIcon: Icons.public,
          label: 'Public Dashboard',
          route: '/public',
        ),
        const NavigationDestination(
          icon: Icons.feedback_outlined,
          selectedIcon: Icons.feedback,
          label: 'Feedback',
          route: '/feedback',
        ),
      ];
  }
}
