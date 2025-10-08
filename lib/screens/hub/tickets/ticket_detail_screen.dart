import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../models/user_role.dart';
import '../../../models/hub/ticket.dart';

class TicketDetailScreen extends StatefulWidget {
  final Ticket ticket;
  final UserRole userRole;

  const TicketDetailScreen({
    super.key,
    required this.ticket,
    required this.userRole,
  });

  @override
  State<TicketDetailScreen> createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends State<TicketDetailScreen> {
  final TextEditingController _commentController = TextEditingController();
  late Ticket _ticket;

  @override
  void initState() {
    super.initState();
    _ticket = widget.ticket;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ticket #${_ticket.id}'),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Symbols.edit),
            onPressed: () => _editTicket(),
            tooltip: 'Edit ticket',
          ),
          PopupMenuButton<String>(
            onSelected: _handleMenuAction,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'assign',
                child: Row(
                  children: [
                    Icon(Symbols.assignment_ind),
                    SizedBox(width: 8),
                    Text('Assign'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'escalate',
                child: Row(
                  children: [
                    Icon(Symbols.priority_high),
                    SizedBox(width: 8),
                    Text('Escalate'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'close',
                child: Row(
                  children: [
                    Icon(Symbols.check_circle),
                    SizedBox(width: 8),
                    Text('Close'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTicketHeader(),
                  const SizedBox(height: 24),
                  _buildTicketDetails(),
                  const SizedBox(height: 24),
                  _buildStatusTimeline(),
                  const SizedBox(height: 24),
                  _buildComments(),
                ],
              ),
            ),
          ),
          _buildCommentInput(),
        ],
      ),
    );
  }

  Widget _buildTicketHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(_ticket.status.name).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getStatusLabel(_ticket.status.name),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: _getStatusColor(_ticket.status.name),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(_ticket.category).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _ticket.category.name.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: _getCategoryColor(_ticket.category),
                    ),
                  ),
                ),
                const Spacer(),
                _buildPriorityIndicator(_ticket.priority),
                if (_ticket.isEscalated) ...[
                  const SizedBox(width: 8),
                  Icon(
                    Symbols.priority_high,
                    size: 20,
                    color: Colors.red[600],
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),
            Text(
              _ticket.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _ticket.description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
            if (_ticket.attachments.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildAttachments(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTicketDetails() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ticket Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Submitted by', _ticket.submitterName, _ticket.submitterRole),
            if (_ticket.assigneeName != null)
              _buildDetailRow('Assigned to', _ticket.assigneeName!, _ticket.assigneeRole!),
            _buildDetailRow('Created', _formatDateTime(_ticket.createdAt), null),
            _buildDetailRow('Last updated', _formatDateTime(_ticket.updatedAt), null),
            if (_ticket.dueDate != null)
              _buildDetailRow('Due date', _formatDateTime(_ticket.dueDate!), null),
            if (_ticket.resolvedAt != null)
              _buildDetailRow('Resolved', _formatDateTime(_ticket.resolvedAt!), null),
            _buildDetailRow('SLA', '${_ticket.slaHours} hours', null),
            if (_ticket.contextType != null && _ticket.contextId != null)
              _buildDetailRow('Context', '${_ticket.contextType}: ${_ticket.contextId}', null),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, String? subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTimeline() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Status Timeline',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildTimelineItem(
              'Created',
              _ticket.createdAt,
              'Ticket created by ${_ticket.submitterName}',
              true,
            ),
            if (_ticket.assigneeName != null)
              _buildTimelineItem(
                'Assigned',
                _ticket.updatedAt,
                'Assigned to ${_ticket.assigneeName}',
                true,
              ),
            if (_ticket.isEscalated && _ticket.escalatedAt != null)
              _buildTimelineItem(
                'Escalated',
                _ticket.escalatedAt!,
                'Escalated to ${_ticket.escalatedTo}',
                true,
              ),
            if (_ticket.resolvedAt != null)
              _buildTimelineItem(
                'Resolved',
                _ticket.resolvedAt!,
                'Ticket resolved',
                true,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem(String title, DateTime timestamp, String description, bool isCompleted) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: isCompleted ? Theme.of(context).primaryColor : Colors.grey[300],
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            Container(
              width: 2,
              height: 40,
              color: Colors.grey[200],
            ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                _formatDateTime(timestamp),
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[500],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildComments() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Comments (${_ticket.comments.length})',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (_ticket.comments.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text(
                    'No comments yet',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 14,
                    ),
                  ),
                ),
              )
            else
              ...(_ticket.comments.map((comment) => _buildCommentItem(comment))),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentItem(TicketComment comment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Theme.of(context).primaryColor,
                child: Text(
                  comment.authorName.substring(0, 1).toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.authorName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      comment.authorRole,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                _formatDateTime(comment.createdAt),
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            comment.content,
            style: const TextStyle(fontSize: 14),
          ),
          if (comment.attachments.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: comment.attachments.map((attachment) {
                return Chip(
                  avatar: const Icon(Symbols.attach_file, size: 16),
                  label: Text(
                    attachment.split('/').last,
                    style: const TextStyle(fontSize: 10),
                  ),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCommentInput() {
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
          Expanded(
            child: TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: 'Add a comment...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              maxLines: null,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Symbols.attach_file),
            onPressed: () => _attachFile(),
          ),
          ElevatedButton(
            onPressed: _commentController.text.isNotEmpty ? _addComment : null,
            child: const Text('Comment'),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachments() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Attachments',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _ticket.attachments.map((attachment) {
            return Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
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
                  const SizedBox(width: 4),
                  InkWell(
                    onTap: () => _downloadAttachment(attachment),
                    child: const Icon(Symbols.download, size: 16),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPriorityIndicator(TicketPriority priority) {
    Color color;
    IconData icon;
    String label;
    
    switch (priority) {
      case TicketPriority.critical:
        color = Colors.red;
        icon = Symbols.priority_high;
        label = 'Critical';
        break;
      case TicketPriority.high:
        color = Colors.orange;
        icon = Symbols.keyboard_arrow_up;
        label = 'High';
        break;
      case TicketPriority.medium:
        color = Colors.blue;
        icon = Symbols.remove;
        label = 'Medium';
        break;
      case TicketPriority.low:
        color = Colors.green;
        icon = Symbols.keyboard_arrow_down;
        label = 'Low';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'open':
        return Colors.orange;
      case 'inProgress':
        return Colors.blue;
      case 'awaitingInfo':
        return Colors.amber;
      case 'resolved':
        return Colors.green;
      case 'closed':
        return Colors.grey;
      case 'escalated':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'open':
        return 'Open';
      case 'inProgress':
        return 'In Progress';
      case 'awaitingInfo':
        return 'Awaiting Info';
      case 'resolved':
        return 'Resolved';
      case 'closed':
        return 'Closed';
      case 'escalated':
        return 'Escalated';
      default:
        return status;
    }
  }

  Color _getCategoryColor(TicketCategory category) {
    switch (category) {
      case TicketCategory.technical:
        return Colors.blue;
      case TicketCategory.financial:
        return Colors.green;
      case TicketCategory.administrative:
        return Colors.orange;
      case TicketCategory.policy:
        return Colors.purple;
      case TicketCategory.grievance:
        return Colors.red;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _editTicket() {
    // Navigate to edit ticket screen
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'assign':
        _showAssignDialog();
        break;
      case 'escalate':
        _escalateTicket();
        break;
      case 'close':
        _closeTicket();
        break;
    }
  }

  void _showAssignDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Assign Ticket'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Assignee',
                hintText: 'Search users...',
              ),
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
              // Assign ticket
            },
            child: const Text('Assign'),
          ),
        ],
      ),
    );
  }

  void _escalateTicket() {
    setState(() {
      _ticket = _ticket.copyWith(
        isEscalated: true,
        escalatedAt: DateTime.now(),
        escalatedTo: 'higher_authority',
        status: TicketStatus.escalated,
      );
    });
  }

  void _closeTicket() {
    setState(() {
      _ticket = _ticket.copyWith(
        status: TicketStatus.closed,
        resolvedAt: DateTime.now(),
      );
    });
  }

  void _addComment() {
    if (_commentController.text.trim().isEmpty) return;

    final comment = TicketComment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      ticketId: _ticket.id,
      authorId: 'current_user',
      authorName: 'Current User',
      authorRole: widget.userRole.name,
      content: _commentController.text.trim(),
      createdAt: DateTime.now(),
    );

    setState(() {
      _ticket = _ticket.copyWith(
        comments: [..._ticket.comments, comment],
        updatedAt: DateTime.now(),
      );
      _commentController.clear();
    });
  }

  void _attachFile() {
    // Show file picker
  }

  void _downloadAttachment(String attachment) {
    // Download attachment
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
