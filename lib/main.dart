import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_body/ui/pages/create_tasks_page.dart';
import 'app_body/ui/state_management/task_bloc/task_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _theme = ThemeData(
    dialogBackgroundColor: Colors.transparent,
    primaryColor: Colors.green,
    scaffoldBackgroundColor: Colors.white,
    primaryTextTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      child: BlocProvider(
        create: (context) => TaskBloc(),
        child: MaterialApp(
          theme: _theme,
          debugShowCheckedModeBanner: false,
          home: SetTasksPage(),
        ),
      ),
    );
  }
}
