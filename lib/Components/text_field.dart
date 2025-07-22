import 'package:app_mascotas/styles/app_colors.dart';
import 'package:flutter/material.dart';

class TextFieldComponent extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final IconData? icon;

  const TextFieldComponent({
    super.key,
    required this.hintText,
    required this.controller,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(icon, color: const Color(0xFFB9AFAF)),
          border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: AppColors.border, width: 1.5),
          ),
                    focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
        ),
      ),
    );
  }
}
