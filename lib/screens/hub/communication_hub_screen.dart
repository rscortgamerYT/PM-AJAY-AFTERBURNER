import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../models/user_role.dart';
import '../../models/hub/chat_message.dart';
import '../../models/hub/ticket.dart';
import '../../models/hub/notification.dart';
import '../../models/hub/document.dart';
import '../../models/hub/meeting.dart';
import 'messaging/messaging_screen.dart';
import 'tickets/tickets_screen.dart';
import 'documents/documents_screen.dart';
import 'meetings/meetings_screen.dart';
import 'notifications/notifications_screen.dart';

class CommunicationHubScreen extends StatefulWidget {
  final UserRole userRole;
  final String? initialSection;

  const CommunicationHubScreen({
    super.key,
    required this.userRole,
    this.initialSection,
  });

  @override
  State<CommunicationHubScreen> createState() => _CommunicationHubScreenState();
}

class _CommunicationHubScreenState extends State<CommunicationHubScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  final List<HubTab> _tabs = [
    HubTab(
      icon: Symbols.chat,
      label: 'Messages',
      badge: 5,
    ),
    HubTab(
      icon: Symbols.support_agent,
      label: 'Tickets',
      badge: 3,
    ),
    HubTab(
      icon: Symbols.folder,
      label: 'Documents',
      badge: 0,
    ),
    HubTab(
      icon: Symbols.event,
      label: 'Meetings',
      badge: 2,
    ),
    HubTab(
      icon: Symbols.notifications,
      label: 'Notifications',
      badge: 8,
    ),
  ];

  @override
  void initState() {
    super.initState();
    
    // Set initial index based on initialSection
    int initialIndex = 0;
    if (widget.initialSection != null) {
      switch (widget.initialSection) {
        case 'messages':
          initialIndex = 0;
          break;
        case 'tickets':
          initialIndex = 1;
          break;
        case 'documents':
          initialIndex = 2;
          break;
        case 'meetings':
          initialIndex = 3;
          break;
        case 'notifications':
          initialIndex = 4;
          break;
      }
    }
    
    _selectedIndex = initialIndex;
    _tabController = TabController(
      length: _tabs.length, 
      vsync: this,
      initialIndex: initialIndex,
    );
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Symbols.hub,
                color: Theme.of(context).primaryColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Communication Hub',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _getRoleDisplayName(widget.userRole),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              indicatorColor: Theme.of(context).primaryColor,
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.grey[600],
              tabs: _tabs.map((tab) => _buildTab(tab)).toList(),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Symbols.search),
            onPressed: () => _showGlobalSearch(),
          ),
          IconButton(
            icon: const Icon(Symbols.settings),
            onPressed: () => _showHubSettings(),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          MessagingScreen(userRole: widget.userRole),
          TicketsScreen(userRole: widget.userRole),
          DocumentsScreen(userRole: widget.userRole),
          MeetingsScreen(userRole: widget.userRole),
          NotificationsScreen(userRole: widget.userRole),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildTab(HubTab tab) {
    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(tab.icon, size: 20),
          const SizedBox(width: 8),
          Text(tab.label),
          if (tab.badge > 0) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                tab.badge.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget? _buildFloatingActionButton() {
    switch (_selectedIndex) {
      case 0: // Messages
        return FloatingActionButton(
          onPressed: () => _startNewConversation(),
          child: const Icon(Symbols.add_comment),
        );
      case 1: // Tickets
        return FloatingActionButton(
          onPressed: () => _createNewTicket(),
          child: const Icon(Symbols.confirmation_number),
        );
      case 2: // Documents
        return FloatingActionButton(
          onPressed: () => _uploadDocument(),
          child: const Icon(Symbols.upload_file),
        );
      case 3: // Meetings
        return FloatingActionButton(
          onPressed: () => _scheduleMeeting(),
          child: const Icon(Symbols.event_available),
        );
      default:
        return null;
    }
  }

  String _getRoleDisplayName(UserRole role) {
    switch (role) {
      case UserRole.centreAdmin:
        return 'Centre Administrator';
      case UserRole.stateOfficer:
        return 'State Officer';
      case UserRole.agencyUser:
        return 'Agency User';
      case UserRole.auditor:
        return 'Auditor';
      case UserRole.publicViewer:
        return 'Public Viewer';
    }
  }

  void _showGlobalSearch() {
    showSearch(
      context: context,
      delegate: HubSearchDelegate(),
    );
  }

  void _showHubSettings() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const HubSettingsSheet(),
    );
  }

  void _startNewConversation() {
    // Navigate to new conversation screen
    Navigator.of(context).pushNamed('/hub/new-conversation');
  }

  void _createNewTicket() {
    // Navigate to new ticket screen
    Navigator.of(context).pushNamed('/hub/new-ticket');
  }

  void _uploadDocument() {
    // Navigate to document upload screen
    Navigator.of(context).pushNamed('/hub/upload-document');
  }

  void _scheduleMeeting() {
    // Navigate to meeting scheduler screen
    Navigator.of(context).pushNamed('/hub/schedule-meeting');
  }
}

class HubTab {
  final IconData icon;
  final String label;
  final int badge;

  HubTab({
    required this.icon,
    required this.label,
    this.badge = 0,
  });
}

class HubSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    if (query.isEmpty) {
      return const Center(
        child: Text('Search across messages, tickets, documents, and meetings'),
      );
    }

    return ListView(
      children: [
        _buildSearchSection('Messages', [
          _buildSearchResultItem(
            icon: Symbols.chat,
            title: 'Project Alpha Discussion',
            subtitle: 'Latest message: "Budget approval needed"',
            timestamp: '2 hours ago',
          ),
        ]),
        _buildSearchSection('Tickets', [
          _buildSearchResultItem(
            icon: Symbols.support_agent,
            title: 'Fund Transfer Issue #123',
            subtitle: 'Status: In Progress',
            timestamp: '1 day ago',
          ),
        ]),
        _buildSearchSection('Documents', [
          _buildSearchResultItem(
            icon: Symbols.description,
            title: 'Project Guidelines v2.1',
            subtitle: 'Updated by Centre Admin',
            timestamp: '3 days ago',
          ),
        ]),
      ],
    );
  }

  Widget _buildSearchSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...items,
        const Divider(),
      ],
    );
  }

  Widget _buildSearchResultItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String timestamp,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Text(
        timestamp,
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
      onTap: () {
        // Navigate to specific item
      },
    );
  }
}

class HubSettingsSheet extends StatelessWidget {
  const HubSettingsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Symbols.settings),
              const SizedBox(width: 12),
              const Text(
                'Hub Settings',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSettingItem(
            icon: Symbols.notifications,
            title: 'Notification Preferences',
            subtitle: 'Manage how you receive notifications',
            onTap: () {},
          ),
          _buildSettingItem(
            icon: Symbols.security,
            title: 'Privacy & Security',
            subtitle: 'Control your privacy settings',
            onTap: () {},
          ),
          _buildSettingItem(
            icon: Symbols.language,
            title: 'Language & Region',
            subtitle: 'Change language and regional settings',
            onTap: () {},
          ),
          _buildSettingItem(
            icon: Symbols.help,
            title: 'Help & Support',
            subtitle: 'Get help using the Communication Hub',
            onTap: () {},
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
