import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class NotificationState {
  static final ValueNotifier<bool> hasNotification = ValueNotifier(false);

  static void startListening() {
    final firestore = FirebaseFirestore.instance;
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) return;

    // Escuchar cambios en la colección de reportes de encuentros
    firestore
        .collection('found_reports')
        .where('notificado', isEqualTo: false) // Filtrar solo los no notificados
        .snapshots()
        .listen((snapshot) async {
      final encuentros = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // Usar el documentId como identificador único
        return data;
      }).toList();

      // Obtener los reportes de pérdida del usuario actual
      final perdidasSnapshot = await firestore
          .collection('pet_reports')
          .where('uid', isEqualTo: currentUser.uid)
          .get();

      final perdidas = perdidasSnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // Usar el documentId como identificador único
        return data;
      }).toList();

      // Verificar coincidencias
      final coincidencias = _hacerMatch(
        perdidas: perdidas,
        encuentros: encuentros,
      );

      if (coincidencias.isNotEmpty) {
        hasNotification.value = true;

        // Marcar los reportes como notificados en Firestore
        for (var doc in snapshot.docs) {
          await firestore.collection('found_reports').doc(doc.id).update({
            'notificado': true, // Actualizar el campo 'notificado' a true
          });
        }
      }
    });
  }

  static List<Map<String, dynamic>> _hacerMatch({
    required List<Map<String, dynamic>> perdidas,
    required List<Map<String, dynamic>> encuentros,
    double maxDistancia = 1000.0,
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

  static double _calcularDistancia(
      double lat1, double lon1, double lat2, double lon2) {
    const radioTierra = 6371000;
    final dLat = _gradosARadianes(lat2 - lat1);
    final dLon = _gradosARadianes(lat2 - lat1);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_gradosARadianes(lat1)) *
            cos(_gradosARadianes(lat2)) *
            sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return radioTierra * c;
  }

  static double _gradosARadianes(double grados) => grados * pi / 180;
}