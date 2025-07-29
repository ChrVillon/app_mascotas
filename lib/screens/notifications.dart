import 'dart:math';
import 'package:app_mascotas/styles/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'heatmap_native_screen.dart'; // Asegúrate de tener esta pantalla

class NotificacionesScreen extends StatefulWidget {
  const NotificacionesScreen({super.key});

  @override
  _NotificacionesScreenState createState() => _NotificacionesScreenState();
}

class _NotificacionesScreenState extends State<NotificacionesScreen> {
  List<Map<String, dynamic>> _coincidencias = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _buscarCoincidencias();
  }

Future<void> _buscarCoincidencias() async {
  final firestore = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser == null) {
    setState(() {
      _coincidencias = [];
      _cargando = false;
    });
    return;
  }

  // Solo reportes de pérdida del usuario actual
  final perdidasSnapshot = await firestore
      .collection('pet_reports')
      .where('uid', isEqualTo: currentUser.uid)
      .get();

  // Todos los reportes de encuentros
  final encuentrosSnapshot = await firestore
      .collection('found_reports')
      .get();

  final perdidas = perdidasSnapshot.docs.map((d) => d.data()).toList();
  final encuentros = encuentrosSnapshot.docs.map((d) => d.data()).toList();

  final coincidencias = _hacerMatch(
    perdidas: perdidas,
    encuentros: encuentros,
  );

  setState(() {
    _coincidencias = coincidencias;
    _cargando = false;
  });
}

  List<Map<String, dynamic>> _hacerMatch({
    required List<Map<String, dynamic>> perdidas,
    required List<Map<String, dynamic>> encuentros,
    double maxDistancia = 300.0,
  }) {
    List<Map<String, dynamic>> coincidencias = [];

    for (var perdida in perdidas) {
      for (var encuentro in encuentros) {
        final tipoIgual = perdida['tipo'] == encuentro['tipo'];
        final razaIgual = perdida['raza'] == encuentro['raza'];
        final tamanoIgual = perdida['tamano'] == encuentro['tamano'];

        final distancia = _calcularDistancia(
          perdida['latitud'],
          perdida['longitud'],
          encuentro['latitud'],
          encuentro['longitud'],
        );

        final cerca = distancia <= maxDistancia;

        if (tipoIgual && razaIgual && tamanoIgual && cerca) {
          coincidencias.add(encuentro);
        }
      }
    }

    return coincidencias;
  }

  double _calcularDistancia(
      double lat1, double lon1, double lat2, double lon2) {
    const radioTierra = 6371000;
    final dLat = _gradosARadianes(lat2 - lat1);
    final dLon = _gradosARadianes(lon2 - lon1);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_gradosARadianes(lat1)) *
            cos(_gradosARadianes(lat2)) *
            sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return radioTierra * c;
  }

  double _gradosARadianes(double grados) => grados * pi / 180;

  void _mostrarMapaDeCalor() {
    if (_coincidencias.isNotEmpty) {
      final puntos = _coincidencias
          .map((e) => {'lat': e['latitud'], 'lng': e['longitud']})
          .toList();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => HeatmapNativeScreen(puntos: puntos),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No hay coincidencias suficientes para generar el mapa de calor.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notificaciones'),
        backgroundColor: AppColors.appBarPrimary,
        actions: [
          IconButton(
            icon: Icon(Icons.map, color: AppColors.iconColor),
            onPressed: _mostrarMapaDeCalor,
          )
        ],
      ),
      body: _cargando
          ? Center(child: CircularProgressIndicator())
          : _coincidencias.isEmpty
              ? Center(child: Text('No se encontraron coincidencias.'))
              : ListView.builder(
                  itemCount: _coincidencias.length,
                  itemBuilder: (context, index) {
                    final rep = _coincidencias[index];
                    return ListTile(
                      leading: rep['imagen'] != null
                          ? Image.network(rep['imagen'], width: 50, height: 50, fit: BoxFit.cover)
                          : Icon(Icons.pets),
                      title: Text('${rep['tipo']} - ${rep['raza']}'),
                      subtitle: Text('${rep['tamano']}'),
                    );
                  },
                ),
    );
  }
}
