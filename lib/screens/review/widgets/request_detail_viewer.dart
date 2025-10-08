import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../models/user_role.dart';
import '../../../models/review/state_request.dart';
import '../widgets/sla_timer_widget.dart';

class RequestDetailViewer extends StatefulWidget {
  final StateRequest request;
  final UserRole userRole;
  final Function(StateRequest, StateRequestStatus, String) onDecision;
  final Function(StateRequest, String) onComment;

  const RequestDetailViewer({
    super.key,
    required this.request,
    required this.userRole,
    required this.onDecision,
    required this.onComment,
  });

  @override
  State<RequestDetailViewer> createState() => _RequestDetailViewerState();
}

class _RequestDetailViewerState extends State<RequestDetailViewer>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _rationaleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _commentController.dispose();
    _rationaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[50],
      child: Column(
        children: [
          _buildHeader(),
          _buildTabs(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildDocumentsTab(),
                _buildTimelineTab(),
                _buildDecisionTab(),
              ],
            ),
          ),
        ],
      ),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(widget.request.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  widget.request.id,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: _getStatusColor(widget.request.status),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getPriorityColor(widget.request.priority).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  widget.request.priority.name.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: _getPriorityColor(widget.request.priority),
                  ),
                ),
              ),
              const Spacer(),
              if (widget.request.reviewDeadline != null)
                SLATimerWidget(
                  startTime: widget.request.submittedDate,
                  deadline: widget.request.reviewDeadline!,
                  size: SLATimerSize.medium,
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            widget.request.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'From: ${widget.request.stateName}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: widget.request.completenessScore,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              widget.request.completenessScore >= 0.8 ? Colors.green :
              widget.request.completenessScore >= 0.5 ? Colors.orange : Colors.red,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Completeness: ${(widget.request.completenessScore * 100).toInt()}%',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        indicatorColor: Theme.of(context).primaryColor,
        labelColor: Theme.of(context).primaryColor,
        unselectedLabelColor: Colors.grey[600],
        tabs: const [
          Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Symbols.overview, size: 16),
                SizedBox(width: 8),
                Text('Overview'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Symbols.folder, size: 16),
                SizedBox(width: 8),
                Text('Documents'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Symbols.timeline, size: 16),
                SizedBox(width: 8),
                Text('Timeline'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Symbols.gavel, size: 16),
                SizedBox(width: 8),
                Text('Decision'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Request Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.request.description,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 16),
                  _buildDetailRow('Type', widget.request.type.name),
                  _buildDetailRow('Submitted By', widget.request.submitterName),
                  _buildDetailRow('Role', widget.request.submitterRole),
                  _buildDetailRow('Submitted Date', _formatDateTime(widget.request.submittedDate)),
                  if (widget.request.reviewDeadline != null)
                    _buildDetailRow('Review Deadline', _formatDateTime(widget.request.reviewDeadline!)),
                  _buildDetailRow('SLA Hours', '${widget.request.slaHours} hours'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (widget.request.requestData.isNotEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Additional Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...widget.request.requestData.entries.map((entry) =>
                      _buildDetailRow(entry.key, entry.value.toString())),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDocumentsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Required Documents',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...widget.request.requiredDocuments.map((doc) => 
                    _buildRequiredDocumentItem(doc)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Attached Documents',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (widget.request.attachedDocuments.isEmpty)
                    const Text('No documents attached')
                  else
                    ...widget.request.attachedDocuments.map((doc) => 
                      _buildAttachedDocumentItem(doc)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Request Timeline',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildTimelineItem(
                'Submitted',
                widget.request.submittedDate,
                'Request submitted by ${widget.request.submitterName}',
                true,
              ),
              if (widget.request.reviewerId != null)
                _buildTimelineItem(
                  'Under Review',
                  widget.request.lastUpdated ?? widget.request.submittedDate,
                  'Assigned to ${widget.request.reviewerName}',
                  true,
                ),
              if (widget.request.isEscalated && widget.request.escalatedAt != null)
                _buildTimelineItem(
                  'Escalated',
                  widget.request.escalatedAt!,
                  'Escalated to ${widget.request.escalatedTo}',
                  true,
                ),
              if (widget.request.approvedDate != null)
                _buildTimelineItem(
                  widget.request.status == StateRequestStatus.approved ? 'Approved' : 'Completed',
                  widget.request.approvedDate!,
                  'Request ${widget.request.status.name}',
                  true,
                ),
              const SizedBox(height: 16),
              const Text(
                'Comments',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...widget.request.comments.map((comment) => 
                _buildCommentItem(comment)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDecisionTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Decision Controls',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _rationaleController,
                    decoration: const InputDecoration(
                      labelText: 'Decision Rationale *',
                      hintText: 'Provide detailed reasoning for your decision',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 4,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _makeDecision(StateRequestStatus.approved),
                          icon: const Icon(Symbols.check_circle),
                          label: const Text('Approve'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _makeDecision(StateRequestStatus.onHold),
                          icon: const Icon(Symbols.pause_circle),
                          label: const Text('On Hold'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _makeDecision(StateRequestStatus.disapproved),
                          icon: const Icon(Symbols.cancel),
                          label: const Text('Disapprove'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add Comment',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: 'Add a comment or ask for clarification...',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => _commentController.clear(),
                        child: const Text('Clear'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _addComment,
                        child: const Text('Add Comment'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequiredDocumentItem(String docName) {
    final isAttached = widget.request.attachedDocuments
        .any((doc) => doc.name.toLowerCase().contains(docName.toLowerCase()));
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            isAttached ? Symbols.check_circle : Symbols.radio_button_unchecked,
            size: 16,
            color: isAttached ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              docName,
              style: TextStyle(
                color: isAttached ? Colors.black : Colors.grey[600],
                decoration: isAttached ? null : TextDecoration.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachedDocumentItem(StateRequestDocument doc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(
            Symbols.attach_file,
            size: 20,
            color: Colors.blue[600],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doc.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${doc.fileName} • ${_formatFileSize(doc.fileSizeBytes)} • v${doc.version}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          if (doc.isVerified)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'VERIFIED',
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Symbols.download, size: 16),
            onPressed: () => _downloadDocument(doc),
          ),
        ],
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

  Widget _buildCommentItem(StateRequestComment comment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
              Text(
                comment.authorName,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                comment.authorRole,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const Spacer(),
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
        ],
      ),
    );
  }

  Color _getStatusColor(StateRequestStatus status) {
    switch (status) {
      case StateRequestStatus.submitted:
        return Colors.blue;
      case StateRequestStatus.underReview:
        return Colors.orange;
      case StateRequestStatus.onHold:
        return Colors.amber;
      case StateRequestStatus.approved:
        return Colors.green;
      case StateRequestStatus.disapproved:
        return Colors.red;
      case StateRequestStatus.requiresInfo:
        return Colors.purple;
    }
  }

  Color _getPriorityColor(StateRequestPriority priority) {
    switch (priority) {
      case StateRequestPriority.low:
        return Colors.green;
      case StateRequestPriority.medium:
        return Colors.blue;
      case StateRequestPriority.high:
        return Colors.orange;
      case StateRequestPriority.urgent:
        return Colors.red;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
  }

  void _makeDecision(StateRequestStatus decision) {
    if (_rationaleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please provide a rationale for your decision'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    widget.onDecision(widget.request, decision, _rationaleController.text.trim());
    _rationaleController.clear();
  }

  void _addComment() {
    if (_commentController.text.trim().isEmpty) return;

    widget.onComment(widget.request, _commentController.text.trim());
    _commentController.clear();
  }

  void _downloadDocument(StateRequestDocument doc) {
    // Implement document download
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Downloading ${doc.fileName}...')),
    );
  }
}
