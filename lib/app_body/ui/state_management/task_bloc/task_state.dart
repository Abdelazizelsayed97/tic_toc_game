part of 'task_bloc.dart';

@immutable
abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object?> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoaded extends TaskState {
  final List<Task> unassignedTasks;
  final List<Task> assignedTasks;
  final List<Task> completedTasks;

  const TaskLoaded({
    required this.unassignedTasks,
    required this.assignedTasks,
    required this.completedTasks,
  });

  @override
  List<Object?> get props => [unassignedTasks, assignedTasks, completedTasks];

  TaskLoaded copyWith({
    List<Task>? unassignedTasks,
    List<Task>? assignedTasks,
    List<Task>? completedTasks,
  }) {
    return TaskLoaded(
      unassignedTasks: unassignedTasks ?? this.unassignedTasks,
      assignedTasks: assignedTasks ?? this.assignedTasks,
      completedTasks: completedTasks ?? this.completedTasks,
    );
  }
}
