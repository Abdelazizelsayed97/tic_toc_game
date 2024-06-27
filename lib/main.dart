import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_body/ui/pages/create_tasks_page.dart';
import 'app_body/ui/state_management/task_bloc/task_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      child: BlocProvider(
        create: (context) => TaskBloc(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: SetTasks(),
        ),
      ),
    );
  }
}
