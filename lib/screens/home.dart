import 'package:app_mascotas/Components/app_bar.dart';
import 'package:app_mascotas/Components/button_to_screen.dart';
import 'package:app_mascotas/Components/shearch_field.dart';
import 'package:app_mascotas/screens/donations.dart';
import 'package:app_mascotas/screens/found_pet.dart';
import 'package:app_mascotas/screens/more.dart';
import 'package:app_mascotas/screens/report_pet.dart';
import 'package:app_mascotas/styles/app_colors.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //extendBodyBehindAppBar: true,
      appBar: AppBarComponent(title: null, showLeading: true),
      body: Padding(
        padding: const EdgeInsets.all(9),
        child: ListView(
          children: [
            Text(
              'Safe Pets',
              style: TextStyle(
                fontSize: 47,
                fontWeight: FontWeight.bold,
                color: AppColors.letterPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: ButtonToScreen(
                          svgPath: 'assets/images/alert.svg',
                          text: 'Reporte de perdida',
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReportPetScreen(),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: ButtonToScreen(
                          svgPath: 'assets/images/pet.svg',
                          text: 'Reporte de encuentro',
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FoundPetScreen(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 35.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: ButtonToScreen(
                          svgPath: 'assets/images/donation.svg',
                          text: 'Donaciones',
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DonationScreen(),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: ButtonToScreen(
                          svgPath: 'assets/images/more.svg',
                          text: 'Otros',
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MoreScreen(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
