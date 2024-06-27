part of 'task_bloc.dart';

@immutable
abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class AddTask extends TaskEvent {
  final Task task;

  const AddTask(this.task);

  @override
  List<Object?> get props => [task];
}

class AssignTask extends TaskEvent {
  final String taskId;

  const AssignTask(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

class CompleteTask extends TaskEvent {
  final String taskId;

  const CompleteTask(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

class UpdateTask extends TaskEvent {
  final Task task;

  const UpdateTask(this.task);

  @override
  List<Object?> get props => [task];
}

class RemoveTask extends TaskEvent {
  final String taskId;

  const RemoveTask(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

class CheckTaskTimers extends TaskEvent {}
