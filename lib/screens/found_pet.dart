import 'dart:convert';
import 'dart:io';

import 'package:app_mascotas/Components/app_bar.dart';
import 'package:app_mascotas/Components/drop_down.dart';
import 'package:app_mascotas/Components/image_picker.dart';
import 'package:app_mascotas/Components/map_picker.dart';
import 'package:app_mascotas/Components/submit_button.dart';
import 'package:app_mascotas/Components/text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Importar PlatformException
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FoundPetScreen extends StatefulWidget {
  const FoundPetScreen({super.key});

  @override
  State<FoundPetScreen> createState() => _FoundPetScreenState();
}

class _FoundPetScreenState extends State<FoundPetScreen> {
  final TextEditingController _descController = TextEditingController();
  String? selectedPetType;
  String? selectedBreed;
  String? selectedSize;
  LatLng? selectedLocation;
  String? base64Image;
  // bool _isLoading = false; // Ya no necesitas esta variable de estado aquí, el SubmitButton la maneja internamente.

  final List<String> dogBreeds = [
    'Poodle', 'Pug', 'Chihuahua', 'Shih Tzu', 'Labrador Retriever',
    'Golden Retriever', 'Bulldog Francés', 'Yorkshire Terrier', 'Schnauzer',
    'Beagle', 'Pastor Alemán', 'Rottweiler', 'Pitbull Terrier', 'Dóberman',
    'Boxer', 'American Bully', 'Border Collie', 'Dálmata', 'Mastín Napolitano',
    'Mestizo / Criollo',
  ];

  final List<String> catBreeds = [
    'Criollo / Mestizo', 'Siames', 'Persa', 'Angora', 'Maine Coon', 'Bengalí',
    'Ragdoll', 'British Shorthair', 'Himalayo', 'Bombay', 'Azul Ruso',
    'Siberiano', 'Abisinio', 'Oriental de pelo corto', 'Scottish Fold', 'Manx',
  ];

  final List<String> petSizes = ['Pequeño', 'Mediano', 'Grande'];

  List<String> get breeds {
    if (selectedPetType == 'Perro') return dogBreeds;
    if (selectedPetType == 'Gato') return catBreeds;
    return ['Seleccione un tipo de mascota'];
  }

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  // --- FUNCIÓN DE ENVÍO MODIFICADA ---
  Future<void> _submitReport() async {
    // 1. Validación de campos: ¡Lanza una excepción si falta algo!
    if (selectedPetType == null ||
        selectedBreed == null ||
        selectedSize == null ||
        selectedLocation == null ||
        base64Image == null ||
        _descController.text.isEmpty) {
      // En lugar de solo mostrar un SnackBar y retornar, lanzamos una excepción.
      // El SubmitButton la capturará y mostrará el mensaje de error.
      throw Exception('Por favor, completa todos los campos obligatorios.');
    }

    // El `setState(() => _isLoading = true);` ya no es necesario aquí.
    // El SubmitButton se encarga de cambiar su estado de carga antes de llamar a `onSubmit`.

    try {
      final reportData = {
        'tipo': selectedPetType,
        'raza': selectedBreed,
        'tamano': selectedSize,
        'descripcion': _descController.text,
        'latitud': selectedLocation!.latitude,
        'longitud': selectedLocation!.longitude,
        'imagenBase64': base64Image,
        'notificado': false, // Agregar el campo 'notificado'
        'timestamp': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance.collection('found_reports').add(reportData);

      // Si llegamos hasta aquí, el reporte se envió con éxito a Firestore.
      // Puedes decidir si quieres un SnackBar aquí o dejar que el SubmitButton
      // maneje el mensaje de éxito por completo. Si el SubmitButton ya muestra
      // "Datos enviados con éxito", este SnackBar sería redundante.
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Reporte de encuentro enviado con éxito.')),
      // );

      if (!mounted) return; // Asegurarse de que el widget sigue montado antes de navegar
      Navigator.pop(context); // Regresar a la pantalla anterior

    } on FirebaseException catch (e) { // Captura excepciones específicas de Firebase
      throw Exception('Error de Firebase al enviar reporte: ${e.message ?? e.code}');
    } on PlatformException catch (e) { // Captura excepciones de plataforma
      throw Exception('Error de plataforma al enviar reporte: ${e.message ?? e.code}');
    } catch (e) {
      // Captura cualquier otra excepción inesperada
      throw Exception('Ocurrió un error inesperado al enviar reporte: ${e.toString()}');
    }
    // El bloque `finally` y la gestión del estado de carga del botón
    // se manejan dentro de la clase `SubmitButton`.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarComponent(showLeading: false, title: 'Reporte de encuentro'),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          const Text(
            'Detalles de la mascota encontrada',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SearchableDropdown<String>(
                  icon: Icons.pets,
                  search: false,
                  items: const ['Perro', 'Gato'],
                  selectedItem: selectedPetType,
                  hintText: 'Tipo',
                  onChanged: (value) {
                    setState(() {
                      selectedPetType = value;
                      selectedBreed = null; // Resetear raza al cambiar tipo
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SearchableDropdown<String>(
                  icon: Icons.pets, // Asegúrate de usar el icono correcto
                  search: true,
                  items: breeds,
                  selectedItem: selectedBreed,
                  hintText: 'Raza',
                  onChanged: (value) => setState(() => selectedBreed = value),
                ),
              ),
            ],
          ),
          SearchableDropdown<String>(
            icon: Icons.straighten,
            search: false,
            items: petSizes,
            selectedItem: selectedSize,
            hintText: 'Tamaño',
            onChanged: (value) => setState(() => selectedSize = value),
          ),
          TextFieldComponent(
            hintText: 'Descripción',
            controller: _descController,
            icon: Icons.description,
            maxLines: 3,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: const Text(
              'Zona donde encontró la mascota:',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Color(0xFF616161)),
            ),
          ),
          MapPicker(
            onLocationSelected: (latLng) {
              selectedLocation = latLng;
            },
          ),
          const SizedBox(height: 8),
          PhotoUploadField(
            onImageBase64Selected: (String? image) {
              base64Image = image;
            },
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(left: 87, right: 87),
            child: SubmitButton(
              text: 'Enviar Reporte',
              onSubmit: _submitReport, // <-- Se pasa la función modificada aquí
              // La propiedad `isLoadingNotifier: ValueNotifier(_isLoading)`
              // se elimina porque SubmitButton maneja su estado de carga internamente
              // en base al éxito o fallo de la función `onSubmit`.
            ),
          ),
        ],
      ),
    );
  }
}