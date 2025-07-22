import 'package:app_mascotas/styles/app_colors.dart';
import 'package:flutter/material.dart';

class ButtonToScreen extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const ButtonToScreen({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FloatingActionButton.large(
          heroTag: null,
          backgroundColor: AppColors.buttonTransparent,
          onPressed: onPressed,
          shape: CircleBorder(
            side: BorderSide(color: AppColors.buttonBorder, width: 3.0),
          ),
          child: Container(
              color: AppColors.buttonTransparent,
              width: 100,
              height: 100,
              child: Icon(Icons.pets, color: AppColors.iconColor),
            ),
        ),
        SizedBox(height: 10,),
        Text(
          text,
          style: TextStyle(
            color: AppColors.letterPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
