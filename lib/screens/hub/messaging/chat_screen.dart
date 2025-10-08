import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../models/user_role.dart';
import '../../../models/hub/chat_message.dart';

class ChatScreen extends StatefulWidget {
  final ChatChannel channel;
  final UserRole userRole;

  const ChatScreen({
    super.key,
    required this.channel,
    required this.userRole,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = _getDemoMessages();
  bool _isTyping = false;
  String? _replyToId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            _buildChannelAvatar(),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.channel.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _getParticipantsText(),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Symbols.videocam),
            onPressed: () => _startVideoCall(),
            tooltip: 'Start video call',
          ),
          IconButton(
            icon: const Icon(Symbols.call),
            onPressed: () => _startAudioCall(),
            tooltip: 'Start audio call',
          ),
          IconButton(
            icon: const Icon(Symbols.info),
            onPressed: () => _showChannelInfo(),
            tooltip: 'Channel info',
          ),
        ],
      ),
      body: Column(
        children: [
          if (_replyToId != null) _buildReplyBanner(),
          Expanded(
            child: _buildMessageList(),
          ),
          if (_isTyping) _buildTypingIndicator(),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildChannelAvatar() {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: _getChannelColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Icon(
        _getChannelIcon(),
        color: _getChannelColor(),
        size: 18,
      ),
    );
  }

  Widget _buildReplyBanner() {
    final replyMessage = _messages.firstWhere((m) => m.id == _replyToId);
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.blue[50],
      child: Row(
        children: [
          Icon(Symbols.reply, size: 16, color: Colors.blue[600]),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Replying to ${replyMessage.senderName}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[600],
                  ),
                ),
                Text(
                  replyMessage.content,
                  style: const TextStyle(fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 16),
            onPressed: () => setState(() => _replyToId = null),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        final isMe = message.senderId == 'current_user'; // Replace with actual user ID
        final showAvatar = index == _messages.length - 1 ||
            _messages[index + 1].senderId != message.senderId;
        
        return _buildMessageBubble(message, isMe, showAvatar);
      },
    );
  }

  Widget _buildMessageBubble(ChatMessage message, bool isMe, bool showAvatar) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe && showAvatar) ...[
            _buildUserAvatar(message),
            const SizedBox(width: 8),
          ] else if (!isMe) ...[
            const SizedBox(width: 40),
          ],
          Flexible(
            child: GestureDetector(
              onLongPress: () => _showMessageOptions(message),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isMe ? Theme.of(context).primaryColor : Colors.grey[200],
                  borderRadius: BorderRadius.circular(18).copyWith(
                    bottomLeft: Radius.circular(!isMe && showAvatar ? 4 : 18),
                    bottomRight: Radius.circular(isMe && showAvatar ? 4 : 18),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isMe && !showAvatar)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          message.senderName,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    if (message.replyToId != null) _buildReplyPreview(message),
                    Text(
                      message.content,
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.black87,
                        fontSize: 14,
                      ),
                    ),
                    if (message.attachments.isNotEmpty) _buildAttachments(message),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _formatMessageTime(message.timestamp),
                          style: TextStyle(
                            fontSize: 10,
                            color: isMe ? Colors.white70 : Colors.grey[500],
                          ),
                        ),
                        if (isMe) ...[
                          const SizedBox(width: 4),
                          Icon(
                            message.isRead ? Symbols.done_all : Symbols.done,
                            size: 12,
                            color: message.isRead ? Colors.blue[300] : Colors.white70,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isMe && showAvatar) ...[
            const SizedBox(width: 8),
            _buildUserAvatar(message),
          ] else if (isMe) ...[
            const SizedBox(width: 40),
          ],
        ],
      ),
    );
  }

  Widget _buildUserAvatar(ChatMessage message) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: _getUserColor(message.senderId),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          message.senderName.substring(0, 1).toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildReplyPreview(ChatMessage message) {
    final replyMessage = _messages.firstWhere(
      (m) => m.id == message.replyToId,
      orElse: () => ChatMessage(
        id: '',
        channelId: '',
        senderId: '',
        senderName: 'Unknown',
        senderRole: '',
        content: 'Message not found',
        timestamp: DateTime.now(),
      ),
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(8),
        border: Border(
          left: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 3,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            replyMessage.senderName,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            replyMessage.content,
            style: const TextStyle(fontSize: 10),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildAttachments(ChatMessage message) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: message.attachments.map((attachment) {
          return Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Symbols.attach_file, size: 16),
                const SizedBox(width: 4),
                Text(
                  attachment.split('/').last,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _buildUserAvatar(ChatMessage(
            id: '',
            channelId: '',
            senderId: 'typing_user',
            senderName: 'Someone',
            senderRole: '',
            content: '',
            timestamp: DateTime.now(),
          )),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTypingDot(0),
                const SizedBox(width: 4),
                _buildTypingDot(1),
                const SizedBox(width: 4),
                _buildTypingDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingDot(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + (index * 200)),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.5 + (value * 0.5),
          child: Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.grey[500],
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Symbols.attach_file),
            onPressed: () => _attachFile(),
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              maxLines: null,
              onChanged: (text) {
                // Simulate typing indicator
                if (text.isNotEmpty && !_isTyping) {
                  setState(() => _isTyping = true);
                  Future.delayed(const Duration(seconds: 2), () {
                    if (mounted) setState(() => _isTyping = false);
                  });
                }
              },
              onSubmitted: (text) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Symbols.emoji_emotions),
            onPressed: () => _showEmojiPicker(),
          ),
          IconButton(
            icon: Icon(
              Symbols.send,
              color: _messageController.text.isNotEmpty
                  ? Theme.of(context).primaryColor
                  : Colors.grey,
            ),
            onPressed: _messageController.text.isNotEmpty ? _sendMessage : null,
          ),
        ],
      ),
    );
  }

  Color _getChannelColor() {
    switch (widget.channel.type) {
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

  IconData _getChannelIcon() {
    switch (widget.channel.type) {
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

  Color _getUserColor(String userId) {
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
    ];
    return colors[userId.hashCode % colors.length];
  }

  String _getParticipantsText() {
    final participants = widget.channel.participantRoles.values.toList();
    if (participants.length <= 2) {
      return participants.join(', ');
    }
    return '${participants.take(2).join(', ')} and ${participants.length - 2} others';
  }

  String _formatMessageTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m';
    } else if (difference.inDays < 1) {
      return '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else {
      return '${timestamp.day}/${timestamp.month} ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
    }
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final message = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      channelId: widget.channel.id,
      senderId: 'current_user',
      senderName: 'You',
      senderRole: widget.userRole.name,
      content: _messageController.text.trim(),
      timestamp: DateTime.now(),
      replyToId: _replyToId,
    );

    setState(() {
      _messages.add(message);
      _messageController.clear();
      _replyToId = null;
    });

    // Scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _showMessageOptions(ChatMessage message) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Symbols.reply),
              title: const Text('Reply'),
              onTap: () {
                Navigator.pop(context);
                setState(() => _replyToId = message.id);
              },
            ),
            ListTile(
              leading: const Icon(Symbols.content_copy),
              title: const Text('Copy'),
              onTap: () {
                Navigator.pop(context);
                // Copy to clipboard
              },
            ),
            if (message.senderId == 'current_user')
              ListTile(
                leading: const Icon(Symbols.delete),
                title: const Text('Delete'),
                onTap: () {
                  Navigator.pop(context);
                  // Delete message
                },
              ),
          ],
        ),
      ),
    );
  }

  void _attachFile() {
    // Show file picker
  }

  void _showEmojiPicker() {
    // Show emoji picker
  }

  void _startVideoCall() {
    // Start video call
  }

  void _startAudioCall() {
    // Start audio call
  }

  void _showChannelInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(widget.channel.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Type: ${widget.channel.type}'),
            const SizedBox(height: 8),
            Text('Participants: ${widget.channel.participants.length}'),
            const SizedBox(height: 8),
            Text('Created: ${widget.channel.createdAt.toString().split(' ')[0]}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  static List<ChatMessage> _getDemoMessages() {
    final now = DateTime.now();
    return [
      ChatMessage(
        id: '1',
        channelId: '1',
        senderId: 'mh_officer',
        senderName: 'Rajesh Kumar',
        senderRole: 'State Officer',
        content: 'Good morning! I need to discuss the Q3 budget allocation for Maharashtra.',
        timestamp: now.subtract(const Duration(hours: 3)),
        isRead: true,
        readBy: ['current_user'],
      ),
      ChatMessage(
        id: '2',
        channelId: '1',
        senderId: 'current_user',
        senderName: 'You',
        senderRole: 'Centre Admin',
        content: 'Good morning Rajesh! I have the budget details ready. Let me share the breakdown.',
        timestamp: now.subtract(const Duration(hours: 2, minutes: 45)),
        isRead: true,
        readBy: ['mh_officer'],
      ),
      ChatMessage(
        id: '3',
        channelId: '1',
        senderId: 'current_user',
        senderName: 'You',
        senderRole: 'Centre Admin',
        content: 'For Q3, Maharashtra has been allocated ₹50 crores for Adarsh Gram projects and ₹5 crores for hostel infrastructure.',
        timestamp: now.subtract(const Duration(hours: 2, minutes: 40)),
        isRead: true,
        readBy: ['mh_officer'],
        attachments: ['budget_breakdown_q3.pdf'],
      ),
      ChatMessage(
        id: '4',
        channelId: '1',
        senderId: 'mh_officer',
        senderName: 'Rajesh Kumar',
        senderRole: 'State Officer',
        content: 'Thank you for the breakdown. I notice the hostel allocation is lower than expected. Can we discuss increasing it?',
        timestamp: now.subtract(const Duration(hours: 2, minutes: 20)),
        isRead: true,
        readBy: ['current_user'],
        replyToId: '3',
      ),
      ChatMessage(
        id: '5',
        channelId: '1',
        senderId: 'current_user',
        senderName: 'You',
        senderRole: 'Centre Admin',
        content: 'The hostel allocation follows the 2% guideline as per PM-AJAY norms. However, if you have specific requirements, we can review them.',
        timestamp: now.subtract(const Duration(hours: 2, minutes: 10)),
        isRead: false,
        readBy: [],
      ),
      ChatMessage(
        id: '6',
        channelId: '1',
        senderId: 'mh_officer',
        senderName: 'Rajesh Kumar',
        senderRole: 'State Officer',
        content: 'We have 3 additional colleges that meet NIRF criteria. I\'ll send the documentation for review.',
        timestamp: now.subtract(const Duration(hours: 2)),
        isRead: false,
        readBy: [],
      ),
    ];
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
