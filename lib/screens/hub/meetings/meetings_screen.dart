import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../models/user_role.dart';
import '../../../models/hub/meeting.dart';

class MeetingsScreen extends StatefulWidget {
  final UserRole userRole;

  const MeetingsScreen({
    super.key,
    required this.userRole,
  });

  @override
  State<MeetingsScreen> createState() => _MeetingsScreenState();
}

class _MeetingsScreenState extends State<MeetingsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  DateTime _selectedDate = DateTime.now();
  final List<Meeting> _meetings = _getDemoMeetings();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
        _buildTabs(),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildCalendarView(),
              _buildUpcomingMeetings(),
              _buildActionItems(),
            ],
          ),
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
          const Icon(Symbols.event, size: 24),
          const SizedBox(width: 12),
          const Text(
            'Meetings & Reviews',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          _buildMeetingStats(),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: () => _scheduleMeeting(),
            icon: const Icon(Symbols.event_available, size: 18),
            label: const Text('Schedule'),
          ),
        ],
      ),
    );
  }

  Widget _buildMeetingStats() {
    final today = DateTime.now();
    final todayMeetings = _meetings.where((m) => 
        m.scheduledAt.day == today.day &&
        m.scheduledAt.month == today.month &&
        m.scheduledAt.year == today.year).length;
    final upcomingMeetings = _meetings.where((m) => 
        m.scheduledAt.isAfter(today) &&
        m.status == MeetingStatus.scheduled).length;

    return Row(
      children: [
        _buildStatChip('Today', todayMeetings, Colors.blue),
        const SizedBox(width: 8),
        _buildStatChip('Upcoming', upcomingMeetings, Colors.green),
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
                Icon(Symbols.calendar_month, size: 20),
                SizedBox(width: 8),
                Text('Calendar'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Symbols.upcoming, size: 20),
                SizedBox(width: 8),
                Text('Upcoming'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Symbols.task_alt, size: 20),
                SizedBox(width: 8),
                Text('Action Items'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarView() {
    return Row(
      children: [
        Container(
          width: 300,
          padding: const EdgeInsets.all(16),
          child: _buildMiniCalendar(),
        ),
        Expanded(
          child: _buildDayView(),
        ),
      ],
    );
  }

  Widget _buildMiniCalendar() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Symbols.chevron_left),
                  onPressed: () => _previousMonth(),
                ),
                Text(
                  '${_getMonthName(_selectedDate.month)} ${_selectedDate.year}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Symbols.chevron_right),
                  onPressed: () => _nextMonth(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildCalendarGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDay = DateTime(_selectedDate.year, _selectedDate.month, 1);
    final lastDay = DateTime(_selectedDate.year, _selectedDate.month + 1, 0);
    final startDate = firstDay.subtract(Duration(days: firstDay.weekday - 1));
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
      ),
      itemCount: 42,
      itemBuilder: (context, index) {
        final date = startDate.add(Duration(days: index));
        final isCurrentMonth = date.month == _selectedDate.month;
        final isSelected = date.day == _selectedDate.day && 
                          date.month == _selectedDate.month &&
                          date.year == _selectedDate.year;
        final hasMeetings = _meetings.any((m) => 
            m.scheduledAt.day == date.day &&
            m.scheduledAt.month == date.month &&
            m.scheduledAt.year == date.year);

        return InkWell(
          onTap: () => setState(() => _selectedDate = date),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? Theme.of(context).primaryColor : null,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Stack(
              children: [
                Center(
                  child: Text(
                    '${date.day}',
                    style: TextStyle(
                      color: isSelected ? Colors.white :
                             isCurrentMonth ? Colors.black : Colors.grey,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
                if (hasMeetings)
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDayView() {
    final dayMeetings = _meetings.where((m) => 
        m.scheduledAt.day == _selectedDate.day &&
        m.scheduledAt.month == _selectedDate.month &&
        m.scheduledAt.year == _selectedDate.year).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${_getDayName(_selectedDate.weekday)}, ${_selectedDate.day} ${_getMonthName(_selectedDate.month)} ${_selectedDate.year}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          if (dayMeetings.isEmpty)
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Symbols.event_available,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No meetings scheduled',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: dayMeetings.length,
                itemBuilder: (context, index) {
                  final meeting = dayMeetings[index];
                  return _buildMeetingCard(meeting);
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildUpcomingMeetings() {
    final upcomingMeetings = _meetings.where((m) => 
        m.scheduledAt.isAfter(DateTime.now()) &&
        m.status == MeetingStatus.scheduled).toList();
    
    upcomingMeetings.sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: upcomingMeetings.length,
      itemBuilder: (context, index) {
        final meeting = upcomingMeetings[index];
        return _buildMeetingCard(meeting);
      },
    );
  }

  Widget _buildActionItems() {
    final allActionItems = _meetings
        .expand((m) => m.actionItems)
        .where((a) => !a.isCompleted)
        .toList();
    
    allActionItems.sort((a, b) => a.dueDate.compareTo(b.dueDate));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: allActionItems.length,
      itemBuilder: (context, index) {
        final actionItem = allActionItems[index];
        return _buildActionItemCard(actionItem);
      },
    );
  }

  Widget _buildMeetingCard(Meeting meeting) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
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
                    color: _getMeetingStatusColor(meeting.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    meeting.status.name.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: _getMeetingStatusColor(meeting.status),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getMeetingTypeColor(meeting.type).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    meeting.type.name.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: _getMeetingTypeColor(meeting.type),
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  '${meeting.scheduledAt.hour}:${meeting.scheduledAt.minute.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              meeting.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              meeting.description,
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
                  Symbols.schedule,
                  size: 16,
                  color: Colors.grey[500],
                ),
                const SizedBox(width: 4),
                Text(
                  '${meeting.durationMinutes} minutes',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  Symbols.group,
                  size: 16,
                  color: Colors.grey[500],
                ),
                const SizedBox(width: 4),
                Text(
                  '${meeting.participants.length} participants',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const Spacer(),
                if (meeting.meetingUrl != null)
                  TextButton.icon(
                    onPressed: () => _joinMeeting(meeting),
                    icon: const Icon(Symbols.videocam, size: 16),
                    label: const Text('Join'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionItemCard(ActionItem actionItem) {
    final isOverdue = DateTime.now().isAfter(actionItem.dueDate);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Checkbox(
          value: actionItem.isCompleted,
          onChanged: (value) => _toggleActionItem(actionItem),
        ),
        title: Text(
          actionItem.title,
          style: TextStyle(
            decoration: actionItem.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(actionItem.description),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Symbols.person,
                  size: 12,
                  color: Colors.grey[500],
                ),
                const SizedBox(width: 4),
                Text(
                  actionItem.assigneeName,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  Symbols.schedule,
                  size: 12,
                  color: isOverdue ? Colors.red : Colors.grey[500],
                ),
                const SizedBox(width: 4),
                Text(
                  _formatDate(actionItem.dueDate),
                  style: TextStyle(
                    fontSize: 12,
                    color: isOverdue ? Colors.red : Colors.grey[600],
                    fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (action) => _handleActionItemAction(actionItem, action),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Text('Edit'),
            ),
            const PopupMenuItem(
              value: 'complete',
              child: Text('Mark Complete'),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }

  Color _getMeetingStatusColor(MeetingStatus status) {
    switch (status) {
      case MeetingStatus.scheduled:
        return Colors.blue;
      case MeetingStatus.inProgress:
        return Colors.green;
      case MeetingStatus.completed:
        return Colors.grey;
      case MeetingStatus.cancelled:
        return Colors.red;
      case MeetingStatus.postponed:
        return Colors.orange;
    }
  }

  Color _getMeetingTypeColor(MeetingType type) {
    switch (type) {
      case MeetingType.projectReview:
        return Colors.blue;
      case MeetingType.auditDiscussion:
        return Colors.orange;
      case MeetingType.policyMeeting:
        return Colors.purple;
      case MeetingType.stateCoordination:
        return Colors.green;
      case MeetingType.agencyBriefing:
        return Colors.teal;
      case MeetingType.publicConsultation:
        return Colors.indigo;
      case MeetingType.other:
        return Colors.grey;
    }
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  String _getDayName(int weekday) {
    const days = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
    ];
    return days[weekday - 1];
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _previousMonth() {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + 1, 1);
    });
  }

  void _scheduleMeeting() {
    // Navigate to meeting scheduler
  }

  void _joinMeeting(Meeting meeting) {
    // Join video meeting
  }

  void _toggleActionItem(ActionItem actionItem) {
    // Toggle action item completion
  }

  void _handleActionItemAction(ActionItem actionItem, String action) {
    // Handle action item actions
  }

  static List<Meeting> _getDemoMeetings() {
    final now = DateTime.now();
    return [
      Meeting(
        id: 'meet_001',
        title: 'Maharashtra Project Review',
        description: 'Quarterly review of Maharashtra state projects',
        type: MeetingType.projectReview,
        status: MeetingStatus.scheduled,
        organizerId: 'centre_admin',
        organizerName: 'Centre Admin',
        organizerRole: 'Centre Admin',
        scheduledAt: now.add(const Duration(days: 2, hours: 10)),
        durationMinutes: 90,
        contextId: 'mh_projects',
        contextType: 'state',
        participants: [
          MeetingParticipant(
            userId: 'centre_admin',
            name: 'Centre Admin',
            role: 'Centre Admin',
            email: 'centre@pmajay.gov.in',
            isRequired: true,
            hasAccepted: true,
          ),
          MeetingParticipant(
            userId: 'mh_officer',
            name: 'Rajesh Kumar',
            role: 'State Officer',
            email: 'rajesh@mh.gov.in',
            isRequired: true,
            hasAccepted: true,
          ),
        ],
        agenda: [
          'Review Q2 progress',
          'Budget utilization analysis',
          'Upcoming milestones',
          'Issue resolution',
        ],
        meetingUrl: 'https://meet.pmajay.gov.in/mh-review-001',
        createdAt: now.subtract(const Duration(days: 5)),
        updatedAt: now.subtract(const Duration(days: 1)),
        actionItems: [
          ActionItem(
            id: 'action_001',
            meetingId: 'meet_001',
            title: 'Submit revised budget proposal',
            description: 'Prepare and submit revised budget proposal for Q3',
            assigneeId: 'mh_officer',
            assigneeName: 'Rajesh Kumar',
            assigneeRole: 'State Officer',
            dueDate: now.add(const Duration(days: 7)),
            createdAt: now.subtract(const Duration(days: 1)),
          ),
        ],
      ),
      Meeting(
        id: 'meet_002',
        title: 'Audit Discussion - Q2 Findings',
        description: 'Discussion on Q2 audit findings and corrective actions',
        type: MeetingType.auditDiscussion,
        status: MeetingStatus.completed,
        organizerId: 'auditor_001',
        organizerName: 'Dr. Amit Verma',
        organizerRole: 'Auditor',
        scheduledAt: now.subtract(const Duration(days: 3)),
        durationMinutes: 60,
        participants: [
          MeetingParticipant(
            userId: 'auditor_001',
            name: 'Dr. Amit Verma',
            role: 'Auditor',
            email: 'amit@audit.gov.in',
            isRequired: true,
            hasAccepted: true,
            hasJoined: true,
          ),
          MeetingParticipant(
            userId: 'centre_admin',
            name: 'Centre Admin',
            role: 'Centre Admin',
            email: 'centre@pmajay.gov.in',
            isRequired: true,
            hasAccepted: true,
            hasJoined: true,
          ),
        ],
        agenda: [
          'Review audit findings',
          'Discuss corrective measures',
          'Timeline for implementation',
        ],
        createdAt: now.subtract(const Duration(days: 10)),
        updatedAt: now.subtract(const Duration(days: 3)),
        minutesDocumentId: 'doc_minutes_001',
        actionItems: [
          ActionItem(
            id: 'action_002',
            meetingId: 'meet_002',
            title: 'Implement audit recommendations',
            description: 'Implement the 5 key audit recommendations',
            assigneeId: 'centre_admin',
            assigneeName: 'Centre Admin',
            assigneeRole: 'Centre Admin',
            dueDate: now.add(const Duration(days: 14)),
            createdAt: now.subtract(const Duration(days: 3)),
          ),
        ],
      ),
    ];
  }
}
