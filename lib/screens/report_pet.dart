import 'package:app_mascotas/Components/app_bar.dart';
import 'package:app_mascotas/Components/drop_down.dart';
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
  LatLng? selectedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarComponent(showLeading: false, title: 'Reporte de Mascota'),
      body: Column(
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
          MapPicker(
            onLocationSelected: (LatLng latLng) {
              selectedLocation = latLng;
              print("Ubicación seleccionada: $latLng");
            },
          ),
        ],
      ),
    );
  }
}
