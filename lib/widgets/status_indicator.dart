import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class StatusIndicator extends StatelessWidget {
  final String title;
  final String description;
  final StatusType status;
  final VoidCallback? onTap;
  final String? actionText;

  const StatusIndicator({
    super.key,
    required this.title,
    required this.description,
    required this.status,
    this.onTap,
    this.actionText,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getStatusColor().withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getStatusIcon(),
            color: _getStatusColor(),
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          description,
          style: const TextStyle(fontSize: 12),
        ),
        trailing: onTap != null
            ? TextButton(
                onPressed: onTap,
                child: Text(
                  actionText ?? _getDefaultActionText(),
                  style: TextStyle(
                    color: _getStatusColor(),
                    fontSize: 12,
                  ),
                ),
              )
            : Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _getStatusText(),
                  style: TextStyle(
                    color: _getStatusColor(),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (status) {
      case StatusType.active:
        return Colors.green;
      case StatusType.pending:
        return Colors.orange;
      case StatusType.inactive:
        return Colors.grey;
      case StatusType.error:
        return Colors.red;
      case StatusType.warning:
        return Colors.amber;
      case StatusType.info:
        return Colors.blue;
    }
  }

  IconData _getStatusIcon() {
    switch (status) {
      case StatusType.active:
        return Symbols.check_circle;
      case StatusType.pending:
        return Symbols.schedule;
      case StatusType.inactive:
        return Symbols.pause_circle;
      case StatusType.error:
        return Symbols.error;
      case StatusType.warning:
        return Symbols.warning;
      case StatusType.info:
        return Symbols.info;
    }
  }

  String _getStatusText() {
    switch (status) {
      case StatusType.active:
        return 'ACTIVE';
      case StatusType.pending:
        return 'PENDING';
      case StatusType.inactive:
        return 'INACTIVE';
      case StatusType.error:
        return 'ERROR';
      case StatusType.warning:
        return 'WARNING';
      case StatusType.info:
        return 'INFO';
    }
  }

  String _getDefaultActionText() {
    switch (status) {
      case StatusType.active:
        return 'Open';
      case StatusType.pending:
        return 'View';
      case StatusType.inactive:
        return 'Enable';
      case StatusType.error:
        return 'Fix';
      case StatusType.warning:
        return 'Check';
      case StatusType.info:
        return 'Learn More';
    }
  }
}

enum StatusType {
  active,
  pending,
  inactive,
  error,
  warning,
  info,
}

class SystemStatusPanel extends StatelessWidget {
  final String title;
  final List<StatusIndicator> indicators;

  const SystemStatusPanel({
    super.key,
    required this.title,
    required this.indicators,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Symbols.health_and_safety,
                  color: Colors.blue,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                _buildOverallStatus(),
              ],
            ),
            const SizedBox(height: 16),
            ...indicators,
          ],
        ),
      ),
    );
  }

  Widget _buildOverallStatus() {
    final activeCount = indicators.where((i) => i.status == StatusType.active).length;
    final totalCount = indicators.length;
    final percentage = totalCount > 0 ? (activeCount / totalCount) : 0.0;
    
    Color statusColor;
    String statusText;
    
    if (percentage >= 0.8) {
      statusColor = Colors.green;
      statusText = 'Healthy';
    } else if (percentage >= 0.6) {
      statusColor = Colors.orange;
      statusText = 'Warning';
    } else {
      statusColor = Colors.red;
      statusText = 'Critical';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            statusText,
            style: TextStyle(
              color: statusColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
