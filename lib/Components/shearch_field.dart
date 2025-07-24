import 'package:app_mascotas/styles/app_colors.dart';
import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  final String hintText;

  const SearchField({super.key, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: AppColors.fillIcon,
              child: Icon(Icons.search, color: Colors.white),
            ),
          ),
          hintText: hintText,
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 1.5),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.borderFocus, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
