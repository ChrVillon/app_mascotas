import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HeatmapNativeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> puntos;

  HeatmapNativeScreen({required this.puntos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mapa de Calor')),
      body: AndroidView(
        viewType: 'heatmap-view',
        creationParams: {'puntos': puntos},
        creationParamsCodec: const StandardMessageCodec(),
      ),
    );
  }
}
