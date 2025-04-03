import 'package:employee_ledger/utils/colors.dart';
import 'package:flutter/material.dart';

class DatePickerButton extends StatelessWidget {
  final String title;
  final Function? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? textColor;
  final double? fontSize;
  const DatePickerButton({
    super.key,
    required this.title,
    this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.textColor,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onPressed?.call(),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppColors.blueLight3,
        foregroundColor: foregroundColor ?? AppColors.color1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        minimumSize: const Size(174, 36),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: fontSize ?? 14,
          fontWeight: FontWeight.w400,
          color: textColor,
        ),
      ),
    );
  }
}
