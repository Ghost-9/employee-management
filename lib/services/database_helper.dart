import 'package:path_provider/path_provider.dart';

import '../models/employee.dart';
import '../objectbox.g.dart'; // Auto-generated

class ObjectBoxHelper {
  late final Store store;
  late final Box<Employee> employeeBox;

  ObjectBoxHelper._create(this.store) {
    employeeBox = Box<Employee>(store);
  }

  static Future<ObjectBoxHelper> create() async {
    final dir = await getApplicationDocumentsDirectory();
    final store = await openStore(directory: dir.path);
    return ObjectBoxHelper._create(store);
  }

  void insertEmployee(Employee employee) {
    employeeBox.put(employee);
  }

  Employee getEmployeeByID(int id) {
    var employee = employeeBox.get(id);
    if (employee != null) {
      return employee;
    } else {
      throw Exception("Employee not found");
    }
  }

  List<Employee> getEmployees() {
    return employeeBox.getAll();
  }

  void updateEmployee(Employee employee) {
    employeeBox.put(employee);
  }

  void deleteEmployee(int id) {
    employeeBox.remove(id);
  }
}
