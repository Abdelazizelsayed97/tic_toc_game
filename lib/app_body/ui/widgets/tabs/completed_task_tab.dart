import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tic_tac_toe_game_second_clone/app_body/ui/widgets/task_widget.dart';
import '../../state_management/task_bloc/task_bloc.dart';

class CompletedTasks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        if (state is TaskLoaded && state.completedTasks.isNotEmpty) {
          return TaskWidget(title: 'Completed Tasks', tasks: state.completedTasks);
        } else {
          return const Center(child: Text("No data"));
        }
      },
    );
  }
}
