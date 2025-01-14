import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tic_tac_toe_game_second_clone/app_body/ui/widgets/task_widget.dart';
import 'package:tic_tac_toe_game_second_clone/core/helpers/spacer.dart';

import '../../pages/game_page.dart';
import '../../state_management/task_bloc/task_bloc.dart';

class AssignedTasks extends StatelessWidget {
  const AssignedTasks({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        if (state is TaskLoaded && state.assignedTasks.isNotEmpty) {
          return Column(
            children: [
              BlocListener<TaskBloc, TaskState>(
                listener: (context, state) {
                  if (state is TaskLoaded) {
                    final remainingTime = state.assignedTasks
                        .map((e) => e.remainingTime)
                        .toList();
                    if (remainingTime.contains(1)) {
                      final taskWithZeroTime = state.assignedTasks
                          .firstWhere((task) => task.remainingTime == 1);

                      context
                          .read<TaskBloc>()
                          .add(UpdateTask(taskWithZeroTime));
                    }
                  }
                },
                child: TaskWidget(
                    title: 'Assigned Tasks', tasks: state.assignedTasks),
              ),
              verticalSpace(50),
              TicTacToeGame(
                onGameEnd: (x) {
                  if (x == "X") {
                    context
                        .read<TaskBloc>()
                        .add(CompleteTask(state.assignedTasks.first.id));
                    DefaultTabController.of(context).animateTo(2);
                  }
                },
              )
            ],
          );
        } else {
          return const Center(child: Text("You didn't assigned a task"));
        }
      },
    );
  }
}
