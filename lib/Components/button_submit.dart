import 'package:flutter/material.dart';

class ButtonSubmit extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const ButtonSubmit({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
