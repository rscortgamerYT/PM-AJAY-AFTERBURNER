import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class CollaborativeWorkspace extends StatefulWidget {
  final String documentId;
  final String userRole;
  final List<String> collaborators;

  const CollaborativeWorkspace({
    super.key,
    required this.documentId,
    required this.userRole,
    this.collaborators = const [],
  });

  @override
  State<CollaborativeWorkspace> createState() => _CollaborativeWorkspaceState();
}

class _CollaborativeWorkspaceState extends State<CollaborativeWorkspace>
    with TickerProviderStateMixin {
  final TextEditingController _documentController = TextEditingController();
  final List<UserCursor> _activeCursors = [];
  final List<CollaborativeChange> _recentChanges = [];
  final List<Comment> _comments = [];
  late AnimationController _cursorBlinkController;
  Timer? _syncTimer;
  bool _isConnected = true;
  int _activeUsers = 3;

  @override
  void initState() {
    super.initState();
    _cursorBlinkController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);
    
    _initializeDocument();
    _startRealTimeSync();
    _simulateCollaborators();
  }

  @override
  void dispose() {
    _cursorBlinkController.dispose();
    _syncTimer?.cancel();
    _documentController.dispose();
    super.dispose();
  }

  void _initializeDocument() {
    _documentController.text = '''PM-AJAY Project Proposal: Rural Infrastructure Development

Project Overview:
This project aims to develop rural infrastructure in Maharashtra state, focusing on road connectivity, water supply, and digital infrastructure.

Objectives:
1. Improve road connectivity to 50 villages
2. Establish clean water supply systems
3. Set up digital infrastructure for e-governance

Budget Allocation:
- Road Development: ₹500 Cr
- Water Supply: ₹300 Cr  
- Digital Infrastructure: ₹200 Cr
- Total: ₹1000 Cr

Timeline: 24 months

Status: Under Review
''';
  }

  void _startRealTimeSync() {
    _syncTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _simulateRemoteChanges();
      _updateActiveCursors();
    });
  }

  void _simulateCollaborators() {
    // Simulate other users working on the document
    _activeCursors.addAll([
      UserCursor(
        userId: 'state_officer_1',
        userName: 'Priya Sharma (State Officer)',
        x: 100,
        y: 200,
        color: Colors.blue,
      ),
      UserCursor(
        userId: 'agency_user_1',
        userName: 'Rajesh Kumar (Agency)',
        x: 150,
        y: 300,
        color: Colors.green,
      ),
    ]);
  }

  void _simulateRemoteChanges() {
    if (Random().nextBool()) {
      final changes = [
        'State Officer updated budget allocation',
        'Agency User added implementation details',
        'Auditor reviewed compliance requirements',
        'Centre Admin approved preliminary proposal',
      ];
      
      setState(() {
        _recentChanges.insert(0, CollaborativeChange(
          userId: 'user_${Random().nextInt(100)}',
          userName: ['Priya Sharma', 'Rajesh Kumar', 'Dr. Singh', 'Admin'][Random().nextInt(4)],
          action: changes[Random().nextInt(changes.length)],
          timestamp: DateTime.now(),
        ));
        
        if (_recentChanges.length > 10) {
          _recentChanges.removeLast();
        }
      });
    }
  }

  void _updateActiveCursors() {
    setState(() {
      for (var cursor in _activeCursors) {
        cursor.x += (Random().nextDouble() - 0.5) * 20;
        cursor.y += (Random().nextDouble() - 0.5) * 20;
        cursor.x = cursor.x.clamp(50.0, 300.0);
        cursor.y = cursor.y.clamp(100.0, 400.0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildCollaborativeAppBar(),
      body: Row(
        children: [
          // Main document editor
          Expanded(
            flex: 3,
            child: _buildDocumentEditor(),
          ),
          
          // Collaboration sidebar
          Container(
            width: 300,
            decoration: BoxDecoration(
              color: Colors.grey[50],
              border: const Border(left: BorderSide(color: Colors.grey)),
            ),
            child: _buildCollaborationSidebar(),
          ),
        ],
      ),
      floatingActionButton: _buildCollaborationFABs(),
    );
  }

  PreferredSizeWidget _buildCollaborativeAppBar() {
    return AppBar(
      title: Row(
        children: [
          const Text('Collaborative Document'),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _isConnected ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _isConnected ? Icons.wifi : Icons.wifi_off,
                  size: 16,
                  color: Colors.white,
                ),
                const SizedBox(width: 4),
                Text(
                  _isConnected ? 'Connected' : 'Offline',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        // Active users indicator
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: Colors.blue[100],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  const Icon(Icons.people, size: 20, color: Colors.blue),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 4),
              Text(
                '$_activeUsers',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
        
        // Share button
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: _showShareDialog,
          tooltip: 'Share Document',
        ),
        
        // Video call button
        IconButton(
          icon: const Icon(Icons.video_call),
          onPressed: _startVideoCall,
          tooltip: 'Start Video Call',
        ),
      ],
    );
  }

  Widget _buildDocumentEditor() {
    return Stack(
      children: [
        // Main text editor
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _documentController,
            onChanged: _handleTextChange,
            maxLines: null,
            expands: true,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Start typing your document...',
            ),
          ),
        ),
        
        // Live cursors overlay
        ..._activeCursors.map((cursor) => Positioned(
          left: cursor.x,
          top: cursor.y,
          child: _buildLiveCursor(cursor),
        )).toList(),
        
        // Comments overlay
        ..._comments.map((comment) => Positioned(
          left: comment.x,
          top: comment.y,
          child: _buildCommentBubble(comment),
        )).toList(),
      ],
    );
  }

  Widget _buildLiveCursor(UserCursor cursor) {
    return AnimatedBuilder(
      animation: _cursorBlinkController,
      builder: (context, child) {
        return Opacity(
          opacity: 0.3 + _cursorBlinkController.value * 0.7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User name tag
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: cursor.color,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  cursor.userName.split(' ')[0], // First name only
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              
              // Cursor line
              Container(
                width: 2,
                height: 20,
                color: cursor.color,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCommentBubble(Comment comment) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.yellow[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            comment.author,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            comment.text,
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            _formatTime(comment.timestamp),
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollaborationSidebar() {
    return Column(
      children: [
        // Active collaborators
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Active Collaborators',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ..._activeCursors.map((cursor) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: cursor.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        cursor.userName,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              )).toList(),
            ],
          ),
        ),
        
        // Recent changes
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Recent Changes',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    itemCount: _recentChanges.length,
                    itemBuilder: (context, index) {
                      final change = _recentChanges[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              change.userName,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              change.action,
                              style: const TextStyle(fontSize: 12),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _formatTime(change.timestamp),
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Quick actions
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Colors.grey)),
          ),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _addComment,
                  icon: const Icon(Icons.comment, size: 16),
                  label: const Text('Add Comment'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _saveDocument,
                  icon: const Icon(Icons.save, size: 16),
                  label: const Text('Save Changes'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCollaborationFABs() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton.small(
          onPressed: _toggleScreenShare,
          backgroundColor: Colors.purple,
          heroTag: 'screen_share',
          child: const Icon(Icons.screen_share, color: Colors.white),
        ),
        const SizedBox(height: 8),
        FloatingActionButton.small(
          onPressed: _openWhiteboard,
          backgroundColor: Colors.indigo,
          heroTag: 'whiteboard',
          child: const Icon(Icons.draw, color: Colors.white),
        ),
      ],
    );
  }

  void _handleTextChange(String text) {
    // Simulate real-time text synchronization
    // In a real app, this would send changes to other collaborators
  }

  void _addComment() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Comment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: 'Your comment',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _comments.add(Comment(
                  id: 'comment_${DateTime.now().millisecondsSinceEpoch}',
                  author: 'You (${widget.userRole})',
                  text: 'This section needs review for compliance.',
                  x: 200,
                  y: 250,
                  timestamp: DateTime.now(),
                ));
              });
              Navigator.pop(context);
            },
            child: const Text('Add Comment'),
          ),
        ],
      ),
    );
  }

  void _saveDocument() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Document saved and synced with all collaborators'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showShareDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Share Document'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: 'Email address',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Permission level',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'view', child: Text('View only')),
                DropdownMenuItem(value: 'comment', child: Text('Can comment')),
                DropdownMenuItem(value: 'edit', child: Text('Can edit')),
              ],
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Invitation sent!')),
              );
            },
            child: const Text('Send Invitation'),
          ),
        ],
      ),
    );
  }

  void _startVideoCall() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Start Video Call'),
        content: const Text('Starting video conference with all active collaborators...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Video call started - Feature coming soon!'),
                  backgroundColor: Colors.blue,
                ),
              );
            },
            child: const Text('Join Call'),
          ),
        ],
      ),
    );
  }

  void _toggleScreenShare() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Screen sharing - Feature coming soon!'),
        backgroundColor: Colors.purple,
      ),
    );
  }

  void _openWhiteboard() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Digital whiteboard - Feature coming soon!'),
        backgroundColor: Colors.indigo,
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}

class UserCursor {
  final String userId;
  final String userName;
  double x;
  double y;
  final Color color;

  UserCursor({
    required this.userId,
    required this.userName,
    required this.x,
    required this.y,
    required this.color,
  });
}

class CollaborativeChange {
  final String userId;
  final String userName;
  final String action;
  final DateTime timestamp;

  CollaborativeChange({
    required this.userId,
    required this.userName,
    required this.action,
    required this.timestamp,
  });
}

class Comment {
  final String id;
  final String author;
  final String text;
  final double x;
  final double y;
  final DateTime timestamp;

  Comment({
    required this.id,
    required this.author,
    required this.text,
    required this.x,
    required this.y,
    required this.timestamp,
  });
}
