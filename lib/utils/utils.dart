import 'package:employee_ledger/blocs/employee_bloc.dart';
import 'package:employee_ledger/main.dart';
import 'package:employee_ledger/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeUtils {
  static void showDeleteSnackbar({
    required int id,
    required BuildContext context,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        animation: const AlwaysStoppedAnimation(1),
        backgroundColor: AppColors.color8,
        duration: const Duration(seconds: 2),
        content: Text("Employee data has been deleted"),
        action: SnackBarAction(
          label: 'Undo',
          onPressed:
              () =>
                  snackbarKey.currentContext?.read<EmployeeBloc>().undoDelete(),
        ),
        padding: EdgeInsets.symmetric(horizontal: 8),
        behavior: SnackBarBehavior.fixed,
        shape: Border(),
      ),
    );
  }

  static void showSnackbar({
    required String message,
    required BuildContext context,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        animation: const AlwaysStoppedAnimation(1),
        backgroundColor: AppColors.color8,
        duration: const Duration(seconds: 2),
        content: Text(message),
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        behavior: SnackBarBehavior.fixed,
        shape: Border(),
      ),
    );
  }
}
