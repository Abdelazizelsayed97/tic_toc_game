import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tic_tac_toe_game_second_clone/app_body/ui/widgets/show_dialog.dart';
import 'package:tic_tac_toe_game_second_clone/core/helpers/spacer.dart';

import '../../domain/entity/task_entity.dart';
import '../state_management/task_bloc/task_bloc.dart';

class TaskWidget extends StatefulWidget {
  final String title;
  final List<Task> tasks;

  const TaskWidget({super.key, required this.title, required this.tasks});

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  void setTitle(String title, BuildContext context, int index) {
    context.read<TaskBloc>().add(AssignTask(widget.tasks[index].id));
  }

  @override
  void initState() {
    super.initState();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        verticalSpace(10),
        ...widget.tasks.map((task) {
          final remainingDuration = task.endTime.difference(DateTime.now());
          return BlocBuilder<TaskBloc, TaskState>(
            builder: (context, state) {
              return Card(
                child: ListTile(
                  title: Text("Task no. ${task.taskCount}"),
                  trailing: Text(_formatDuration(remainingDuration)),
                  onTap: () {
                    if (widget.title == 'Unassigned Tasks') {
                      ShowDialog.handleWhoWins(
                          mark: 'you have assigned a task', context: context);
                      context.read<TaskBloc>().add(AssignTask(task.id));
                      DefaultTabController.of(context).animateTo(1);
                    }
                  },
                ),
              );
            },
          );
        }),
      ],
    );
  }
}
