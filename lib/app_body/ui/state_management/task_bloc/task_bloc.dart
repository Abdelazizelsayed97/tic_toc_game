import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../domain/entity/task_entity.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc() : super(TaskInitial()) {
    on<AddTask>(_onAddTask);
    on<AssignTask>(_onAssignTask);
    on<CompleteTask>(_onCompleteTask);
    on<UpdateTask>(_onUpdateTask);
    // on<UpdateTask>(_onAssignedTaskTimeOut);
    on<RemoveTask>(_onRemoveTask);
    on<CheckTaskTimers>(_onCheckTaskTimers);

    _startTimer();
  }

  final List<Task> _unassignedTasks = [];
  final List<Task> _assignedTasks = [];
  final List<Task> _completedTasks = [];

  void _startTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      add(CheckTaskTimers());
    });
  }

  void _onAddTask(AddTask event, Emitter<TaskState> emit) {
    _unassignedTasks.add(event.task);
    emit(_buildTaskLoadedState());
  }

  void _onAssignTask(AssignTask event, Emitter<TaskState> emit) {
    final taskIndex =
        _unassignedTasks.indexWhere((task) => task.id == event.taskId);
    if (taskIndex != -1) {
      final task = _unassignedTasks.removeAt(taskIndex);
      _assignedTasks.add(task);
      emit(_buildTaskLoadedState());
    }
  }

  void _onCompleteTask(CompleteTask event, Emitter<TaskState> emit) {
    final taskIndex =
        _assignedTasks.indexWhere((task) => task.id == event.taskId);
    if (taskIndex != -1) {
      final task = _assignedTasks.removeAt(taskIndex);
      _completedTasks.add(task.copyWith(isCompleted: true));
      emit(_buildTaskLoadedState());
    }
  }

  void _onUpdateTask(UpdateTask event, Emitter<TaskState> emit) {
    final taskIndex =
        _unassignedTasks.indexWhere((task) => task.id == event.task.id);
    if (taskIndex != -1) {
      _unassignedTasks[taskIndex] = event.task;
      emit(_buildTaskLoadedState());
    }
  }

  void _onRemoveTask(RemoveTask event, Emitter<TaskState> emit) {
    _unassignedTasks.removeWhere((task) => task.id == event.taskId);
    emit(_buildTaskLoadedState());
  }

  // void _onAssignedTaskTimeOut(UpdateTask event, Emitter<TaskState> emit) {
  //   final taskIndex =
  //       _assignedTasks.indexWhere((task) => task.id == event.task.id);
  //   if (taskIndex != -1) {
  //     final task = _unassignedTasks.removeAt(taskIndex);
  //     _unassignedTasks.add(task);
  //     emit(_buildTaskLoadedState());
  //   }
  // }

  void _onCheckTaskTimers(CheckTaskTimers event, Emitter<TaskState> emit) {
    final now = DateTime.now();

    final expiredAssignedTasks =
        _assignedTasks.where((task) => task.endTime.isBefore(now)).toList();

    final expiredUnassignedTasks =
        _unassignedTasks.where((task) => task.endTime.isBefore(now)).toList();

    for (var task in expiredAssignedTasks) {
      _assignedTasks.remove(task);
      _unassignedTasks.add(task.copyWith(
          endTime: DateTime.now().add(Duration(seconds: task.duration + 1))));
    }

    for (var task in expiredUnassignedTasks) {
      _unassignedTasks.remove(task);
    }

    final updatedAssignedTasks = _assignedTasks.map((task) {
      final remainingTime = task.endTime.difference(now).inSeconds;
      if (remainingTime <= 0) {
        return task.copyWith(
          remainingTime: 0,
          endTime: DateTime.now().add(Duration(seconds: task.duration)),
        );
      } else {
        return task.copyWith(remainingTime: remainingTime);
      }
    }).toList();

    final updatedUnassignedTasks = _unassignedTasks.map((task) {
      final remainingTime = task.endTime.difference(now).inSeconds;
      if (remainingTime <= 0) {
        return task.copyWith(remainingTime: 0);
      } else {
        return task.copyWith(remainingTime: remainingTime);
      }
    }).toList();

    _assignedTasks
      ..clear()
      ..addAll(updatedAssignedTasks.where((task) => task.remainingTime > 0));

    _unassignedTasks
      ..clear()
      ..addAll(updatedUnassignedTasks.where((task) => task.remainingTime > 0));

    emit(_buildTaskLoadedState());
  }

  TaskState _buildTaskLoadedState() {
    return TaskLoaded(
      unassignedTasks: List.from(_unassignedTasks),
      assignedTasks: List.from(_assignedTasks),
      completedTasks: List.from(_completedTasks),
    );
  }
}
