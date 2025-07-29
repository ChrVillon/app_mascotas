import 'dart:convert';
import 'dart:io';

import 'package:app_mascotas/Components/app_bar.dart';
import 'package:app_mascotas/Components/drop_down.dart';
import 'package:app_mascotas/Components/image_picker.dart';
import 'package:app_mascotas/Components/submit_button.dart';
import 'package:app_mascotas/Components/text_field.dart';
import 'package:app_mascotas/Components/map_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Necesario para PlatformException
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ReportPetScreen extends StatefulWidget {
  const ReportPetScreen({super.key});

  @override
  State<ReportPetScreen> createState() => _ReportPetScreenState();
}

class _ReportPetScreenState extends State<ReportPetScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  String? selectedPetType;
  String? selectedBreed;
  String? selectedSize;
  LatLng? selectedLocation;
  File? selectedImage;
  String? base64Image;
  // bool _isLoading = false; // No necesitas esta variable aquí si SubmitButton gestiona su estado de carga interno

  final List<String> dogBreeds = [
    'Poodle',
    'Pug',
    'Chihuahua',
    'Shih Tzu',
    'Labrador Retriever',
    'Golden Retriever',
    'Bulldog Francés',
    'Yorkshire Terrier',
    'Schnauzer',
    'Beagle',
    'Pastor Alemán',
    'Rottweiler',
    'Pitbull Terrier',
    'Dóberman',
    'Boxer',
    'American Bully',
    'Border Collie',
    'Dálmata',
    'Mastín Napolitano',
    'Mestizo / Criollo',
  ];

  final List<String> catBreeds = [
    'Criollo / Mestizo',
    'Siames',
    'Persa',
    'Angora',
    'Maine Coon',
    'Bengalí',
    'Ragdoll',
    'British Shorthair',
    'Himalayo',
    'Bombay',
    'Azul Ruso',
    'Siberiano',
    'Abisinio',
    'Oriental de pelo corto',
    'Scottish Fold',
    'Manx',
  ];

  final List<String> petSizes = ['Pequeño', 'Mediano', 'Grande'];

  List<String> get breeds {
    if (selectedPetType == 'Perro') return dogBreeds;
    if (selectedPetType == 'Gato') return catBreeds;
    return ['Elija un tipo de mascota'];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  // --- FUNCIÓN DE ENVÍO MODIFICADA ---
  Future<void> _submitReport() async {
    // 1. Validación de campos: Lanza una excepción si falta algo
    if (_nameController.text.isEmpty ||
        selectedPetType == null ||
        selectedBreed == null ||
        selectedSize == null ||
        selectedLocation == null ||
        base64Image == null) {
      // Lanzamos una excepción. SubmitButton la capturará y mostrará el SnackBar de error.
      throw Exception('Por favor, completa todos los campos obligatorios.');
    }

    // Si la validación pasa, continuamos con la lógica de envío
    try {
      final reportData = {
        'nombre': _nameController.text,
        'tipo': selectedPetType,
        'raza': selectedBreed,
        'tamano': selectedSize,
        'descripcion': _descController.text,
        'latitud': selectedLocation!.latitude,
        'longitud': selectedLocation!.longitude,
        'imagenBase64': base64Image,
        'timestamp': FieldValue.serverTimestamp(),
        'uid': FirebaseAuth.instance.currentUser!.uid,
      };

      await FirebaseFirestore.instance.collection('pet_reports').add(reportData);

      // Si llegamos aquí, significa que la operación fue exitosa.
      // Puedes decidir si quieres un SnackBar aquí o dejar que el SubmitButton
      // muestre su propio mensaje de éxito. Si el SubmitButton ya muestra
      // "Datos enviados con éxito", este SnackBar sería redundante.
      // Por simplicidad y para evitar mensajes duplicados, usualmente se dejaría
      // que SubmitButton muestre el éxito, o se navegaría sin SnackBar aquí.
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Reporte enviado con éxito desde Firestore.')),
      // );
      
      if (!mounted) return; // Asegura que el widget sigue montado antes de navegar
      Navigator.pop(context); // Vuelve a la pantalla anterior
      
    } on FirebaseException catch (e) { // Captura excepciones específicas de Firebase
      throw Exception('Error de Firebase al enviar reporte: ${e.message ?? e.code}');
    } on PlatformException catch (e) { // Captura excepciones de plataforma
      throw Exception('Error de plataforma al enviar reporte: ${e.message ?? e.code}');
    } catch (e) {
      // Captura cualquier otra excepción inesperada
      throw Exception('Ocurrió un error inesperado al enviar reporte: ${e.toString()}');
    }
    // El manejo del estado de carga (_isLoading) y el SnackBar de éxito/error
    // del botón se gestionan dentro de SubmitButton.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarComponent(showLeading: false, title: 'Reporte de Mascota'),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          const Text(
            'Ingrese datos de la mascota',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          TextFieldComponent(
            hintText: 'Nombre de la mascota',
            controller: _nameController,
            icon: Icons.pets,
          ),
          Row(
            children: [
              Expanded(
                child: SearchableDropdown<String>(
                  icon: Icons.filter_list,
                  search: false,
                  items: const ['Perro', 'Gato'], // Usar const para listas inmutables
                  selectedItem: selectedPetType,
                  hintText: 'Tipo',
                  onChanged: (value) => setState(() {
                    selectedPetType = value;
                    selectedBreed = null; // Reset breed when pet type changes
                  }),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SearchableDropdown<String>(
                  icon: Icons.format_list_bulleted,
                  search: true,
                  items: breeds, // Usa el getter `breeds`
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
            child: Text('Zona donde perdió la mascota:', 
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: const Color(0xFF616161)),
            ),
          ),
          MapPicker(
            onLocationSelected: (latLng) {
              selectedLocation = latLng;
            },
          ),
          const SizedBox(height: 8),
          PhotoUploadField(
            onImageBase64Selected: (String? base64Image) {
              this.base64Image = base64Image;
            },
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(left: 87, right: 87),
            child: SubmitButton(
              text: 'Enviar Reporte',
              onSubmit: _submitReport, // <-- Aquí se llama a la función modificada
              // Ya no necesitas pasar isLoadingNotifier: ValueNotifier(_isLoading),
              // porque SubmitButton maneja su propio estado de carga interno (_isLoadingInternal)
              // y lo ajusta basado en si onSubmit lanza una excepción o termina con éxito.
            ),
          ),
        ],
      ),
    );
  }
}