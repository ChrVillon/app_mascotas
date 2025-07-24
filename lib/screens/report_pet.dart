import 'package:app_mascotas/Components/app_bar.dart';
import 'package:app_mascotas/Components/drop_down.dart';
import 'package:app_mascotas/Components/image_picker.dart';
import 'package:app_mascotas/Components/text_field.dart';
import 'package:app_mascotas/screens/map_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ReportPetScreen extends StatefulWidget {
  const ReportPetScreen({super.key});

  @override
  State<ReportPetScreen> createState() => _ReportPetScreenState();
}

class _ReportPetScreenState extends State<ReportPetScreen> {
  String? selectedPetType;
  String? selectedBreed;
  String? selectedSize;
  LatLng? selectedLocation;

  @override
  Widget build(BuildContext context) {
    final dogBreeds = [
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

    List<String> breeds = ['Seleccione un tipo de mascota'];

    if (selectedPetType == 'Perro') {
      breeds = dogBreeds;
    } else if (selectedPetType == 'Gato') {
      breeds = catBreeds;
    }

    return Scaffold(
      appBar: AppBarComponent(showLeading: false, title: 'Reporte de Mascota'),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Ingrese datos de la mascota',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          TextFieldComponent(
            hintText: 'Nombre de la mascota',
            controller: TextEditingController(),
            icon: Icons.pets,
          ),
          SearchableDropdown<String>(
            search: false,
            items: ['Perro', 'Gato'],
            selectedItem: selectedPetType,
            hintText: 'Seleccione el tipo de mascota',
            onChanged: (value) {
              setState(() {
                selectedPetType = value;
              });
            },
          ),
          SearchableDropdown<String>(
            search: true,
            items: breeds,
            selectedItem: selectedBreed,
            hintText: 'Seleccione la raza',
            onChanged: (value) {
              setState(() {
                selectedBreed = value;
              });
            },
          ),
          SearchableDropdown<String>(
            search: false,
            items: petSizes,
            selectedItem: selectedSize,
            hintText: 'Seleccione el tamaño',
            onChanged: (value) {
              setState(() {
                selectedSize = value;
              });
            },
          ),
          TextFieldComponent(
            hintText: 'Descripción',
            controller: TextEditingController(),
            icon: Icons.pets,
            maxLines: 2,
          ),
          PhotoUploadField(
            onImageSelected: (image) {
              // Manejar la imagen seleccionada
            },
          ),
        ],
      ),
    );
  }
}
