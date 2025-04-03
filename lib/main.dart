import 'dart:async';

import 'package:employee_ledger/blocs/employee_bloc.dart';
import 'package:employee_ledger/blocs/employee_event.dart';
import 'package:employee_ledger/blocs/employee_state.dart';
import 'package:employee_ledger/models/employee.dart';
import 'package:employee_ledger/screens/add_employee_screen.dart';
import 'package:employee_ledger/services/database_helper.dart';
import 'package:employee_ledger/utils/colors.dart';
import 'package:employee_ledger/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

final GlobalKey<ScaffoldMessengerState> snackbarKey =
    GlobalKey<ScaffoldMessengerState>();
Future<void> main() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      final objectBox = await ObjectBoxHelper.create();

      runApp(MyApp(objectBox: objectBox));
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
  final ObjectBoxHelper objectBox;
  const MyApp({super.key, required this.objectBox});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EmployeeBloc(objectBox)..add(LoadEmployees()),
      child: MaterialApp(
        scaffoldMessengerKey: snackbarKey,
        debugShowCheckedModeBanner: false,
        title: 'Employee Management',
        theme: AppTheme.light,
        home: const EmployeeScreen(),
      ),
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
      body: BlocBuilder<EmployeeBloc, EmployeeState>(
        builder: (context, state) {
          if (state is EmployeeLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is EmployeeLoaded) {
            return Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      if (state.employees.any((e) => e.endDate == null)) ...[
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            "Current Employees",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        ...state.employees
                            .where((e) => e.endDate == null)
                            .map(
                              (employee) =>
                                  _buildEmployeeTile(employee, context),
                            ),
                      ],

                      if (state.employees.any((e) => e.endDate != null)) ...[
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            "Previous Employees",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        ...state.employees
                            .where((e) => e.endDate != null)
                            .map(
                              (employee) =>
                                  _buildEmployeeTile(employee, context),
                            ),
                      ],

                      if (state.employees.isNotEmpty) ...[
                        SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              "Swipe left to delete",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            );
          }
          if (state is EmployeeEmpty) {
            return Center(
              child: Image.asset(
                'assets/images/no_records.png',
                fit: BoxFit.contain,
              ),
            );
          }
          return Center(child: Text("No employees found"));
        },
      ),

      floatingActionButton: SizedBox(
        height: 50,
        width: 50,
        child: FloatingActionButton(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AddEmployeeScreen()),
            );
          },
          child: const Icon(Icons.add, size: 24),
        ),
      ),
    );
  }

  Widget _buildEmployeeTile(Employee employee, BuildContext context) {
    return Dismissible(
      key: Key(employee.id.toString()),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
      ),
      onDismissed: (direction) {
        context.read<EmployeeBloc>().add(DeleteEmployee(employee.id!));
        EmployeeUtils.showDeleteSnackbar(id: employee.id!, context: context);
      },
      child: Column(
        children: [
          ListTile(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder:
                      (context) =>
                          AddEmployeeScreen(isEdit: true, employee: employee),
                ),
              );
            },
            tileColor: Colors.white,
            title: Text(
              employee.name,
              style: TextStyle(
                color: AppColors.color8,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  employee.role,
                  style: TextStyle(
                    color: AppColors.lightGrey,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  employee.endDate == null
                      ? "From ${DateFormat('d MMM, yyyy').format(employee.startDate)}"
                      : "${DateFormat('d MMM, yyyy').format(employee.startDate)}"
                          "${employee.endDate != null ? ' - ${DateFormat('d MMM, yyyy').format(employee.endDate!)}' : ''}",
                  style: TextStyle(
                    color: AppColors.lightGrey,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
