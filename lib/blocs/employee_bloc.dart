import 'package:employee_ledger/models/employee.dart';
import 'package:employee_ledger/services/database_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'employee_event.dart';
import 'employee_state.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final SembastHelper dbHelper;
  Employee? _lastDeletedEmployee;

  EmployeeBloc(this.dbHelper) : super(EmployeeLoading()) {
    on<LoadEmployees>((event, emit) async {
      final employees = await dbHelper.getEmployees();
      if (employees.isEmpty) {
        emit(EmployeeEmpty());
        return;
      }
      emit(EmployeeLoaded(employees));
    });

    on<AddEmployee>((event, emit) async {
      await dbHelper.insertEmployee(event.employee);
      add(LoadEmployees());
    });

    on<UpdateEmployee>((event, emit) async {
      await dbHelper.updateEmployee(event.employee);
      add(LoadEmployees());
    });

    on<DeleteEmployee>((event, emit) async {
      _lastDeletedEmployee = (await dbHelper.getEmployees()).firstWhere(
        (e) => e.id == event.id,
      );
      await dbHelper.deleteEmployee(event.id);
      add(LoadEmployees());
    });
  }
  void undoDelete() async {
    if (_lastDeletedEmployee != null) {
      await dbHelper.insertEmployee(_lastDeletedEmployee!);
      _lastDeletedEmployee = null;
      add(LoadEmployees());
    }
  }
}
