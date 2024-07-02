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
    on<UpdateTask>(_onUpdateTask);
    // on<UpdateTask>(_onAssignedTaskTimeOut);
    on<RemoveTask>(_onRemoveTask);
    on<CheckTaskTimers>(_onCheckTaskTimers);

    _startTimer();
  }

  final List<Task> _unassignedTasksList = [];
  final List<Task> _assignedTasksList = [];
  final List<Task> _completedTasks = [];

  void _startTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      add(CheckTaskTimers());
    });
  }

  void _onAddTask(AddTask event, Emitter<TaskState> emit) {
    for (int i = 0; i < event.task.taskCount; i++) {
      _unassignedTasksList.add(
        event.task.copyWith(duration: event.task.duration * i),
      );
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

  final List<UpdateTask> newList = [];

  void _onUpdateTask(UpdateTask event, Emitter<TaskState> emit) {
    final taskIndex = _unassignedTasksList.indexWhere((task) {
      return task.id == event.task.id;
    });
    if (taskIndex != -1) {
      print(
          'if================================================================');
      _unassignedTasksList[taskIndex] = event.task;
      print('after:${_unassignedTasksList.map(
            (e) => e.taskCount,
          ).toList()}');
      emit(_buildTaskLoadedState());
    }
  }

  void _onRemoveTask(RemoveTask event, Emitter<TaskState> emit) {
    _unassignedTasksList.removeWhere((task) => task.id == event.taskId);
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
        _assignedTasksList.where((task) => task.endTime.isBefore(now)).toList();

    final expiredUnassignedTasks = _unassignedTasksList
        .where((task) => task.endTime.isBefore(now))
        .toList();

    for (var task in expiredAssignedTasks) {
      _assignedTasksList.remove(task);
      _unassignedTasksList.add(task.copyWith(
          endTime: DateTime.now()
              .add(Duration(seconds: task.duration + task.duration))));
    }

    for (var task in expiredUnassignedTasks) {
      _unassignedTasksList.remove(task);
    }

    final updatedAssignedTasksTimeOut = _assignedTasksList.map((task) {
      final remainingTime = task.endTime.difference(now).inSeconds;
      if (remainingTime <= 0) {
        _unassignedTasksList.add(task.copyWith(remainingTime: task.duration));
        return task.copyWith(
          remainingTime: 0,
          endTime: DateTime.now().add(Duration(seconds: task.duration)),
        );
      } else {
        return task.copyWith(remainingTime: remainingTime);
      }
    }).toList();

    final updatedUnassignedTasksTimeOut = _unassignedTasksList.map((task) {
      final remainingTime = task.endTime.difference(now).inSeconds;
      if (remainingTime <= 0) {
        return task.copyWith(remainingTime: 0);
      } else {
        return task.copyWith(remainingTime: remainingTime);
      }
    }).toList();

    _assignedTasksList
      ..clear()
      ..addAll(
          updatedAssignedTasksTimeOut.where((task) => task.remainingTime > 0));

    _unassignedTasksList
      ..clear()
      ..addAll(updatedUnassignedTasksTimeOut
          .where((task) => task.remainingTime > 0));

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
