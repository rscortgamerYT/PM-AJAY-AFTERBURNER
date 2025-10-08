import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/project_repository.dart';
import '../../blocs/projects/projects_bloc.dart';
import '../../blocs/projects/projects_event.dart';
import '../../blocs/projects/projects_state.dart';
import '../../widgets/project_card.dart';
import '../../widgets/fund_status_card.dart';
import '../../models/project.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProjectsBloc(
        projectRepository: ProjectRepository(),
      )..add(LoadProjects()),
      child: const ProjectsView(),
    );
  }
}

class ProjectsView extends StatelessWidget {
  const ProjectsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ProjectsBloc, ProjectsState>(
        builder: (context, state) {
          if (state is ProjectsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProjectsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading projects',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ProjectsBloc>().add(LoadProjects());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is ProjectsLoaded) {
            return _buildProjectsList(context, state.projects);
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateProjectDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('New Project'),
      ),
    );
  }

  Widget _buildProjectsList(BuildContext context, List<Project> projects) {
    if (projects.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.folder_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'No projects found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text('Create your first project to get started'),
          ],
        ),
      );
    }

    return CustomScrollView(
      slivers: [
        // Summary Cards
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildSummaryCards(context, projects),
          ),
        ),
        
        // Projects Grid
        SliverPadding(
          padding: const EdgeInsets.all(16.0),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return ProjectCard(project: projects[index]);
              },
              childCount: projects.length,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCards(BuildContext context, List<Project> projects) {
    final totalBudget = projects.fold<double>(
      0,
      (sum, project) => sum + project.budgetAllocated,
    );
    final totalUtilized = projects.fold<double>(
      0,
      (sum, project) => sum + project.utilization,
    );
    final utilizationPercentage = totalBudget > 0 ? (totalUtilized / totalBudget) * 100 : 0;

    final activeProjects = projects.where((p) => p.status == ProjectStatus.active).length;
    final completedProjects = projects.where((p) => p.status == ProjectStatus.completed).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: FundStatusCard(
                title: 'Total Budget',
                allocated: totalBudget,
                utilized: totalUtilized,
                percentage: utilizationPercentage.toDouble(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Project Status',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$activeProjects',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              const Text('Active'),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$completedProjects',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: Colors.green,
                                ),
                              ),
                              const Text('Completed'),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  void _showCreateProjectDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Project'),
        content: const Text('Project creation dialog will be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}
