import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../models/user_role.dart';
import '../../../models/hub/notification.dart';

class NotificationsScreen extends StatefulWidget {
  final UserRole userRole;

  const NotificationsScreen({
    super.key,
    required this.userRole,
  });

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _selectedFilter = 'all';
  final List<HubNotification> _notifications = _getDemoNotifications();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        _buildFilters(),
        Expanded(
          child: _buildNotificationsList(),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        children: [
          const Icon(Symbols.notifications, size: 24),
          const SizedBox(width: 12),
          const Text(
            'Notifications',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          _buildNotificationStats(),
          const SizedBox(width: 16),
          PopupMenuButton<String>(
            onSelected: _handleMenuAction,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'mark_all_read',
                child: Row(
                  children: [
                    Icon(Symbols.mark_email_read),
                    SizedBox(width: 8),
                    Text('Mark All Read'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Symbols.settings),
                    SizedBox(width: 8),
                    Text('Settings'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationStats() {
    final unreadCount = _notifications.where((n) => !n.isRead).length;
    final criticalCount = _notifications.where((n) => 
        n.priority == NotificationPriority.critical && !n.isRead).length;

    return Row(
      children: [
        _buildStatChip('Unread', unreadCount, Colors.blue),
        const SizedBox(width: 8),
        if (criticalCount > 0)
          _buildStatChip('Critical', criticalCount, Colors.red),
      ],
    );
  }

  Widget _buildStatChip(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$count',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: Colors.grey[50],
      child: Row(
        children: [
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildFilterChip('all', 'All', _notifications.length),
                _buildFilterChip('unread', 'Unread', 
                    _notifications.where((n) => !n.isRead).length),
                _buildFilterChip('message', 'Messages', 
                    _notifications.where((n) => n.type == NotificationType.message).length),
                _buildFilterChip('ticketUpdate', 'Tickets', 
                    _notifications.where((n) => n.type == NotificationType.ticketUpdate).length),
                _buildFilterChip('deadlineReminder', 'Deadlines', 
                    _notifications.where((n) => n.type == NotificationType.deadlineReminder).length),
                _buildFilterChip('escalationAlert', 'Escalations', 
                    _notifications.where((n) => n.type == NotificationType.escalationAlert).length),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String filter, String label, int count) {
    final isSelected = _selectedFilter == filter;
    
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label),
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Theme.of(context).primaryColor : Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedFilter = filter;
          });
        },
      ),
    );
  }

  Widget _buildNotificationsList() {
    final filteredNotifications = _getFilteredNotifications();
    
    if (filteredNotifications.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredNotifications.length,
      itemBuilder: (context, index) {
        final notification = filteredNotifications[index];
        return _buildNotificationCard(notification);
      },
    );
  }

  Widget _buildNotificationCard(HubNotification notification) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: notification.isRead ? Colors.white : Colors.blue[50],
      child: InkWell(
        onTap: () => _handleNotificationTap(notification),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getNotificationTypeColor(notification.type).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getNotificationTypeIcon(notification.type),
                  size: 20,
                  color: _getNotificationTypeColor(notification.type),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                            ),
                          ),
                        ),
                        if (notification.priority == NotificationPriority.critical)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'CRITICAL',
                              style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.message,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Symbols.schedule,
                          size: 12,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatTimestamp(notification.createdAt),
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[500],
                          ),
                        ),
                        const Spacer(),
                        if (notification.actionUrl != null)
                          TextButton(
                            onPressed: () => _handleNotificationAction(notification),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              'View',
                              style: TextStyle(fontSize: 11),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              if (!notification.isRead)
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Symbols.notifications_none,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No notifications',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You\'re all caught up!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  List<HubNotification> _getFilteredNotifications() {
    switch (_selectedFilter) {
      case 'unread':
        return _notifications.where((n) => !n.isRead).toList();
      case 'message':
        return _notifications.where((n) => n.type == NotificationType.message).toList();
      case 'ticketUpdate':
        return _notifications.where((n) => n.type == NotificationType.ticketUpdate).toList();
      case 'deadlineReminder':
        return _notifications.where((n) => n.type == NotificationType.deadlineReminder).toList();
      case 'escalationAlert':
        return _notifications.where((n) => n.type == NotificationType.escalationAlert).toList();
      default:
        return _notifications;
    }
  }

  IconData _getNotificationTypeIcon(NotificationType type) {
    switch (type) {
      case NotificationType.message:
        return Symbols.chat;
      case NotificationType.ticketUpdate:
        return Symbols.support_agent;
      case NotificationType.deadlineReminder:
        return Symbols.schedule;
      case NotificationType.approvalDecision:
        return Symbols.check_circle;
      case NotificationType.escalationAlert:
        return Symbols.priority_high;
      case NotificationType.meetingReminder:
        return Symbols.event;
      case NotificationType.documentShared:
        return Symbols.folder_shared;
      case NotificationType.systemAlert:
        return Symbols.warning;
    }
  }

  Color _getNotificationTypeColor(NotificationType type) {
    switch (type) {
      case NotificationType.message:
        return Colors.blue;
      case NotificationType.ticketUpdate:
        return Colors.green;
      case NotificationType.deadlineReminder:
        return Colors.orange;
      case NotificationType.approvalDecision:
        return Colors.teal;
      case NotificationType.escalationAlert:
        return Colors.red;
      case NotificationType.meetingReminder:
        return Colors.purple;
      case NotificationType.documentShared:
        return Colors.indigo;
      case NotificationType.systemAlert:
        return Colors.amber;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'mark_all_read':
        setState(() {
          for (var notification in _notifications) {
            notification.copyWith(isRead: true, readAt: DateTime.now());
          }
        });
        break;
      case 'settings':
        _showNotificationSettings();
        break;
    }
  }

  void _handleNotificationTap(HubNotification notification) {
    if (!notification.isRead) {
      setState(() {
        // Mark as read
        final index = _notifications.indexWhere((n) => n.id == notification.id);
        if (index != -1) {
          _notifications[index] = notification.copyWith(
            isRead: true,
            readAt: DateTime.now(),
          );
        }
      });
    }

    if (notification.actionUrl != null) {
      _handleNotificationAction(notification);
    }
  }

  void _handleNotificationAction(HubNotification notification) {
    // Navigate to the relevant screen based on actionUrl
    // This would typically use Navigator.pushNamed or similar
  }

  void _showNotificationSettings() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const NotificationSettingsSheet(),
    );
  }

  static List<HubNotification> _getDemoNotifications() {
    final now = DateTime.now();
    return [
      HubNotification(
        id: 'notif_001',
        userId: 'current_user',
        title: 'New message in Maharashtra Project Discussion',
        message: 'Rajesh Kumar: "Budget approval needed for Q3 projects"',
        type: NotificationType.message,
        priority: NotificationPriority.medium,
        contextId: 'channel_001',
        contextType: 'message',
        createdAt: now.subtract(const Duration(minutes: 15)),
        actionUrl: '/hub/messages/channel_001',
      ),
      HubNotification(
        id: 'notif_002',
        userId: 'current_user',
        title: 'Ticket #TKT001 has been escalated',
        message: 'Fund Transfer Delay - Project Alpha has been escalated due to SLA breach',
        type: NotificationType.escalationAlert,
        priority: NotificationPriority.critical,
        contextId: 'TKT001',
        contextType: 'ticket',
        createdAt: now.subtract(const Duration(hours: 2)),
        actionUrl: '/hub/tickets/TKT001',
      ),
      HubNotification(
        id: 'notif_003',
        userId: 'current_user',
        title: 'Meeting reminder: Maharashtra Project Review',
        message: 'Your meeting starts in 30 minutes',
        type: NotificationType.meetingReminder,
        priority: NotificationPriority.high,
        contextId: 'meet_001',
        contextType: 'meeting',
        createdAt: now.subtract(const Duration(minutes: 30)),
        actionUrl: '/hub/meetings/meet_001',
      ),
      HubNotification(
        id: 'notif_004',
        userId: 'current_user',
        title: 'Document shared: PM-AJAY Guidelines v2.1',
        message: 'Centre Admin shared updated implementation guidelines',
        type: NotificationType.documentShared,
        priority: NotificationPriority.medium,
        contextId: 'doc_001',
        contextType: 'document',
        createdAt: now.subtract(const Duration(hours: 6)),
        isRead: true,
        readAt: now.subtract(const Duration(hours: 4)),
        actionUrl: '/hub/documents/doc_001',
      ),
      HubNotification(
        id: 'notif_005',
        userId: 'current_user',
        title: 'State Request REQ001 approved',
        message: 'Maharashtra PM-AJAY participation request has been approved',
        type: NotificationType.approvalDecision,
        priority: NotificationPriority.high,
        contextId: 'REQ001',
        contextType: 'request',
        createdAt: now.subtract(const Duration(days: 1)),
        isRead: true,
        readAt: now.subtract(const Duration(hours: 20)),
        actionUrl: '/review/requests/REQ001',
      ),
      HubNotification(
        id: 'notif_006',
        userId: 'current_user',
        title: 'Deadline approaching: Q3 Budget Submission',
        message: 'Q3 budget submissions are due in 2 days',
        type: NotificationType.deadlineReminder,
        priority: NotificationPriority.high,
        contextId: 'deadline_q3_budget',
        contextType: 'deadline',
        createdAt: now.subtract(const Duration(hours: 8)),
        actionUrl: '/deadlines/q3_budget',
      ),
      HubNotification(
        id: 'notif_007',
        userId: 'current_user',
        title: 'System maintenance scheduled',
        message: 'Planned maintenance on Sunday 2 AM - 4 AM IST',
        type: NotificationType.systemAlert,
        priority: NotificationPriority.low,
        createdAt: now.subtract(const Duration(days: 2)),
        isRead: true,
        readAt: now.subtract(const Duration(days: 1)),
      ),
      HubNotification(
        id: 'notif_008',
        userId: 'current_user',
        title: 'Ticket #TKT002 updated',
        message: 'Tech Support added a comment to your technical issue',
        type: NotificationType.ticketUpdate,
        priority: NotificationPriority.medium,
        contextId: 'TKT002',
        contextType: 'ticket',
        createdAt: now.subtract(const Duration(hours: 12)),
        actionUrl: '/hub/tickets/TKT002',
      ),
    ];
  }
}

