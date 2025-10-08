import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/project.dart';

class ProjectCard extends StatelessWidget {
  final Project project;
  final VoidCallback? onTap;

  const ProjectCard({
    super.key,
    required this.project,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with status and component
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatusChip(context),
                  _buildComponentChip(context),
                ],
              ),
              const SizedBox(height: 12),

              // Title
              Text(
                project.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),

              // Description
              if (project.description.isNotEmpty) ...[
                Text(
                  project.description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
              ],

              // Progress bar
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Progress',
                        style: theme.textTheme.bodySmall,
                      ),
                      Text(
                        '${project.progressPercentage.toStringAsFixed(0)}%',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: project.progressPercentage / 100,
                    backgroundColor: colorScheme.surfaceContainerHighest,
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Budget info
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Budget',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        _formatCurrency(project.budgetAllocated),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Utilized',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        _formatCurrency(project.utilization),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: _getUtilizationColor(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const Spacer(),

              // Footer with milestones
              Row(
                children: [
                  Icon(
                    Icons.flag_outlined,
                    size: 16,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${project.completedMilestones}/${project.milestones.length} milestones',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    Color chipColor;
    Color textColor;

    switch (project.status) {
      case ProjectStatus.active:
        chipColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        break;
      case ProjectStatus.completed:
        chipColor = Colors.blue.shade100;
        textColor = Colors.blue.shade800;
        break;
      case ProjectStatus.suspended:
        chipColor = Colors.red.shade100;
        textColor = Colors.red.shade800;
        break;
      case ProjectStatus.draft:
        chipColor = Colors.orange.shade100;
        textColor = Colors.orange.shade800;
        break;
    }

    return Chip(
      label: Text(
        project.status.displayName,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: chipColor,
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Widget _buildComponentChip(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Chip(
      label: Text(
        project.component.displayName,
        style: TextStyle(
          color: colorScheme.onSecondaryContainer,
          fontSize: 12,
        ),
      ),
      backgroundColor: colorScheme.secondaryContainer,
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Color _getUtilizationColor(BuildContext context) {
    final percentage = project.utilizationPercentage;
    if (percentage > 90) {
      return Colors.red;
    } else if (percentage > 70) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }
}
