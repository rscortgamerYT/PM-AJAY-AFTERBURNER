import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../models/user_role.dart';
import '../../../models/hub/ticket.dart';
import 'ticket_detail_screen.dart';
import 'create_ticket_screen.dart';

class TicketsScreen extends StatefulWidget {
  final UserRole userRole;

  const TicketsScreen({
    super.key,
    required this.userRole,
  });

  @override
  State<TicketsScreen> createState() => _TicketsScreenState();
}

class _TicketsScreenState extends State<TicketsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'all';
  String _selectedSort = 'created_desc';
  final List<Ticket> _tickets = _getDemoTickets();

  final List<String> _statusTabs = [
    'all',
    'open',
    'inProgress',
    'awaitingInfo',
    'resolved',
    'escalated'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _statusTabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        _buildFiltersAndSort(),
        _buildStatusTabs(),
        Expanded(
          child: _buildTicketList(),
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
          const Icon(Symbols.support_agent, size: 24),
          const SizedBox(width: 12),
          const Text(
            'Tickets & Queries',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          _buildTicketStats(),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: () => _createNewTicket(),
            icon: const Icon(Symbols.add, size: 18),
            label: const Text('New Ticket'),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketStats() {
    final stats = _calculateStats();
    return Row(
      children: [
        _buildStatChip('Open', stats['open']!, Colors.orange),
        const SizedBox(width: 8),
        _buildStatChip('In Progress', stats['inProgress']!, Colors.blue),
        const SizedBox(width: 8),
        _buildStatChip('Escalated', stats['escalated']!, Colors.red),
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
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
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
          _buildFilterDropdown(),
          const SizedBox(width: 16),
          _buildSortDropdown(),
          const Spacer(),
          IconButton(
            icon: const Icon(Symbols.search),
            onPressed: () => _showSearch(),
            tooltip: 'Search tickets',
          ),
          IconButton(
            icon: const Icon(Symbols.filter_list),
            onPressed: () => _showAdvancedFilters(),
            tooltip: 'Advanced filters',
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown() {
    return DropdownButton<String>(
      value: _selectedFilter,
      items: const [
        DropdownMenuItem(value: 'all', child: Text('All Tickets')),
        DropdownMenuItem(value: 'my_tickets', child: Text('My Tickets')),
        DropdownMenuItem(value: 'assigned_to_me', child: Text('Assigned to Me')),
        DropdownMenuItem(value: 'technical', child: Text('Technical')),
        DropdownMenuItem(value: 'financial', child: Text('Financial')),
        DropdownMenuItem(value: 'administrative', child: Text('Administrative')),
      ],
      onChanged: (value) {
        setState(() {
          _selectedFilter = value!;
        });
      },
      underline: const SizedBox(),
    );
  }

  Widget _buildSortDropdown() {
    return DropdownButton<String>(
      value: _selectedSort,
      items: const [
        DropdownMenuItem(value: 'created_desc', child: Text('Newest First')),
        DropdownMenuItem(value: 'created_asc', child: Text('Oldest First')),
        DropdownMenuItem(value: 'priority_desc', child: Text('High Priority First')),
        DropdownMenuItem(value: 'due_date_asc', child: Text('Due Date')),
        DropdownMenuItem(value: 'updated_desc', child: Text('Recently Updated')),
      ],
      onChanged: (value) {
        setState(() {
          _selectedSort = value!;
        });
      },
      underline: const SizedBox(),
    );
  }

  Widget _buildStatusTabs() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        indicatorColor: Theme.of(context).primaryColor,
        labelColor: Theme.of(context).primaryColor,
        unselectedLabelColor: Colors.grey[600],
        tabs: _statusTabs.map((status) {
          final count = _getStatusCount(status);
          return Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_getStatusLabel(status)),
                if (count > 0) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: _getStatusColor(status).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      count.toString(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: _getStatusColor(status),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTicketList() {
    final filteredTickets = _getFilteredTickets();
    
    if (filteredTickets.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredTickets.length,
      itemBuilder: (context, index) {
        final ticket = filteredTickets[index];
        return _buildTicketCard(ticket);
      },
    );
  }

  Widget _buildTicketCard(Ticket ticket) {
    final slaProgress = _calculateSLAProgress(ticket);
    final isOverdue = slaProgress > 1.0;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: InkWell(
        onTap: () => _openTicket(ticket),
        borderRadius: BorderRadius.circular(8),
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
                      color: _getCategoryColor(ticket.category).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '#${ticket.id}',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: _getCategoryColor(ticket.category),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(ticket.status.name).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getStatusLabel(ticket.status.name),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: _getStatusColor(ticket.status.name),
                      ),
                    ),
                  ),
                  const Spacer(),
                  _buildPriorityIndicator(ticket.priority),
                  if (ticket.isEscalated) ...[
                    const SizedBox(width: 8),
                    Icon(
                      Symbols.priority_high,
                      size: 16,
                      color: Colors.red[600],
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 12),
              Text(
                ticket.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                ticket.description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Symbols.person,
                    size: 14,
                    color: Colors.grey[500],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    ticket.submitterName,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(width: 16),
                  if (ticket.assigneeName != null) ...[
                    Icon(
                      Symbols.assignment_ind,
                      size: 14,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      ticket.assigneeName!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],
                  Icon(
                    Symbols.schedule,
                    size: 14,
                    color: Colors.grey[500],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatTimestamp(ticket.createdAt),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const Spacer(),
                  if (ticket.comments.isNotEmpty) ...[
                    Icon(
                      Symbols.comment,
                      size: 14,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${ticket.comments.length}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ],
              ),
              if (ticket.dueDate != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: slaProgress.clamp(0.0, 1.0),
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isOverdue ? Colors.red : 
                          slaProgress > 0.8 ? Colors.orange : Colors.green,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isOverdue ? 'Overdue' : _formatDueDate(ticket.dueDate!),
                      style: TextStyle(
                        fontSize: 10,
                        color: isOverdue ? Colors.red : Colors.grey[600],
                        fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityIndicator(TicketPriority priority) {
    Color color;
    IconData icon;
    
    switch (priority) {
      case TicketPriority.critical:
        color = Colors.red;
        icon = Symbols.priority_high;
        break;
      case TicketPriority.high:
        color = Colors.orange;
        icon = Symbols.keyboard_arrow_up;
        break;
      case TicketPriority.medium:
        color = Colors.blue;
        icon = Symbols.remove;
        break;
      case TicketPriority.low:
        color = Colors.green;
        icon = Symbols.keyboard_arrow_down;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Icon(
        icon,
        size: 12,
        color: color,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Symbols.support_agent,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No tickets found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create a new ticket to get started',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _createNewTicket(),
            icon: const Icon(Symbols.add),
            label: const Text('Create Ticket'),
          ),
        ],
      ),
    );
  }

  Map<String, int> _calculateStats() {
    final stats = <String, int>{};
    for (final status in TicketStatus.values) {
      stats[status.name] = _tickets.where((t) => t.status == status).length;
    }
    return stats;
  }

  int _getStatusCount(String status) {
    if (status == 'all') return _tickets.length;
    return _tickets.where((t) => t.status.name == status).length;
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'all':
        return 'All';
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

  List<Ticket> _getFilteredTickets() {
    var filtered = _tickets.where((ticket) {
      // Status filter
      final currentTab = _statusTabs[_tabController.index];
      if (currentTab != 'all' && ticket.status.name != currentTab) {
        return false;
      }

      // Additional filters
      switch (_selectedFilter) {
        case 'my_tickets':
          return ticket.submitterId == 'current_user';
        case 'assigned_to_me':
          return ticket.assigneeId == 'current_user';
        case 'technical':
          return ticket.category == TicketCategory.technical;
        case 'financial':
          return ticket.category == TicketCategory.financial;
        case 'administrative':
          return ticket.category == TicketCategory.administrative;
        default:
          return true;
      }
    }).toList();

    // Sort
    switch (_selectedSort) {
      case 'created_desc':
        filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'created_asc':
        filtered.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case 'priority_desc':
        filtered.sort((a, b) => b.priority.index.compareTo(a.priority.index));
        break;
      case 'due_date_asc':
        filtered.sort((a, b) {
          if (a.dueDate == null && b.dueDate == null) return 0;
          if (a.dueDate == null) return 1;
          if (b.dueDate == null) return -1;
          return a.dueDate!.compareTo(b.dueDate!);
        });
        break;
      case 'updated_desc':
        filtered.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        break;
    }

    return filtered;
  }

  double _calculateSLAProgress(Ticket ticket) {
    if (ticket.dueDate == null) return 0.0;
    
    final now = DateTime.now();
    final totalDuration = ticket.dueDate!.difference(ticket.createdAt);
    final elapsedDuration = now.difference(ticket.createdAt);
    
    return elapsedDuration.inMilliseconds / totalDuration.inMilliseconds;
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

  String _formatDueDate(DateTime dueDate) {
    final now = DateTime.now();
    final difference = dueDate.difference(now);

    if (difference.inDays < 1) {
      return 'Due today';
    } else if (difference.inDays == 1) {
      return 'Due tomorrow';
    } else if (difference.inDays < 7) {
      return 'Due in ${difference.inDays}d';
    } else {
      return 'Due ${dueDate.day}/${dueDate.month}';
    }
  }

  void _createNewTicket() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CreateTicketScreen(userRole: widget.userRole),
      ),
    );
  }

  void _openTicket(Ticket ticket) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TicketDetailScreen(
          ticket: ticket,
          userRole: widget.userRole,
        ),
      ),
    );
  }

  void _showSearch() {
    // Implement search functionality
  }

  void _showAdvancedFilters() {
    // Implement advanced filters
  }

  static List<Ticket> _getDemoTickets() {
    final now = DateTime.now();
    return [
      Ticket(
        id: 'TKT001',
        title: 'Fund Transfer Delay - Project Alpha',
        description: 'The fund transfer for Project Alpha has been delayed for over a week. This is affecting the project timeline and agency operations.',
        category: TicketCategory.financial,
        priority: TicketPriority.high,
        status: TicketStatus.open,
        submitterId: 'agency_001',
        submitterName: 'Priya Sharma',
        submitterRole: 'Agency User',
        assigneeId: 'state_officer_001',
        assigneeName: 'Rajesh Kumar',
        assigneeRole: 'State Officer',
        contextId: 'proj_alpha',
        contextType: 'project',
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now.subtract(const Duration(hours: 6)),
        dueDate: now.add(const Duration(days: 1)),
        slaHours: 72,
        comments: [
          TicketComment(
            id: 'comment_001',
            ticketId: 'TKT001',
            authorId: 'agency_001',
            authorName: 'Priya Sharma',
            authorRole: 'Agency User',
            content: 'This is urgent as we have contractors waiting for payment.',
            createdAt: now.subtract(const Duration(hours: 12)),
          ),
        ],
      ),
      Ticket(
        id: 'TKT002',
        title: 'Technical Issue with Evidence Upload',
        description: 'Unable to upload milestone evidence photos. Getting error "File size too large" even for small images.',
        category: TicketCategory.technical,
        priority: TicketPriority.medium,
        status: TicketStatus.inProgress,
        submitterId: 'agency_002',
        submitterName: 'Amit Patel',
        submitterRole: 'Agency User',
        assigneeId: 'tech_support_001',
        assigneeName: 'Tech Support',
        assigneeRole: 'Technical Support',
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now.subtract(const Duration(hours: 2)),
        dueDate: now.add(const Duration(days: 2)),
        slaHours: 48,
        comments: [
          TicketComment(
            id: 'comment_002',
            ticketId: 'TKT002',
            authorId: 'tech_support_001',
            authorName: 'Tech Support',
            authorRole: 'Technical Support',
            content: 'We are investigating the file upload issue. Please try compressing your images for now.',
            createdAt: now.subtract(const Duration(hours: 4)),
          ),
        ],
      ),
      Ticket(
        id: 'TKT003',
        title: 'Request for Additional Hostel Allocation',
        description: 'Maharashtra state requests additional hostel allocation for 3 new NIRF-qualified colleges.',
        category: TicketCategory.administrative,
        priority: TicketPriority.medium,
        status: TicketStatus.awaitingInfo,
        submitterId: 'state_mh_001',
        submitterName: 'Rajesh Kumar',
        submitterRole: 'State Officer',
        assigneeId: 'centre_admin_001',
        assigneeName: 'Centre Admin',
        assigneeRole: 'Centre Admin',
        createdAt: now.subtract(const Duration(days: 5)),
        updatedAt: now.subtract(const Duration(days: 1)),
        dueDate: now.add(const Duration(days: 7)),
        slaHours: 168,
        comments: [
          TicketComment(
            id: 'comment_003',
            ticketId: 'TKT003',
            authorId: 'centre_admin_001',
            authorName: 'Centre Admin',
            authorRole: 'Centre Admin',
            content: 'Please provide NIRF certificates and detailed project proposals for the 3 colleges.',
            createdAt: now.subtract(const Duration(days: 2)),
          ),
        ],
      ),
      Ticket(
        id: 'TKT004',
        title: 'Audit Discrepancy - Q2 Financial Report',
        description: 'Discrepancy found in Q2 financial report. Amount mismatch between state records and central database.',
        category: TicketCategory.financial,
        priority: TicketPriority.critical,
        status: TicketStatus.escalated,
        submitterId: 'auditor_001',
        submitterName: 'Dr. Amit Verma',
        submitterRole: 'Auditor',
        assigneeId: 'centre_admin_001',
        assigneeName: 'Centre Admin',
        assigneeRole: 'Centre Admin',
        createdAt: now.subtract(const Duration(days: 7)),
        updatedAt: now.subtract(const Duration(hours: 1)),
        dueDate: now.subtract(const Duration(days: 1)), // Overdue
        slaHours: 24,
        isEscalated: true,
        escalatedTo: 'centre_admin_001',
        escalatedAt: now.subtract(const Duration(days: 2)),
        comments: [
          TicketComment(
            id: 'comment_004',
            ticketId: 'TKT004',
            authorId: 'auditor_001',
            authorName: 'Dr. Amit Verma',
            authorRole: 'Auditor',
            content: 'This needs immediate attention as it affects the quarterly audit report.',
            createdAt: now.subtract(const Duration(days: 6)),
          ),
          TicketComment(
            id: 'comment_005',
            ticketId: 'TKT004',
            authorId: 'centre_admin_001',
            authorName: 'Centre Admin',
            authorRole: 'Centre Admin',
            content: 'Escalating to finance team for immediate review.',
            createdAt: now.subtract(const Duration(days: 2)),
          ),
        ],
      ),
      Ticket(
        id: 'TKT005',
        title: 'Public Grievance - Project Transparency',
        description: 'Citizen complaint about lack of transparency in local Adarsh Gram project progress.',
        category: TicketCategory.grievance,
        priority: TicketPriority.medium,
        status: TicketStatus.resolved,
        submitterId: 'public_001',
        submitterName: 'Citizen User',
        submitterRole: 'Public Viewer',
        assigneeId: 'state_officer_001',
        assigneeName: 'Rajesh Kumar',
        assigneeRole: 'State Officer',
        contextId: 'proj_adarsh_001',
        contextType: 'project',
        createdAt: now.subtract(const Duration(days: 10)),
        updatedAt: now.subtract(const Duration(days: 3)),
        resolvedAt: now.subtract(const Duration(days: 3)),
        dueDate: now.subtract(const Duration(days: 3)),
        slaHours: 168,
        comments: [
          TicketComment(
            id: 'comment_006',
            ticketId: 'TKT005',
            authorId: 'state_officer_001',
            authorName: 'Rajesh Kumar',
            authorRole: 'State Officer',
            content: 'Thank you for bringing this to our attention. We have updated the public dashboard with latest project progress.',
            createdAt: now.subtract(const Duration(days: 4)),
          ),
        ],
      ),
    ];
  }
}
