import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../models/user_role.dart';
import '../../../models/hub/chat_message.dart';
import 'chat_screen.dart';

class MessagingScreen extends StatefulWidget {
  final UserRole userRole;

  const MessagingScreen({
    super.key,
    required this.userRole,
  });

  @override
  State<MessagingScreen> createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  String _selectedFilter = 'all';
  final List<ChatChannel> _channels = _getDemoChannels();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Channel List Sidebar
        Container(
          width: 320,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              right: BorderSide(color: Colors.grey[300]!),
            ),
          ),
          child: Column(
            children: [
              _buildChannelHeader(),
              _buildFilterTabs(),
              Expanded(
                child: _buildChannelList(),
              ),
            ],
          ),
        ),
        // Chat Area
        Expanded(
          child: _buildChatArea(),
        ),
      ],
    );
  }

  Widget _buildChannelHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        children: [
          const Icon(Symbols.chat, size: 24),
          const SizedBox(width: 12),
          const Text(
            'Messages',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Symbols.add_comment),
            onPressed: () => _startNewConversation(),
            tooltip: 'Start new conversation',
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    final filters = [
      {'key': 'all', 'label': 'All', 'count': _channels.length},
      {'key': 'centre_state', 'label': 'Centre-State', 'count': 2},
      {'key': 'state_agency', 'label': 'State-Agency', 'count': 3},
      {'key': 'centre_auditor', 'label': 'Centre-Auditor', 'count': 1},
      {'key': 'public_forum', 'label': 'Public Forum', 'count': 1},
    ];

    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = _selectedFilter == filter['key'];
          
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(filter['label'] as String),
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${filter['count']}',
                      style: TextStyle(
                        fontSize: 10,
                        color: isSelected ? Theme.of(context).primaryColor : Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = filter['key'] as String;
                });
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildChannelList() {
    final filteredChannels = _selectedFilter == 'all' 
        ? _channels 
        : _channels.where((c) => c.type == _selectedFilter).toList();

    return ListView.builder(
      itemCount: filteredChannels.length,
      itemBuilder: (context, index) {
        final channel = filteredChannels[index];
        return _buildChannelItem(channel);
      },
    );
  }

  Widget _buildChannelItem(ChatChannel channel) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.transparent,
      ),
      child: ListTile(
        leading: _buildChannelAvatar(channel),
        title: Row(
          children: [
            Expanded(
              child: Text(
                channel.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (channel.unreadCount > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${channel.unreadCount}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (channel.lastMessage != null) ...[
              Text(
                channel.lastMessage!.content,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
            ],
            Row(
              children: [
                Icon(
                  _getChannelTypeIcon(channel.type),
                  size: 12,
                  color: Colors.grey[500],
                ),
                const SizedBox(width: 4),
                Text(
                  _formatChannelType(channel.type),
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[500],
                  ),
                ),
                const Spacer(),
                Text(
                  _formatTimestamp(channel.lastActivityAt),
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: () => _openChannel(channel),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }

  Widget _buildChannelAvatar(ChatChannel channel) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: _getChannelColor(channel.type).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(
        _getChannelTypeIcon(channel.type),
        color: _getChannelColor(channel.type),
        size: 20,
      ),
    );
  }

  Widget _buildChatArea() {
    return Container(
      color: Colors.grey[50],
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Symbols.chat,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'Select a conversation to start messaging',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getChannelTypeIcon(String type) {
    switch (type) {
      case 'centre_state':
        return Symbols.account_balance;
      case 'state_agency':
        return Symbols.business;
      case 'centre_auditor':
        return Symbols.verified;
      case 'public_forum':
        return Symbols.public;
      default:
        return Symbols.chat;
    }
  }

  Color _getChannelColor(String type) {
    switch (type) {
      case 'centre_state':
        return Colors.blue;
      case 'state_agency':
        return Colors.green;
      case 'centre_auditor':
        return Colors.orange;
      case 'public_forum':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String _formatChannelType(String type) {
    switch (type) {
      case 'centre_state':
        return 'Centre-State';
      case 'state_agency':
        return 'State-Agency';
      case 'centre_auditor':
        return 'Centre-Auditor';
      case 'public_forum':
        return 'Public Forum';
      default:
        return 'Chat';
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return '${timestamp.day}/${timestamp.month}';
    }
  }

  void _startNewConversation() {
    showDialog(
      context: context,
      builder: (context) => const NewConversationDialog(),
    );
  }

  void _openChannel(ChatChannel channel) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          channel: channel,
          userRole: widget.userRole,
        ),
      ),
    );
  }

  static List<ChatChannel> _getDemoChannels() {
    final now = DateTime.now();
    return [
      ChatChannel(
        id: '1',
        name: 'Maharashtra State Coordination',
        type: 'centre_state',
        contextId: 'mh_001',
        contextType: 'state',
        participants: ['centre_admin', 'mh_officer'],
        participantRoles: {
          'centre_admin': 'Centre Admin',
          'mh_officer': 'State Officer',
        },
        createdAt: now.subtract(const Duration(days: 5)),
        lastActivityAt: now.subtract(const Duration(hours: 2)),
        unreadCount: 3,
        lastMessage: ChatMessage(
          id: 'msg_1',
          channelId: '1',
          senderId: 'mh_officer',
          senderName: 'Rajesh Kumar',
          senderRole: 'State Officer',
          content: 'Budget approval needed for Q3 projects',
          timestamp: now.subtract(const Duration(hours: 2)),
        ),
      ),
      ChatChannel(
        id: '2',
        name: 'Project Alpha - Agency ABC',
        type: 'state_agency',
        contextId: 'proj_alpha',
        contextType: 'project',
        participants: ['state_officer', 'agency_abc'],
        participantRoles: {
          'state_officer': 'State Officer',
          'agency_abc': 'Agency User',
        },
        createdAt: now.subtract(const Duration(days: 3)),
        lastActivityAt: now.subtract(const Duration(minutes: 30)),
        unreadCount: 1,
        lastMessage: ChatMessage(
          id: 'msg_2',
          channelId: '2',
          senderId: 'agency_abc',
          senderName: 'Priya Sharma',
          senderRole: 'Agency User',
          content: 'Milestone 2 completed, uploading evidence',
          timestamp: now.subtract(const Duration(minutes: 30)),
        ),
      ),
      ChatChannel(
        id: '3',
        name: 'Audit Review - Q2 2024',
        type: 'centre_auditor',
        contextId: 'audit_q2_2024',
        contextType: 'audit',
        participants: ['centre_admin', 'auditor_001'],
        participantRoles: {
          'centre_admin': 'Centre Admin',
          'auditor_001': 'Auditor',
        },
        createdAt: now.subtract(const Duration(days: 7)),
        lastActivityAt: now.subtract(const Duration(days: 1)),
        unreadCount: 0,
        lastMessage: ChatMessage(
          id: 'msg_3',
          channelId: '3',
          senderId: 'auditor_001',
          senderName: 'Dr. Amit Patel',
          senderRole: 'Auditor',
          content: 'Audit report finalized and submitted',
          timestamp: now.subtract(const Duration(days: 1)),
        ),
      ),
      ChatChannel(
        id: '4',
        name: 'Public Announcements',
        type: 'public_forum',
        contextId: 'public_001',
        contextType: 'public',
        participants: ['centre_admin', 'public_users'],
        participantRoles: {
          'centre_admin': 'Centre Admin',
          'public_users': 'Public',
        },
        createdAt: now.subtract(const Duration(days: 10)),
        lastActivityAt: now.subtract(const Duration(hours: 6)),
        unreadCount: 2,
        lastMessage: ChatMessage(
          id: 'msg_4',
          channelId: '4',
          senderId: 'centre_admin',
          senderName: 'System Admin',
          senderRole: 'Centre Admin',
          content: 'New PM-AJAY guidelines published',
          timestamp: now.subtract(const Duration(hours: 6)),
        ),
      ),
    ];
  }
}

class NewConversationDialog extends StatefulWidget {
  const NewConversationDialog({super.key});

  @override
  State<NewConversationDialog> createState() => _NewConversationDialogState();
}

class _NewConversationDialogState extends State<NewConversationDialog> {
  String _selectedType = 'centre_state';
  final _titleController = TextEditingController();
  final _participantsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Start New Conversation'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedType,
              decoration: const InputDecoration(
                labelText: 'Conversation Type',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'centre_state',
                  child: Text('Centre-State'),
                ),
                DropdownMenuItem(
                  value: 'state_agency',
                  child: Text('State-Agency'),
                ),
                DropdownMenuItem(
                  value: 'centre_auditor',
                  child: Text('Centre-Auditor'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedType = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Conversation Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _participantsController,
              decoration: const InputDecoration(
                labelText: 'Participants (comma separated)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            // Create new conversation
            Navigator.of(context).pop();
          },
          child: const Text('Start'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _participantsController.dispose();
    super.dispose();
  }
}
