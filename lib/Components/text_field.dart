import 'package:app_mascotas/styles/app_colors.dart';
import 'package:flutter/material.dart';

class TextFieldComponent extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final IconData? icon;
  final int maxLines;
  final FocusNode? focusNode; // <-- ADD THIS LINE

  const TextFieldComponent({
    super.key,
    required this.hintText,
    required this.controller,
    this.icon,
    this.maxLines = 1,
    this.focusNode, // <-- ADD THIS LINE
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        maxLines: maxLines,
        controller: controller,
        focusNode: focusNode, // <-- ADD THIS LINE: Assign the FocusNode here
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(icon, color: AppColors.iconSecondary),
          border: const OutlineInputBorder(), // Consider making this const if possible
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: AppColors.border, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.borderFocus, width: 2),
          ),
        ),
      ),
    );
  }
}