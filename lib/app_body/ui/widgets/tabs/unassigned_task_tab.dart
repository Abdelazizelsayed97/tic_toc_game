import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tic_tac_toe_game_second_clone/app_body/ui/widgets/task_widget.dart';

import '../../state_management/task_bloc/task_bloc.dart';

class UnassignedTasks extends StatelessWidget {
  const UnassignedTasks({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        if (state is TaskLoaded && state.unassignedTasks.isNotEmpty) {
          return TaskWidget(
              title: 'Unassigned Tasks', tasks: state.unassignedTasks);
        } else {
          return const Center(child: Text("There is no task"));
        }
      },
    );
  }
}
