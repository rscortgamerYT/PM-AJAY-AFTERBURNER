import 'package:equatable/equatable.dart';
import '../../models/project.dart';

abstract class ProjectsEvent extends Equatable {
  const ProjectsEvent();

  @override
  List<Object?> get props => [];
}

class LoadProjects extends ProjectsEvent {}

class ProjectsUpdated extends ProjectsEvent {
  final List<Project> projects;

  const ProjectsUpdated(this.projects);

  @override
  List<Object> get props => [projects];
}

class CreateProject extends ProjectsEvent {
  final Project project;

  const CreateProject(this.project);

  @override
  List<Object> get props => [project];
}

class UpdateProject extends ProjectsEvent {
  final Project project;

  const UpdateProject(this.project);

  @override
  List<Object> get props => [project];
}

class DeleteProject extends ProjectsEvent {
  final String projectId;

  const DeleteProject(this.projectId);

  @override
  List<Object> get props => [projectId];
}

class FilterProjectsByState extends ProjectsEvent {
  final String stateCode;

  const FilterProjectsByState(this.stateCode);

  @override
  List<Object> get props => [stateCode];
}

class FilterProjectsByComponent extends ProjectsEvent {
  final ProjectComponent component;

  const FilterProjectsByComponent(this.component);

  @override
  List<Object> get props => [component];
}

class FilterProjectsByStatus extends ProjectsEvent {
  final ProjectStatus status;

  const FilterProjectsByStatus(this.status);

  @override
  List<Object> get props => [status];
}
