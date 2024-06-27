import 'package:flutter/material.dart';
import 'package:tic_tac_toe_game_second_clone/app_body/domain/entity/task_entity.dart';
import 'package:tic_tac_toe_game_second_clone/core/helpers/app_daimentions.dart';
import 'package:tic_tac_toe_game_second_clone/core/helpers/spacer.dart';
import 'package:tic_tac_toe_game_second_clone/core/text_styles/text_styles.dart';

import '../widgets/tabs/assigned_task_tab.dart';
import '../widgets/tabs/completed_task_tab.dart';
import '../widgets/tab_bar_widget.dart';
import '../widgets/tabs/unassigned_task_tab.dart';

class TaskPage extends StatefulWidget {
  final Task task;

  const TaskPage({super.key, required this.task});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            'Tic Tac Toe',
            style: Styles.semiBold(fontSize: 24, color: Colors.black),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: AppDimensions.meduim(),
          child: Column(
            children: [
              const TabBarWidget(),
              verticalSpace(10),
              Expanded(
                child: TabBarView(
                  children: [
                    const UnassignedTasks(),
                    const AssignedTasks(),
                    CompletedTasks(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
