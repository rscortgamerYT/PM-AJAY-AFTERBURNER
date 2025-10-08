import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

enum SLATimerSize { small, medium, large }

class SLATimerWidget extends StatefulWidget {
  final DateTime startTime;
  final DateTime deadline;
  final SLATimerSize size;
  final bool showLabel;

  const SLATimerWidget({
    super.key,
    required this.startTime,
    required this.deadline,
    this.size = SLATimerSize.medium,
    this.showLabel = true,
  });

  @override
  State<SLATimerWidget> createState() => _SLATimerWidgetState();
}

class _SLATimerWidgetState extends State<SLATimerWidget> {
  late Stream<DateTime> _timeStream;

  @override
  void initState() {
    super.initState();
    _timeStream = Stream.periodic(
      const Duration(minutes: 1),
      (_) => DateTime.now(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DateTime>(
      stream: _timeStream,
      initialData: DateTime.now(),
      builder: (context, snapshot) {
        final now = snapshot.data!;
        final totalDuration = widget.deadline.difference(widget.startTime);
        final elapsedDuration = now.difference(widget.startTime);
        final remainingDuration = widget.deadline.difference(now);
        
        final progress = elapsedDuration.inMilliseconds / totalDuration.inMilliseconds;
        final isOverdue = now.isAfter(widget.deadline);
        final isNearDeadline = !isOverdue && remainingDuration.inHours <= 6;

        return _buildTimer(progress, remainingDuration, isOverdue, isNearDeadline);
      },
    );
  }

  Widget _buildTimer(double progress, Duration remaining, bool isOverdue, bool isNearDeadline) {
    final color = isOverdue ? Colors.red : 
                  isNearDeadline ? Colors.orange : Colors.green;
    
    switch (widget.size) {
      case SLATimerSize.small:
        return _buildSmallTimer(progress, remaining, color, isOverdue);
      case SLATimerSize.medium:
        return _buildMediumTimer(progress, remaining, color, isOverdue);
      case SLATimerSize.large:
        return _buildLargeTimer(progress, remaining, color, isOverdue);
    }
  }

  Widget _buildSmallTimer(double progress, Duration remaining, Color color, bool isOverdue) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(2),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          isOverdue ? 'Overdue' : _formatDuration(remaining),
          style: TextStyle(
            fontSize: 8,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildMediumTimer(double progress, Duration remaining, Color color, bool isOverdue) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isOverdue ? Symbols.schedule : Symbols.timer,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            isOverdue ? 'Overdue' : _formatDuration(remaining),
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLargeTimer(double progress, Duration remaining, Color color, bool isOverdue) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isOverdue ? Symbols.schedule : Symbols.timer,
                  size: 20,
                  color: color,
                ),
                const SizedBox(width: 8),
                Text(
                  'SLA Timer',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const Spacer(),
                if (isOverdue)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'OVERDUE',
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Started: ${_formatDateTime(widget.startTime)}',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  'Due: ${_formatDateTime(widget.deadline)}',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Center(
              child: Text(
                isOverdue 
                    ? 'Overdue by ${_formatDuration(remaining.abs())}'
                    : 'Time remaining: ${_formatDuration(remaining)}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays}d ${duration.inHours % 24}h';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    } else {
      return '${duration.inMinutes}m';
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
