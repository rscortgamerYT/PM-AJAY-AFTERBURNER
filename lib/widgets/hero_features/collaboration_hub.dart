import 'package:flutter/material.dart';
import 'dart:async';

// Seamless Multi-Channel Collaboration Hub with Contextual Project Rooms
class CollaborationHub extends StatefulWidget {
  final String currentProjectId;
  final String userRole;
  final String userId;

  const CollaborationHub({
    super.key,
    required this.currentProjectId,
    required this.userRole,
    required this.userId,
  });

  @override
  State<CollaborationHub> createState() => _CollaborationHubState();
}

class _CollaborationHubState extends State<CollaborationHub>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _chatScrollController = ScrollController();

  List<ChatMessage> _messages = [];
  List<TaskItem> _tasks = [];
  List<CollaborativeDocument> _documents = [];
  List<ProjectRoom> _projectRooms = [];
  
  bool _isRecording = false;
  bool _isTyping = false;
  String _currentRoom = '';
  StreamSubscription? _messageSubscription;
  StreamSubscription? _typingSubscription;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _currentRoom = widget.currentProjectId;
    _loadCollaborationData();
    _subscribeToRealTimeUpdates();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(left: BorderSide(color: Colors.grey[300]!)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(-2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildHeader(),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildChatTab(),
                _buildTasksTab(),
                _buildDocumentsTab(),
                _buildMeetingsTab(),
              ],
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.indigo[50]!, Colors.white],
        ),
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.forum, color: Colors.indigo, size: 24),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Project Room',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              PopupMenuButton<String>(
                onSelected: _switchProjectRoom,
                itemBuilder: (context) => _projectRooms.map((room) {
                  return PopupMenuItem(
                    value: room.id,
                    child: Text(room.name),
                  );
                }).toList(),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.indigo[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _getCurrentRoomName(),
                        style: const TextStyle(fontSize: 12),
                      ),
                      const Icon(Icons.arrow_drop_down, size: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // Active Participants
          Row(
            children: [
              const Text(
                'Active: ',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Expanded(
                child: Wrap(
                  spacing: 4,
                  children: _buildActiveParticipants(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: Colors.indigo,
        unselectedLabelColor: Colors.grey,
        indicatorColor: Colors.indigo,
        tabs: [
          Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.chat, size: 16),
                const SizedBox(width: 4),
                const Text('Chat'),
                if (_getUnreadCount() > 0)
                  Container(
                    margin: const EdgeInsets.only(left: 4),
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${_getUnreadCount()}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.task_alt, size: 16),
                const SizedBox(width: 4),
                const Text('Tasks'),
                if (_getPendingTasksCount() > 0)
                  Container(
                    margin: const EdgeInsets.only(left: 4),
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${_getPendingTasksCount()}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.description, size: 16),
                SizedBox(width: 4),
                Text('Docs'),
              ],
            ),
          ),
          const Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.video_call, size: 16),
                SizedBox(width: 4),
                Text('Meet'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatTab() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _chatScrollController,
            padding: const EdgeInsets.all(16),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final message = _messages[index];
              return _buildMessageBubble(message);
            },
          ),
        ),
        
        if (_isTyping)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                const SizedBox(width: 8),
                Text(
                  'Someone is typing...',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isMe = message.senderId == widget.userId;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.indigo[100],
              child: Text(
                message.senderName[0].toUpperCase(),
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 8),
          ],
          
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isMe ? Colors.indigo : Colors.grey[100],
                borderRadius: BorderRadius.circular(16).copyWith(
                  bottomLeft: isMe ? const Radius.circular(16) : const Radius.circular(4),
                  bottomRight: isMe ? const Radius.circular(4) : const Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isMe)
                    Text(
                      message.senderName,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  
                  if (message.type == MessageType.text)
                    Text(
                      message.content,
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.black87,
                        fontSize: 14,
                      ),
                    )
                  else if (message.type == MessageType.voice)
                    _buildVoiceMessage(message, isMe)
                  else if (message.type == MessageType.location)
                    _buildLocationMessage(message, isMe)
                  else if (message.type == MessageType.file)
                    _buildFileMessage(message, isMe),
                  
                  const SizedBox(height: 4),
                  
                  Text(
                    _formatMessageTime(message.timestamp),
                    style: TextStyle(
                      fontSize: 10,
                      color: isMe ? Colors.white70 : Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          if (isMe) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.indigo[100],
              child: Text(
                message.senderName[0].toUpperCase(),
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildVoiceMessage(ChatMessage message, bool isMe) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () => _playVoiceMessage(message),
            icon: Icon(
              Icons.play_arrow,
              color: isMe ? Colors.white : Colors.indigo,
            ),
          ),
          Expanded(
            child: LinearProgressIndicator(
              value: 0.3, // Simulated progress
              backgroundColor: isMe ? Colors.white30 : Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                isMe ? Colors.white : Colors.indigo,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '0:${message.duration}s',
            style: TextStyle(
              fontSize: 12,
              color: isMe ? Colors.white70 : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationMessage(ChatMessage message, bool isMe) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.location_on,
                color: isMe ? Colors.white : Colors.red,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                'Location Shared',
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text('Map Preview'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFileMessage(ChatMessage message, bool isMe) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Icon(
            Icons.attach_file,
            color: isMe ? Colors.white : Colors.indigo,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message.fileName ?? 'File attachment',
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black87,
                fontSize: 12,
              ),
            ),
          ),
          IconButton(
            onPressed: () => _downloadFile(message),
            icon: Icon(
              Icons.download,
              color: isMe ? Colors.white : Colors.indigo,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTasksTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _tasks.length,
      itemBuilder: (context, index) {
        final task = _tasks[index];
        return _buildTaskItem(task);
      },
    );
  }

  Widget _buildTaskItem(TaskItem task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
        color: task.isCompleted ? Colors.green[50] : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Checkbox(
                value: task.isCompleted,
                onChanged: (value) => _toggleTask(task),
              ),
              Expanded(
                child: Text(
                  task.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: _getPriorityColor(task.priority).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  task.priority.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    color: _getPriorityColor(task.priority),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          
          if (task.description.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              task.description,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
          
          const SizedBox(height: 8),
          
          Row(
            children: [
              Icon(Icons.person, size: 12, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                task.assignedTo,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              const Spacer(),
              Icon(Icons.schedule, size: 12, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                _formatDate(task.dueDate),
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _documents.length,
      itemBuilder: (context, index) {
        final document = _documents[index];
        return _buildDocumentItem(document);
      },
    );
  }

  Widget _buildDocumentItem(CollaborativeDocument document) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getDocumentIcon(document.type),
                color: Colors.indigo,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  document.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              if (document.isBeingEdited)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'LIVE',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Last modified: ${_formatDateTime(document.lastModified)}',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          
          if (document.collaborators.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Text(
                  'Collaborators: ',
                  style: TextStyle(fontSize: 12),
                ),
                Expanded(
                  child: Wrap(
                    spacing: 4,
                    children: document.collaborators.map((collaborator) {
                      return CircleAvatar(
                        radius: 8,
                        backgroundColor: Colors.indigo[100],
                        child: Text(
                          collaborator[0].toUpperCase(),
                          style: const TextStyle(fontSize: 8),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ],
          
          const SizedBox(height: 8),
          
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _viewDocument(document),
                  child: const Text('View', style: TextStyle(fontSize: 12)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _editDocument(document),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Edit', style: TextStyle(fontSize: 12)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMeetingsTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ElevatedButton.icon(
            onPressed: _startInstantMeeting,
            icon: const Icon(Icons.video_call),
            label: const Text('Start Instant Meeting'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
          
          const SizedBox(height: 16),
          
          ElevatedButton.icon(
            onPressed: _scheduleMeeting,
            icon: const Icon(Icons.schedule),
            label: const Text('Schedule Meeting'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
          
          const SizedBox(height: 24),
          
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Recent Meetings',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Recent meetings list would go here
          Expanded(
            child: ListView(
              children: [
                _buildMeetingItem('Project Review', DateTime.now().subtract(const Duration(hours: 2))),
                _buildMeetingItem('Budget Discussion', DateTime.now().subtract(const Duration(days: 1))),
                _buildMeetingItem('Progress Update', DateTime.now().subtract(const Duration(days: 3))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeetingItem(String title, DateTime dateTime) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.video_call, color: Colors.indigo),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  _formatDateTime(dateTime),
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _viewMeetingRecording(title),
            icon: const Icon(Icons.play_arrow),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          // Attachment button
          IconButton(
            onPressed: _showAttachmentOptions,
            icon: const Icon(Icons.attach_file),
          ),
          
          // Voice recording button
          GestureDetector(
            onLongPressStart: (_) => _startRecording(),
            onLongPressEnd: (_) => _stopRecording(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _isRecording ? Colors.red : Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.mic,
                color: _isRecording ? Colors.white : Colors.grey[600],
              ),
            ),
          ),
          
          const SizedBox(width: 8),
          
          // Text input
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              onChanged: _onTyping,
              onSubmitted: _sendMessage,
            ),
          ),
          
          const SizedBox(width: 8),
          
          // Send button
          IconButton(
            onPressed: () => _sendMessage(_messageController.text),
            icon: const Icon(Icons.send, color: Colors.indigo),
          ),
        ],
      ),
    );
  }

  // Helper methods and event handlers would go here
  List<Widget> _buildActiveParticipants() {
    return [
      CircleAvatar(
        radius: 8,
        backgroundColor: Colors.green,
        child: const Text('A', style: TextStyle(fontSize: 8, color: Colors.white)),
      ),
      CircleAvatar(
        radius: 8,
        backgroundColor: Colors.blue,
        child: const Text('B', style: TextStyle(fontSize: 8, color: Colors.white)),
      ),
      CircleAvatar(
        radius: 8,
        backgroundColor: Colors.orange,
        child: const Text('C', style: TextStyle(fontSize: 8, color: Colors.white)),
      ),
    ];
  }

  void _loadCollaborationData() {
    // Load mock data
    setState(() {
      _messages = _generateMockMessages();
      _tasks = _generateMockTasks();
      _documents = _generateMockDocuments();
      _projectRooms = _generateMockProjectRooms();
    });
  }

  List<ChatMessage> _generateMockMessages() {
    return [
      ChatMessage(
        id: '1',
        senderId: 'user1',
        senderName: 'John Doe',
        content: 'The budget allocation for Q4 has been approved.',
        type: MessageType.text,
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
      ChatMessage(
        id: '2',
        senderId: widget.userId,
        senderName: 'You',
        content: 'Great! When can we start the implementation?',
        type: MessageType.text,
        timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
      ),
    ];
  }

  List<TaskItem> _generateMockTasks() {
    return [
      TaskItem(
        id: '1',
        title: 'Review budget documents',
        description: 'Check all financial allocations for accuracy',
        assignedTo: 'John Doe',
        dueDate: DateTime.now().add(const Duration(days: 2)),
        priority: 'high',
        isCompleted: false,
      ),
      TaskItem(
        id: '2',
        title: 'Update project timeline',
        description: 'Revise milestones based on new requirements',
        assignedTo: 'Jane Smith',
        dueDate: DateTime.now().add(const Duration(days: 5)),
        priority: 'medium',
        isCompleted: true,
      ),
    ];
  }

  List<CollaborativeDocument> _generateMockDocuments() {
    return [
      CollaborativeDocument(
        id: '1',
        name: 'Project Requirements.docx',
        type: 'document',
        lastModified: DateTime.now().subtract(const Duration(hours: 2)),
        collaborators: ['John', 'Jane', 'Bob'],
        isBeingEdited: true,
      ),
      CollaborativeDocument(
        id: '2',
        name: 'Budget Spreadsheet.xlsx',
        type: 'spreadsheet',
        lastModified: DateTime.now().subtract(const Duration(days: 1)),
        collaborators: ['Alice', 'Charlie'],
        isBeingEdited: false,
      ),
    ];
  }

  List<ProjectRoom> _generateMockProjectRooms() {
    return [
      ProjectRoom(id: 'room1', name: 'Infrastructure Project'),
      ProjectRoom(id: 'room2', name: 'Education Initiative'),
      ProjectRoom(id: 'room3', name: 'Healthcare Program'),
    ];
  }

  @override
  void dispose() {
    _tabController.dispose();
    _messageController.dispose();
    _chatScrollController.dispose();
    _messageSubscription?.cancel();
    _typingSubscription?.cancel();
    super.dispose();
  }
}

// Data Models
class ChatMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String content;
  final MessageType type;
  final DateTime timestamp;
  final String? fileName;
  final int? duration;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.content,
    required this.type,
    required this.timestamp,
    this.fileName,
    this.duration,
  });
}

class TaskItem {
  final String id;
  final String title;
  final String description;
  final String assignedTo;
  final DateTime dueDate;
  final String priority;
  final bool isCompleted;

  TaskItem({
    required this.id,
    required this.title,
    required this.description,
    required this.assignedTo,
    required this.dueDate,
    required this.priority,
    required this.isCompleted,
  });
}

class CollaborativeDocument {
  final String id;
  final String name;
  final String type;
  final DateTime lastModified;
  final List<String> collaborators;
  final bool isBeingEdited;

  CollaborativeDocument({
    required this.id,
    required this.name,
    required this.type,
    required this.lastModified,
    required this.collaborators,
    required this.isBeingEdited,
  });
}

class ProjectRoom {
  final String id;
  final String name;

  ProjectRoom({
    required this.id,
    required this.name,
  });
}

enum MessageType { text, voice, location, file }
