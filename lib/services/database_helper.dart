import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';

import '../models/employee.dart';

class SembastHelper {
  static final SembastHelper _instance = SembastHelper._internal();
  factory SembastHelper() => _instance;

  late Database _database;
  final StoreRef<int, Map<String, dynamic>> _employeeStore = intMapStoreFactory
      .store("employees");

  SembastHelper._internal();

  Future<void> init() async {
    if (kIsWeb) {
      _database = await databaseFactoryWeb.openDatabase('employee_db');
    } else {
      final dir = await getApplicationDocumentsDirectory();
      final dbPath = join(dir.path, 'employee_db.sembast');
      _database = await databaseFactoryIo.openDatabase(dbPath);
    }
  }

  Future<int> insertEmployee(Employee employee) async {
    if (employee.id != null) {
      await _employeeStore
          .record(employee.id!)
          .put(_database, employee.toMap());
      return employee.id!;
    }
    final finder = Finder(sortOrders: [SortOrder('id', false)]);
    final lastRecord = await _employeeStore.findFirst(
      _database,
      finder: finder,
    );

    int newId = (lastRecord?.key ?? 0) + 1;
    final newEmployee = employee.copyWith(id: newId);

    await _employeeStore.record(newId).put(_database, newEmployee.toMap());
    return newId;
  }

  Future<List<Employee>> getEmployees() async {
    final snapshots = await _employeeStore.find(_database);
    return snapshots.map((record) => Employee.fromMap(record.value)).toList();
  }

  Future<void> updateEmployee(Employee employee) async {
    await _employeeStore.record(employee.id!).put(_database, employee.toMap());
  }

  Future<void> deleteEmployee(int id) async {
    await _employeeStore.record(id).delete(_database);
  }
}
