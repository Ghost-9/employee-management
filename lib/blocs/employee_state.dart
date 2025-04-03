import 'package:employee_ledger/models/employee.dart';

abstract class EmployeeState {}

class EmployeeLoading extends EmployeeState {}

class EmployeeEmpty extends EmployeeState {}

class EmployeeLoaded extends EmployeeState {
  final List<Employee> employees;
  EmployeeLoaded(this.employees);
}

class EmployeeError extends EmployeeState {
  final String message;
  EmployeeError(this.message);
}
