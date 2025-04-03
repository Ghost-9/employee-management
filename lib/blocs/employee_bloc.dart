import 'package:employee_ledger/models/employee.dart';
import 'package:employee_ledger/services/database_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'employee_event.dart';
import 'employee_state.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final ObjectBoxHelper dbHelper;
  Employee? _lastDeletedEmployee;

  EmployeeBloc(this.dbHelper) : super(EmployeeLoading()) {
    on<LoadEmployees>((event, emit) async {
      try {
        final employees = dbHelper.getEmployees();
        if (employees.isEmpty) {
          emit(EmployeeEmpty());
        } else {
          emit(EmployeeLoaded(employees));
        }
      } catch (e) {
        emit(EmployeeError("Failed to load employees"));
      }
    });

    on<AddEmployee>((event, emit) async {
      dbHelper.insertEmployee(event.employee);
      add(LoadEmployees());
    });

    on<UpdateEmployee>((event, emit) async {
      dbHelper.updateEmployee(event.employee);
      add(LoadEmployees());
    });

    on<DeleteEmployee>((event, emit) async {
      _lastDeletedEmployee = dbHelper.getEmployeeByID(event.id);
      if (_lastDeletedEmployee != null) {
        dbHelper.deleteEmployee(event.id);
        add(LoadEmployees());
      }
    });
    // });
  }

  void undoDelete() {
    if (_lastDeletedEmployee != null) {
      dbHelper.insertEmployee(_lastDeletedEmployee!);
      _lastDeletedEmployee = null;
      add(LoadEmployees());
    }
  }
}