class NotificationSettingsSheet extends StatefulWidget {
  const NotificationSettingsSheet({super.key});

  @override
  State<NotificationSettingsSheet> createState() => _NotificationSettingsSheetState();
}

class _NotificationSettingsSheetState extends State<NotificationSettingsSheet> {
  bool _inAppNotifications = true;
  bool _emailNotifications = true;
  bool _smsNotifications = false;
  bool _quietHours = false;
  
  final Map<NotificationType, bool> _typePreferences = {
    NotificationType.message: true,
    NotificationType.ticketUpdate: true,
    NotificationType.deadlineReminder: true,
    NotificationType.approvalDecision: true,
    NotificationType.escalationAlert: true,
    NotificationType.meetingReminder: true,
    NotificationType.documentShared: false,
    NotificationType.systemAlert: true,
  };

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
                'Notification Settings',
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
          const Text(
            'Delivery Methods',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            title: const Text('In-app notifications'),
            subtitle: const Text('Show notifications within the app'),
            value: _inAppNotifications,
            onChanged: (value) => setState(() => _inAppNotifications = value),
          ),
          SwitchListTile(
            title: const Text('Email notifications'),
            subtitle: const Text('Send notifications to your email'),
            value: _emailNotifications,
            onChanged: (value) => setState(() => _emailNotifications = value),
          ),
          SwitchListTile(
            title: const Text('SMS notifications'),
            subtitle: const Text('Send critical notifications via SMS'),
            value: _smsNotifications,
            onChanged: (value) => setState(() => _smsNotifications = value),
          ),
          const SizedBox(height: 24),
          const Text(
            'Notification Types',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ..._typePreferences.entries.map((entry) {
            return SwitchListTile(
              title: Text(_getTypeDisplayName(entry.key)),
              value: entry.value,
              onChanged: (value) => setState(() => _typePreferences[entry.key] = value),
            );
          }),
          const SizedBox(height: 24),
          const Text(
            'Quiet Hours',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 12),
          SwitchListTile(
            title: const Text('Enable quiet hours'),
            subtitle: const Text('Reduce notifications during specified hours'),
            value: _quietHours,
            onChanged: (value) => setState(() => _quietHours = value),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Save Settings'),
            ),
          ),
        ],
      ),
    );
  }

  String _getTypeDisplayName(NotificationType type) {
    switch (type) {
      case NotificationType.message:
        return 'Messages';
      case NotificationType.ticketUpdate:
        return 'Ticket Updates';
      case NotificationType.deadlineReminder:
        return 'Deadline Reminders';
      case NotificationType.approvalDecision:
        return 'Approval Decisions';
      case NotificationType.escalationAlert:
        return 'Escalation Alerts';
      case NotificationType.meetingReminder:
        return 'Meeting Reminders';
      case NotificationType.documentShared:
        return 'Document Sharing';
      case NotificationType.systemAlert:
        return 'System Alerts';
    }
  }
}
