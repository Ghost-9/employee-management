import 'package:employee_ledger/models/employee.dart';

abstract class EmployeeEvent {}

class LoadEmployees extends EmployeeEvent {}

class AddEmployee extends EmployeeEvent {
  final Employee employee;
  AddEmployee(this.employee);
}

class UpdateEmployee extends EmployeeEvent {
  final Employee employee;
  UpdateEmployee(this.employee);
}

class DeleteEmployee extends EmployeeEvent {
  final int id;
  DeleteEmployee(this.id);
}
