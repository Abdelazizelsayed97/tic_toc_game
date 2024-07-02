import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart'; // Import uuid package

import '../../domain/entity/task_entity.dart';
import '../state_management/task_bloc/task_bloc.dart';
import 'main_app_page.dart';

class SetTasks extends StatelessWidget {
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _taskDurationController = TextEditingController();

  dispose() {
    _taskNameController.dispose();
    _taskDurationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Tasks'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _taskNameController,
              decoration: const InputDecoration(labelText: 'Task Name'),
            ),
            TextField(
              controller: _taskDurationController,
              decoration:
                  const InputDecoration(labelText: 'Duration (minutes)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                final taskName = int.tryParse(_taskNameController.text) ?? 0;
                ;
                final taskDuration =
                    int.tryParse(_taskDurationController.text) ?? 0;
                if (taskName > 0 && taskDuration > 0) {
                  final task = Task(
                    id: const Uuid().v4(),
                    taskCount: taskName,
                    duration: taskDuration * 60, // convert minutes to seconds
                    endTime:
                        DateTime.now().add(Duration(minutes: taskDuration)),
                  );
                  context.read<TaskBloc>().add(AddTask(task));
                  _taskNameController.clear();
                  _taskDurationController.clear();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => TaskPage(
                      task: task,
                    ),
                  ));
                }
              },
              child: const Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }
}
