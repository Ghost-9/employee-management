import 'package:employee_ledger/common/widgets/date_picker.dart';
import 'package:employee_ledger/utils/colors.dart';
import 'package:employee_ledger/utils/constants.dart';
import 'package:employee_ledger/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../blocs/employee_bloc.dart';
import '../blocs/employee_event.dart';
import '../models/employee.dart';

class AddEmployeeScreen extends StatefulWidget {
  final bool isEdit;
  final Employee? employee;

  AddEmployeeScreen({super.key, this.isEdit = false, this.employee}) {
    if (isEdit && employee == null) {
      throw ArgumentError("Employee must be provided when isEdit is true");
    }
  }

  @override
  AddEmployeeScreenState createState() => AddEmployeeScreenState();
}

class AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  String? _selectedRole;
  DateTime? _startDate = DateTime.now();
  DateTime? _endDate;
  int? id;

  @override
  void initState() {
    if (widget.isEdit && widget.employee != null) {
      id = widget.employee!.id;
      _nameController.text = widget.employee!.name;
      _selectedRole = widget.employee!.role;
      _startDate = widget.employee!.startDate;
      _endDate = widget.employee?.endDate;
    }
    super.initState();
  }

  /// Saves employee details
  void _saveEmployee() {
    if (_formKey.currentState!.validate() && _selectedRole != null) {
      final newEmployee = Employee(
        name: _nameController.text.trim(),
        role: _selectedRole!,
        startDate: _startDate!,
        endDate: _endDate,
      );
      context.read<EmployeeBloc>().add(AddEmployee(newEmployee));
      Navigator.pop(context);
    }
  }

  /// Updates employee details
  void _updateEmployee() {
    if (_formKey.currentState!.validate() && _selectedRole != null) {
      final updatedEmployee = Employee(
        id: id,
        name: _nameController.text.trim(),
        role: _selectedRole!,
        startDate: _startDate!,
        endDate: _endDate,
      );
      context.read<EmployeeBloc>().add(UpdateEmployee(updatedEmployee));
      Navigator.pop(context);
    }
  }

  void _showCustomRoleSelector() {
    showModalBottomSheet(
      backgroundColor: AppColors.homeScaffold,
      context: context,
      builder: (BuildContext context) {
        return ListView.separated(
          itemCount: Constants.roles.length,
          separatorBuilder:
              (context, index) =>
                  Divider(color: AppColors.textFormField, height: 0),
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,

          itemBuilder: (context, index) {
            return ListTile(
              dense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              titleAlignment: ListTileTitleAlignment.center,
              title: Center(
                child: Text(
                  Constants.roles[index],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColors.color8,
                  ),
                ),
              ),
              onTap: () {
                setState(() {
                  _selectedRole = Constants.roles[index];
                });
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isEdit == true
              ? "Edit Employee Details"
              : "Add Employee Details",
        ),
        automaticallyImplyLeading: false,
        actions:
            widget.isEdit == true
                ? [
                  IconButton(
                    icon: Icon(Icons.delete_outlined),
                    onPressed: () {
                      context.read<EmployeeBloc>().add(
                        DeleteEmployee(widget.employee!.id!),
                      );
                      Navigator.pop(context);
                      EmployeeUtils.showDeleteSnackbar(
                        id: widget.employee!.id!,
                        context: context,
                      );
                    },
                  ),
                ]
                : null,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: "Employee name",

                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator:
                        (value) =>
                            value!.isEmpty ? "Enter employee name" : null,
                  ),
                  SizedBox(height: 16),

                  GestureDetector(
                    onTap: _showCustomRoleSelector,
                    child: AbsorbPointer(
                      child: TextFormField(
                        readOnly: true,
                        controller:
                            _selectedRole != null
                                ? TextEditingController(text: _selectedRole)
                                : null,
                        decoration: InputDecoration(
                          labelText: "Select Role",
                          suffixIcon: IconButton(
                            icon: Icon(Icons.arrow_drop_down_rounded, size: 34),
                            onPressed: _showCustomRoleSelector,
                          ),
                          prefixIcon: Icon(Icons.work_outline),
                        ),
                        validator:
                            (value) => value!.isEmpty ? "Select Role" : null,
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  Row(
                    children: [
                      // Start Date
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            final selectedDate = await showDialog<DateTime>(
                              context: context,
                              builder:
                                  (BuildContext context) => AlertDialog(
                                    insetPadding: EdgeInsets.all(10),
                                    contentPadding: EdgeInsets.all(0),
                                    titlePadding: EdgeInsets.all(0),
                                    actionsPadding: EdgeInsets.all(0),
                                    content: EmployeeDatePicker(
                                      mode: DatePickerModeType.startDate,
                                      initialDate:
                                          widget.isEdit
                                              ? _startDate
                                              : DateTime.now(),
                                    ),
                                  ),
                            );
                            if (selectedDate != null) {
                              setState(() {
                                _startDate = selectedDate;
                              });
                            }
                          },
                          child: AbsorbPointer(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText:
                                    DateFormat(
                                              'd MMM yyyy',
                                            ).format(_startDate!) ==
                                            DateFormat(
                                              'd MMM yyyy',
                                            ).format(DateTime.now())
                                        ? "Today"
                                        : DateFormat(
                                          'd MMM yyyy',
                                        ).format(_startDate!),
                                prefixIcon: Icon(Icons.event_rounded),
                                border: OutlineInputBorder(),
                                labelStyle: TextStyle(
                                  color:
                                      _startDate != null
                                          ? Colors.black
                                          : Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(
                        Icons.arrow_right_alt_rounded,
                        size: 28,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 10),
                      // End Date
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            final selectedDate = await showDialog<DateTime>(
                              context: context,
                              builder:
                                  (BuildContext context) => AlertDialog(
                                    insetPadding: EdgeInsets.all(10),
                                    contentPadding: EdgeInsets.all(0),
                                    titlePadding: EdgeInsets.all(0),
                                    actionsPadding: EdgeInsets.all(0),
                                    content: EmployeeDatePicker(
                                      mode: DatePickerModeType.endDate,
                                      initialDate:
                                          widget.isEdit
                                              ? _endDate
                                              : DateTime.now(),
                                      startDateConstraint: _startDate,
                                    ),
                                  ),
                            );
                            if (selectedDate != null) {
                              setState(() {
                                _endDate = selectedDate;
                              });
                            } else {
                              setState(() {
                                _endDate = null;
                              });
                            }
                          },
                          child: AbsorbPointer(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText:
                                    _endDate != null
                                        ? DateFormat(
                                          'd MMM yyyy',
                                        ).format(_endDate!)
                                        : "No date",
                                labelStyle: TextStyle(
                                  color:
                                      _endDate != null
                                          ? Colors.black
                                          : Colors.grey,
                                  fontSize: 14,
                                ),
                                prefixIcon: Icon(Icons.event_rounded),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Divider(
                    color: AppColors.textFormField,
                    thickness: 1,
                    height: 0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,

                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 8,
                        ),
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.blueLight3,
                            foregroundColor: AppColors.primary,
                            minimumSize: Size(73, 40),
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            textStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          child: Text("Cancel"),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 8,
                        ),
                        child: ElevatedButton(
                          onPressed:
                              widget.isEdit == true
                                  ? _updateEmployee
                                  : _saveEmployee,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            minimumSize: Size(73, 40),
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            textStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          child: Text("Save"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
