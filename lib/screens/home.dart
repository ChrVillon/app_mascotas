import 'package:app_mascotas/Components/app_bar.dart';
import 'package:app_mascotas/Components/button_to_screen.dart';
import 'package:app_mascotas/Components/shearch_field.dart';
import 'package:app_mascotas/screens/report_pet.dart';
import 'package:app_mascotas/styles/app_colors.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //extendBodyBehindAppBar: true,
      appBar: AppBarComponent(
        title: null,
        showLeading: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.secondary],
            begin: Alignment.topCenter,
            end: Alignment.center,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(9),
          child: ListView(
            children: [
              Text('Safe Pets', style: TextStyle(color: AppColors.letterSecondary, fontSize: 30, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 90,
                    child: ButtonToScreen(text: 'Reporte de perdida',
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ReportPetScreen())),
                    ),
                  ),
                  SizedBox(
                    width: 90,
                    child: ButtonToScreen(text: 'Reporte de encuentro',
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ReportPetScreen())),
                    ),
                  ),
                  SizedBox(width: 90, child: ButtonToScreen(text: 'Donaciones',
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ReportPetScreen())),
                  ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              SearchField(hintText: 'Zona/Ubicación')
            ],
          ),
        ),
      ),
    );
  }
}
