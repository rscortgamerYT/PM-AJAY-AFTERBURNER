import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/project.dart';
import '../../repositories/project_repository.dart';
import 'projects_event.dart';
import 'projects_state.dart';

class ProjectsBloc extends Bloc<ProjectsEvent, ProjectsState> {
  final ProjectRepository _projectRepository;
  StreamSubscription<List<Project>>? _projectsSubscription;

  ProjectsBloc({required ProjectRepository projectRepository})
      : _projectRepository = projectRepository,
        super(ProjectsInitial()) {
    on<LoadProjects>(_onLoadProjects);
    on<ProjectsUpdated>(_onProjectsUpdated);
    on<CreateProject>(_onCreateProject);
    on<UpdateProject>(_onUpdateProject);
    on<DeleteProject>(_onDeleteProject);
    on<FilterProjectsByState>(_onFilterProjectsByState);
    on<FilterProjectsByComponent>(_onFilterProjectsByComponent);
    on<FilterProjectsByStatus>(_onFilterProjectsByStatus);
  }

  void _onLoadProjects(LoadProjects event, Emitter<ProjectsState> emit) {
    emit(ProjectsLoading());
    
    _projectsSubscription?.cancel();
    _projectsSubscription = _projectRepository.watchProjects().listen(
      (projects) => add(ProjectsUpdated(projects)),
      onError: (error) => emit(ProjectsError(error.toString())),
    );
  }

  void _onProjectsUpdated(ProjectsUpdated event, Emitter<ProjectsState> emit) {
    emit(ProjectsLoaded(projects: event.projects));
  }

  Future<void> _onCreateProject(CreateProject event, Emitter<ProjectsState> emit) async {
    try {
      await _projectRepository.createProject(event.project);
      // Real-time subscription will handle the update
    } catch (error) {
      emit(ProjectsError(error.toString()));
    }
  }

  Future<void> _onUpdateProject(UpdateProject event, Emitter<ProjectsState> emit) async {
    try {
      await _projectRepository.updateProject(event.project);
      // Real-time subscription will handle the update
    } catch (error) {
      emit(ProjectsError(error.toString()));
    }
  }

  Future<void> _onDeleteProject(DeleteProject event, Emitter<ProjectsState> emit) async {
    try {
      await _projectRepository.deleteProject(event.projectId);
      // Real-time subscription will handle the update
    } catch (error) {
      emit(ProjectsError(error.toString()));
    }
  }

  Future<void> _onFilterProjectsByState(FilterProjectsByState event, Emitter<ProjectsState> emit) async {
    emit(ProjectsLoading());
    try {
      final projects = await _projectRepository.getProjectsByState(event.stateCode);
      emit(ProjectsLoaded(
        projects: projects,
        filter: 'State: ${event.stateCode}',
      ));
    } catch (error) {
      emit(ProjectsError(error.toString()));
    }
  }

  Future<void> _onFilterProjectsByComponent(FilterProjectsByComponent event, Emitter<ProjectsState> emit) async {
    emit(ProjectsLoading());
    try {
      final projects = await _projectRepository.getProjectsByComponent(event.component);
      emit(ProjectsLoaded(
        projects: projects,
        filter: 'Component: ${event.component.displayName}',
      ));
    } catch (error) {
      emit(ProjectsError(error.toString()));
    }
  }

  Future<void> _onFilterProjectsByStatus(FilterProjectsByStatus event, Emitter<ProjectsState> emit) async {
    if (state is ProjectsLoaded) {
      final currentProjects = (state as ProjectsLoaded).projects;
      final filteredProjects = currentProjects
          .where((project) => project.status == event.status)
          .toList();
      
      emit(ProjectsLoaded(
        projects: filteredProjects,
        filter: 'Status: ${event.status.displayName}',
      ));
    }
  }

  @override
  Future<void> close() {
    _projectsSubscription?.cancel();
    return super.close();
  }
}
