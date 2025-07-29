import 'package:app_mascotas/screens/home.dart';
import 'package:app_mascotas/screens/login_register.dart';
import 'package:app_mascotas/screens/heatmap_native_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:app_mascotas/firebase_options.dart'; // Generado por flutterfire configure


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: const LoginRegisterScreen(),
    );
  }
}
