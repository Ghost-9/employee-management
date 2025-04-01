import 'dart:async';

import 'package:employee_ledger/utils/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      runApp(const MyApp());
    },
    (error, stackTrace) {
      _handleUncaughtError(error, stackTrace);
    },
  );
}

void _handleUncaughtError(Object error, StackTrace stackTrace) {
  if (kReleaseMode) {
    // Add your crash reporting service here
    // We can implement Firebase Crashlytics or any other crash reporting service
  } else {
    debugPrint('Uncaught error: $error\n$stackTrace');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Employee Management',
      theme: AppTheme.light,
      home: const EmployeeScreen(),
    );
  }
}

class EmployeeScreen extends StatelessWidget {
  const EmployeeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Employee List')),
      backgroundColor: AppColors.homeScaffold,
      body: Center(
        child: Image.asset('assets/images/no_records.png', fit: BoxFit.contain),
      ),
      floatingActionButton: SizedBox(
        height: 50,
        width: 50,
        child: FloatingActionButton(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          onPressed: () {},
          child: const Icon(Icons.add, size: 24),
        ),
      ),
    );
  }
}
