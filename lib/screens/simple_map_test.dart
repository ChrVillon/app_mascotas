import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// Este es el widget que puedes usar temporalmente en tu Scaffold
class SimpleMapTest extends StatefulWidget {
  const SimpleMapTest({super.key});

  @override
  State<SimpleMapTest> createState() => _SimpleMapTestState();
}

class _SimpleMapTestState extends State<SimpleMapTest> {
  late GoogleMapController mapController;

  // Coordenadas para el centro del mapa (ej. San Francisco)
  final LatLng _center = const LatLng(37.7749, -122.4194);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: 11.0, // Un nivel de zoom que muestre un área decente
      ),
      myLocationEnabled: true, // Opcional: muestra el punto azul de tu ubicación
      myLocationButtonEnabled: true, // Opcional: botón para centrar en tu ubicación
      // Puedes añadir un marcador simple para verificar si se renderiza
      markers: {
        Marker(
          markerId: const MarkerId('testMarker'),
          position: _center,
          infoWindow: const InfoWindow(title: 'Punto de Prueba'),
        ),
      },
    );
  }
}