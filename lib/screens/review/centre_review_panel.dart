import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../models/user_role.dart';
import '../../models/review/state_request.dart';
import '../../models/review/fund_transparency.dart';
import 'widgets/request_detail_viewer.dart';
import 'widgets/fund_transparency_panel.dart';
import 'widgets/sla_timer_widget.dart';

class CentreReviewPanel extends StatefulWidget {
  final UserRole userRole;

  const CentreReviewPanel({
    super.key,
    required this.userRole,
  });

  @override
  State<CentreReviewPanel> createState() => _CentreReviewPanelState();
}

class _CentreReviewPanelState extends State<CentreReviewPanel>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'all';
  String _selectedSort = 'submitted_desc';
  StateRequest? _selectedRequest;
  final List<StateRequest> _requests = _getDemoRequests();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Symbols.account_balance,
                color: Colors.blue,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Centre Review Panel',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'State Participation Requests & Fund Oversight',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.blue,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey[600],
          tabs: [
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Symbols.assignment, size: 20),
                  const SizedBox(width: 8),
                  const Text('State Requests'),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${_requests.where((r) => r.status == StateRequestStatus.submitted || r.status == StateRequestStatus.underReview).length}',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
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
                  Icon(Symbols.account_balance_wallet, size: 20),
                  SizedBox(width: 8),
                  Text('Fund Transparency'),
                ],
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRequestsTab(),
          FundTransparencyPanel(
            level: 'centre',
            levelId: 'centre_001',
            levelName: 'Centre',
            userRole: widget.userRole,
          ),
        ],
      ),
    );
  }

  Widget _buildRequestsTab() {
    return Row(
      children: [
        // Requests List
        Container(
          width: 400,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              right: BorderSide(color: Colors.grey[300]!),
            ),
          ),
          child: Column(
            children: [
              _buildRequestsHeader(),
              _buildFiltersAndSort(),
              Expanded(
                child: _buildRequestsList(),
              ),
            ],
          ),
        ),
        // Request Detail Viewer
        Expanded(
          child: _selectedRequest != null
              ? RequestDetailViewer(
                  request: _selectedRequest!,
                  userRole: widget.userRole,
                  onDecision: _handleDecision,
                  onComment: _handleComment,
                )
              : _buildEmptyDetailView(),
        ),
      ],
    );
  }

  Widget _buildRequestsHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        children: [
          const Text(
            'Incoming Requests',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          _buildRequestStats(),
        ],
      ),
    );
  }

  Widget _buildRequestStats() {
    final stats = _calculateRequestStats();
    return Row(
      children: [
        _buildStatChip('Pending', stats['pending']!, Colors.orange),
        const SizedBox(width: 8),
        _buildStatChip('Overdue', stats['overdue']!, Colors.red),
        const SizedBox(width: 8),
        _buildStatChip('Today', stats['today']!, Colors.blue),
      ],
    );
  }

  Widget _buildStatChip(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(width: 2),
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

  Widget _buildFiltersAndSort() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.grey[50],
      child: Row(
        children: [
          Expanded(
            child: DropdownButton<String>(
              value: _selectedFilter,
              isExpanded: true,
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All Requests')),
                DropdownMenuItem(value: 'submitted', child: Text('Submitted')),
                DropdownMenuItem(value: 'underReview', child: Text('Under Review')),
                DropdownMenuItem(value: 'onHold', child: Text('On Hold')),
                DropdownMenuItem(value: 'overdue', child: Text('Overdue')),
                DropdownMenuItem(value: 'high_priority', child: Text('High Priority')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedFilter = value!;
                });
              },
              underline: const SizedBox(),
            ),
          ),
          const SizedBox(width: 16),
          DropdownButton<String>(
            value: _selectedSort,
            items: const [
              DropdownMenuItem(value: 'submitted_desc', child: Text('Newest First')),
              DropdownMenuItem(value: 'submitted_asc', child: Text('Oldest First')),
              DropdownMenuItem(value: 'priority_desc', child: Text('High Priority')),
              DropdownMenuItem(value: 'deadline_asc', child: Text('Due Soon')),
              DropdownMenuItem(value: 'completeness_desc', child: Text('Most Complete')),
            ],
            onChanged: (value) {
              setState(() {
                _selectedSort = value!;
              });
            },
            underline: const SizedBox(),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestsList() {
    final filteredRequests = _getFilteredRequests();
    
    if (filteredRequests.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Symbols.assignment,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No requests found',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: filteredRequests.length,
      itemBuilder: (context, index) {
        final request = filteredRequests[index];
        return _buildRequestCard(request);
      },
    );
  }

  Widget _buildRequestCard(StateRequest request) {
    final isSelected = _selectedRequest?.id == request.id;
    final isOverdue = request.reviewDeadline != null &&
        DateTime.now().isAfter(request.reviewDeadline!);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: isSelected ? 4 : 1,
      color: isSelected ? Colors.blue[50] : Colors.white,
      child: InkWell(
        onTap: () => setState(() => _selectedRequest = request),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: _getStatusColor(request.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      request.id,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: _getStatusColor(request.status),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: _getPriorityColor(request.priority).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      request.priority.name.toUpperCase(),
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        color: _getPriorityColor(request.priority),
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (isOverdue)
                    Icon(
                      Symbols.schedule,
                      size: 16,
                      color: Colors.red[600],
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                request.title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                request.stateName,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
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
                    _formatTimestamp(request.submittedDate),
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[500],
                    ),
                  ),
                  const Spacer(),
                  if (request.reviewDeadline != null)
                    SLATimerWidget(
                      startTime: request.submittedDate,
                      deadline: request.reviewDeadline!,
                      size: SLATimerSize.small,
                    ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: request.completenessScore,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  request.completenessScore >= 0.8 ? Colors.green :
                  request.completenessScore >= 0.5 ? Colors.orange : Colors.red,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${(request.completenessScore * 100).toInt()}% Complete',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyDetailView() {
    return Container(
      color: Colors.grey[50],
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Symbols.assignment,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'Select a request to view details',
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

  Map<String, int> _calculateRequestStats() {
    final now = DateTime.now();
    return {
      'pending': _requests.where((r) => 
          r.status == StateRequestStatus.submitted || 
          r.status == StateRequestStatus.underReview).length,
      'overdue': _requests.where((r) => 
          r.reviewDeadline != null && now.isAfter(r.reviewDeadline!)).length,
      'today': _requests.where((r) => 
          r.submittedDate.day == now.day &&
          r.submittedDate.month == now.month &&
          r.submittedDate.year == now.year).length,
    };
  }

  List<StateRequest> _getFilteredRequests() {
    var filtered = _requests.where((request) {
      switch (_selectedFilter) {
        case 'submitted':
          return request.status == StateRequestStatus.submitted;
        case 'underReview':
          return request.status == StateRequestStatus.underReview;
        case 'onHold':
          return request.status == StateRequestStatus.onHold;
        case 'overdue':
          return request.reviewDeadline != null &&
              DateTime.now().isAfter(request.reviewDeadline!);
        case 'high_priority':
          return request.priority == StateRequestPriority.high ||
              request.priority == StateRequestPriority.urgent;
        default:
          return true;
      }
    }).toList();

    // Sort
    switch (_selectedSort) {
      case 'submitted_desc':
        filtered.sort((a, b) => b.submittedDate.compareTo(a.submittedDate));
        break;
      case 'submitted_asc':
        filtered.sort((a, b) => a.submittedDate.compareTo(b.submittedDate));
        break;
      case 'priority_desc':
        filtered.sort((a, b) => b.priority.index.compareTo(a.priority.index));
        break;
      case 'deadline_asc':
        filtered.sort((a, b) {
          if (a.reviewDeadline == null && b.reviewDeadline == null) return 0;
          if (a.reviewDeadline == null) return 1;
          if (b.reviewDeadline == null) return -1;
          return a.reviewDeadline!.compareTo(b.reviewDeadline!);
        });
        break;
      case 'completeness_desc':
        filtered.sort((a, b) => b.completenessScore.compareTo(a.completenessScore));
        break;
    }

    return filtered;
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

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  void _handleDecision(StateRequest request, StateRequestStatus decision, String rationale) {
    setState(() {
      _selectedRequest = request.copyWith(
        status: decision,
        reviewerId: 'centre_admin_001',
        reviewerName: 'Centre Admin',
        decisionRationale: rationale,
        approvedDate: decision == StateRequestStatus.approved ? DateTime.now() : null,
        lastUpdated: DateTime.now(),
      );
      
      // Update in the list
      final index = _requests.indexWhere((r) => r.id == request.id);
      if (index != -1) {
        _requests[index] = _selectedRequest!;
      }
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Request ${decision.name} successfully'),
        backgroundColor: decision == StateRequestStatus.approved ? Colors.green : Colors.orange,
      ),
    );
  }

  void _handleComment(StateRequest request, String comment) {
    final newComment = StateRequestComment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      requestId: request.id,
      authorId: 'centre_admin_001',
      authorName: 'Centre Admin',
      authorRole: 'Centre Admin',
      content: comment,
      createdAt: DateTime.now(),
      isInternal: true,
    );

    setState(() {
      _selectedRequest = request.copyWith(
        comments: [...request.comments, newComment],
        lastUpdated: DateTime.now(),
      );
      
      // Update in the list
      final index = _requests.indexWhere((r) => r.id == request.id);
      if (index != -1) {
        _requests[index] = _selectedRequest!;
      }
    });
  }

  static List<StateRequest> _getDemoRequests() {
    final now = DateTime.now();
    return [
      StateRequest(
        id: 'REQ001',
        stateId: 'MH',
        stateName: 'Maharashtra',
        type: StateRequestType.participation,
        status: StateRequestStatus.submitted,
        priority: StateRequestPriority.high,
        title: 'PM-AJAY Scheme Participation Request',
        description: 'Maharashtra state requests participation in PM-AJAY scheme with focus on rural development and hostel infrastructure.',
        submitterId: 'mh_officer_001',
        submitterName: 'Rajesh Kumar',
        submitterRole: 'State Officer',
        submittedDate: now.subtract(const Duration(days: 2)),
        reviewDeadline: now.add(const Duration(days: 1)),
        slaHours: 72,
        completenessScore: 0.85,
        requiredDocuments: [
          'Organizational Chart',
          'Budget Proposal',
          'Feasibility Study',
          'Officer Credentials',
        ],
        attachedDocuments: [
          StateRequestDocument(
            id: 'doc_001',
            requestId: 'REQ001',
            name: 'Maharashtra Organizational Chart',
            type: 'hierarchy',
            fileUrl: '/documents/mh_org_chart.pdf',
            fileName: 'mh_org_chart.pdf',
            fileSizeBytes: 2048576,
            uploadedAt: now.subtract(const Duration(days: 1)),
            uploadedBy: 'mh_officer_001',
            isRequired: true,
            isVerified: true,
          ),
        ],
        requestData: {
          'proposed_budget': 50000000,
          'target_districts': 15,
          'expected_beneficiaries': 25000,
        },
      ),
      StateRequest(
        id: 'REQ002',
        stateId: 'GJ',
        stateName: 'Gujarat',
        type: StateRequestType.budgetIncrease,
        status: StateRequestStatus.underReview,
        priority: StateRequestPriority.medium,
        title: 'Budget Increase for Hostel Infrastructure',
        description: 'Request for additional budget allocation for hostel infrastructure development in Gujarat.',
        submitterId: 'gj_officer_001',
        submitterName: 'Priya Patel',
        submitterRole: 'State Officer',
        submittedDate: now.subtract(const Duration(days: 5)),
        reviewDeadline: now.add(const Duration(days: 2)),
        reviewerId: 'centre_admin_001',
        reviewerName: 'Centre Admin',
        slaHours: 168,
        completenessScore: 0.65,
        requiredDocuments: [
          'Revised Budget Proposal',
          'Justification Report',
          'NIRF Certificates',
        ],
        requestData: {
          'current_allocation': 20000000,
          'requested_increase': 10000000,
          'additional_colleges': 3,
        },
      ),
      StateRequest(
        id: 'REQ003',
        stateId: 'UP',
        stateName: 'Uttar Pradesh',
        type: StateRequestType.fundRelease,
        status: StateRequestStatus.onHold,
        priority: StateRequestPriority.urgent,
        title: 'Emergency Fund Release Request',
        description: 'Urgent request for fund release due to pending contractor payments.',
        submitterId: 'up_officer_001',
        submitterName: 'Amit Singh',
        submitterRole: 'State Officer',
        submittedDate: now.subtract(const Duration(hours: 6)),
        reviewDeadline: now.add(const Duration(hours: 18)),
        slaHours: 24,
        completenessScore: 0.45,
        isEscalated: true,
        escalatedAt: now.subtract(const Duration(hours: 2)),
        escalatedTo: 'centre_admin_001',
        requiredDocuments: [
          'Contractor Agreements',
          'Payment Schedules',
          'Work Completion Certificates',
        ],
        requestData: {
          'pending_amount': 15000000,
          'affected_projects': 8,
          'contractor_count': 12,
        },
      ),
    ];
  }
}
