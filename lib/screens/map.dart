import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyHomePage extends StatelessWidget {
  static const platform = MethodChannel('com.app_mascotas/heatmap');

  const MyHomePage({super.key});

  Future<void> _abrirHeatmap() async {
    try {
      await platform.invokeMethod('abrirHeatmap');
    } on PlatformException catch (e) {
      print("Error al abrir heatmap nativo: ${e.message}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Inicio")),
      body: Center(
        child: ElevatedButton(
          onPressed: _abrirHeatmap,
          child: Text("Abrir Heatmap nativo"),
        ),
      ),
    );
  }
}
