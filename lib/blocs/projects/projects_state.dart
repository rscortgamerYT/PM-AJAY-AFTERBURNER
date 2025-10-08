import 'package:equatable/equatable.dart';
import '../../models/project.dart';

abstract class ProjectsState extends Equatable {
  const ProjectsState();

  @override
  List<Object?> get props => [];
}

class ProjectsInitial extends ProjectsState {}

class ProjectsLoading extends ProjectsState {}

class ProjectsLoaded extends ProjectsState {
  final List<Project> projects;
  final String? filter;

  const ProjectsLoaded({
    required this.projects,
    this.filter,
  });

  @override
  List<Object?> get props => [projects, filter];
}

class ProjectsError extends ProjectsState {
  final String message;

  const ProjectsError(this.message);

  @override
  List<Object> get props => [message];
}
