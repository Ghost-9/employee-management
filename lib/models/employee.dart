import 'package:objectbox/objectbox.dart';

@Entity()
class Employee {
  @Id(assignable: true)
  int? id;
  String name;
  String role;
  @Property(type: PropertyType.date)
  DateTime startDate;
  @Property(type: PropertyType.date)
  DateTime? endDate;

  Employee({
    this.id = 0,
    required this.name,
    required this.role,
    required this.startDate,
    required this.endDate,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "role": role,
      "start_date": startDate.toIso8601String(),
      "end_date": endDate?.toIso8601String(),
    };
  }

  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      id: map["id"],
      name: map["name"],
      role: map["role"],
      startDate: DateTime.parse(map["start_date"]),
      endDate: DateTime.parse(map["end_date"]),
    );
  }
}
