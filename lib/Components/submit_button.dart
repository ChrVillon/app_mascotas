import 'package:flutter/material.dart';

class SubmitButton extends StatefulWidget {
  final String text;
  final Future<void> Function()? onSubmit; // Función asíncrona que se ejecuta al presionar
  final ValueNotifier<bool>? isLoadingNotifier; // Opcional: para controlar el estado de carga desde fuera

  const SubmitButton({
    super.key,
    required this.text,
    this.onSubmit,
    this.isLoadingNotifier,
  });

  @override
  State<SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<SubmitButton> {
  bool _isLoadingInternal = false; // Estado de carga interno del botón

  bool get _isLoading => widget.isLoadingNotifier?.value ?? _isLoadingInternal;

  @override
  void initState() {
    super.initState();
    // Escucha cambios si se proporciona un isLoadingNotifier externo
    widget.isLoadingNotifier?.addListener(_handleLoadingChange);
  }

  @override
  void didUpdateWidget(covariant SubmitButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Actualiza los listeners si el notifier cambia
    if (widget.isLoadingNotifier != oldWidget.isLoadingNotifier) {
      oldWidget.isLoadingNotifier?.removeListener(_handleLoadingChange);
      widget.isLoadingNotifier?.addListener(_handleLoadingChange);
    }
  }

  @override
  void dispose() {
    widget.isLoadingNotifier?.removeListener(_handleLoadingChange);
    super.dispose();
  }

  void _handleLoadingChange() {
    // Reconstruye si el estado de carga externo cambia
    setState(() {});
  }

  Future<void> _handleSubmit() async {
    if (_isLoading || widget.onSubmit == null) return; // No hacer nada si ya está cargando o no hay onSubmit

    // 1. Iniciar el estado de carga
    if (widget.isLoadingNotifier == null) {
      setState(() {
        _isLoadingInternal = true;
      });
    } else {
      widget.isLoadingNotifier!.value = true;
    }

    try {
      // 2. Ejecutar la función de envío (simula envío a DB)
      await widget.onSubmit!();
      // Si llega aquí, significa que la operación fue exitosa
      _showSnackBar('Datos enviados con éxito!', Colors.green);
    } catch (e) {
      // 3. Manejar errores
      print('Error al enviar datos: $e');
      _showSnackBar('Error al enviar datos: ${e.toString()}', Colors.red);
    } finally {
      // 4. Finalizar el estado de carga
      if (widget.isLoadingNotifier == null) {
        setState(() {
          _isLoadingInternal = false;
        });
      } else {
        widget.isLoadingNotifier!.value = false;
      }
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _handleSubmit,
      style: ElevatedButton.styleFrom(
        // Ejemplo de estilos, personaliza a tu gusto
        minimumSize: const Size(double.infinity, 50), // Ancho completo, altura fija
        backgroundColor: _isLoading ? Colors.grey : Colors.blue, // Gris cuando está cargando
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: _isLoading
          ? const CircularProgressIndicator(
              color: Colors.white, // Color del indicador de carga
            )
          : Text(
              widget.text,
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
    );
  }
}