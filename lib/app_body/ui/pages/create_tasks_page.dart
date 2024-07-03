import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tic_tac_toe_game_second_clone/core/helpers/app_daimentions.dart';
import 'package:tic_tac_toe_game_second_clone/core/helpers/spacer.dart';
import 'package:uuid/uuid.dart';

import '../../../core/app_text_field/app_text_field.dart';
import '../../../core/text_styles/text_styles.dart';
import '../../domain/entity/task_entity.dart';
import '../state_management/task_bloc/task_bloc.dart';
import 'main_app_page.dart';

class SetTasksPage extends StatefulWidget {
  const SetTasksPage({super.key});

  @override
  State<SetTasksPage> createState() => _SetTasksPageState();
}

class _SetTasksPageState extends State<SetTasksPage> {
  final _countTextController = TextEditingController();
  final _sequenceTextController = TextEditingController();
  final ValueNotifier<bool> _valueNotifier = ValueNotifier(false);

  bool isFilled() {
    if (_countTextController.text.isNotEmpty &&
        _sequenceTextController.text.isNotEmpty) {
      return _valueNotifier.value = true;
    } else {
      return _valueNotifier.value = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    print('dispose');
    _countTextController.dispose();
    _sequenceTextController.dispose();
  }

  void _clearController() {
    _countTextController.clear();
    _sequenceTextController.clear();
    _valueNotifier.value = false;
    setState(() {});
  }

  void _onAddTaskPressed() {
    final taskCount = int.tryParse(_countTextController.text) ?? 0;
    final taskDuration = int.tryParse(_sequenceTextController.text) ?? 0;
    if (taskCount > 0 && taskDuration > 0) {
      final task = Task(
        id: const Uuid().v4(),
        taskCount: taskCount,
        duration: taskDuration * 60,
        endTime: DateTime.now().add(Duration(minutes: taskDuration)),
      );
      context.read<TaskBloc>().add(AddTask(task));
      _clearController();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => TaskPage(
            task: task,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Set Tasks'),
        centerTitle: true,
      ),
      body: Padding(
        padding: AppDimensions.xLarge(),
        child: Column(
          children: [
            AppTextField(
              onChanged: (p0) {
                isFilled();
              },
              maxLength: 2,
              label: "Task Count",
              controller: _countTextController,
            ),
            verticalSpace(20),
            AppTextField(
              onChanged: (p0) {
                isFilled();
              },
              maxLength: 1,
              label: "Sequence",
              controller: _sequenceTextController,
            ),
            const SizedBox(height: 10),
            ValueListenableBuilder(
              valueListenable: _valueNotifier,
              builder: (context, value, child) {
                return ElevatedButton(
                  onPressed: value ? _onAddTaskPressed : null,
                  child: Text(
                    'Add Task',
                    style: Styles.meduim(
                        color: value ? Colors.black : Colors.white),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
