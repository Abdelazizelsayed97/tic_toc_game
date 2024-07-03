import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entity/task_entity.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc() : super(TaskInitial()) {
    on<AddTask>(_onAddTask);
    on<AssignTask>(_onAssignTask);
    on<CompleteTask>(_onCompleteTask);
    on<UpdateTask>(_onAssignedTaskTimeOut);
    on<RemoveTask>(_onRemoveTask);
    on<RemoveAllTask>(_onRemoveAllTask);
    on<CheckTaskTimers>(_onCheckTaskTimers);
    _startTimer();
  }

  final List<Task> _unassignedTasksList = [];
  final List<Task> _assignedTasksList = [];
  final List<Task> _completedTasks = [];

  void _startTimer() {
    Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        add(CheckTaskTimers());
      },
    );
  }

  void _onRemoveAllTask(RemoveAllTask event, Emitter<TaskState> emit) {
    _unassignedTasksList.clear();
    _assignedTasksList.clear();
    _completedTasks.clear();
    emit(TaskInitial());
  }

  void _onAddTask(AddTask event, Emitter<TaskState> emit) {
    for (int i = 1; i <= event.task.taskCount; i++) {
      int additionalDuration = i * event.task.duration;
      int newTaskDuration = event.task.duration;

      DateTime newEndTime =
          DateTime.now().add(Duration(seconds: additionalDuration));

      _unassignedTasksList.add(event.task.copyWith(
        duration: newTaskDuration,
        taskCount: i,
        endTime: newEndTime,
      ));
    }

    emit(_buildTaskLoadedState());
  }

  void _onAssignTask(AssignTask event, Emitter<TaskState> emit) {
    final taskIndex =
        _unassignedTasksList.indexWhere((task) => task.id == event.taskId);
    if (taskIndex != -1) {
      _assignedTasksList.add(_unassignedTasksList[taskIndex]);
      _unassignedTasksList.removeAt(taskIndex);
      emit(_buildTaskLoadedState());
    }
  }

  void _onCompleteTask(CompleteTask event, Emitter<TaskState> emit) {
    final taskIndex =
        _assignedTasksList.indexWhere((task) => task.id == event.taskId);
    if (taskIndex != -1) {
      final task = _assignedTasksList.removeAt(taskIndex);
      _completedTasks.add(task.copyWith(isCompleted: true));
      emit(_buildTaskLoadedState());
    }
  }

  void _onRemoveTask(RemoveTask event, Emitter<TaskState> emit) {
    _unassignedTasksList.removeWhere((task) => task.id == event.taskId);
    emit(_buildTaskLoadedState());
  }

  void _onAssignedTaskTimeOut(UpdateTask event, Emitter<TaskState> emit) {
    final taskIndex =
        _assignedTasksList.indexWhere((task) => task.id == event.task.id);
    if (taskIndex != -1) {
      final task = _assignedTasksList.removeAt(taskIndex);
      int additionalDuration = event.task.duration;
      DateTime newEndTime =
          DateTime.now().add(Duration(seconds: additionalDuration));
      _unassignedTasksList.add(
        task.copyWith(
          endTime: newEndTime,
          duration: additionalDuration,
        ),
      );
      emit(_buildTaskLoadedState());
    }
  }

  void _onCheckTaskTimers(CheckTaskTimers event, Emitter<TaskState> emit) {
    final now = DateTime.now();

    final expiredAssignedTasks =
        _assignedTasksList.where((task) => task.endTime.isBefore(now)).toList();

    for (var task in expiredAssignedTasks) {
      _assignedTasksList.remove(task);
      _unassignedTasksList.add(task.copyWith(
        endTime: DateTime.now().add(Duration(seconds: task.duration)),
      ));
    }

    final updatedAssignedTasks = _assignedTasksList.map((task) {
      final remainingTime = task.endTime.difference(now).inSeconds;
      return task.copyWith(
          remainingTime: remainingTime > 0 ? remainingTime : 0);
    }).toList();

    final expiredUnassignedTasks = _unassignedTasksList
        .where((task) => task.endTime.isBefore(now))
        .toList();

    for (var task in expiredUnassignedTasks) {
      _unassignedTasksList.remove(task);
    }

    final updatedUnassignedTasks = _unassignedTasksList.map((task) {
      final remainingTime = task.endTime.difference(now).inSeconds;
      return task.copyWith(
          remainingTime: remainingTime > 0 ? remainingTime : 0);
    }).toList();

    _assignedTasksList
      ..clear()
      ..addAll(updatedAssignedTasks.where((task) => task.remainingTime > 0));

    _unassignedTasksList
      ..clear()
      ..addAll(updatedUnassignedTasks.where((task) => task.remainingTime > 0));

    emit(_buildTaskLoadedState());
  }

  TaskState _buildTaskLoadedState() {
    return TaskLoaded(
      unassignedTasks: List.from(_unassignedTasksList),
      assignedTasks: List.from(_assignedTasksList),
      completedTasks: List.from(_completedTasks),
    );
  }
}
