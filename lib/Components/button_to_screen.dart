import 'package:app_mascotas/styles/app_colors.dart';
import 'package:flutter/material.dart';

class ButtonToScreen extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  // Puedes añadir un tamaño opcional si quieres que sea configurable
  final double buttonSize; // Nuevo parámetro para el tamaño

  const ButtonToScreen({
    super.key,
    required this.text,
    required this.onPressed,
    this.buttonSize = 150.0, // Tamaño por defecto, puedes ajustarlo
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Usamos SizedBox para darle un tamaño fijo al ElevatedButton
        SizedBox(
          width: buttonSize,
          height: buttonSize,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              // Establece la forma a un círculo
              shape: CircleBorder(
                side: BorderSide(color: AppColors.buttonBorder, width: 3.0),
              ),
              // Color de fondo del botón
              backgroundColor: AppColors.buttonTransparent,
              // Ajusta el padding para controlar el tamaño del área interactiva del botón
              // Puedes experimentar con esto si el 'buttonSize' no es suficiente
              padding: EdgeInsets.zero, // Padding inicial, el tamaño lo da el SizedBox
              // No tiene sombra por defecto al ser transparente, pero puedes agregarla aquí si quieres.
              elevation: 9, // Generalmente un FAB tiene elevación, pero si es transparente, 0 es común.
            ),
            // El contenido del botón: el icono
            child: Icon(
              Icons.pets,
              color: AppColors.iconColor,
              size: buttonSize * 0.5, // El icono será el 50% del tamaño del botón
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: buttonSize * 1.1,
          child: Text(
            text,
            style: TextStyle(
              color: AppColors.letterPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}