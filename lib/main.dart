import 'package:app_mascotas/screens/home.dart';
import 'package:app_mascotas/screens/login_register.dart';
import 'package:app_mascotas/screens/heatmap_native_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:app_mascotas/firebase_options.dart'; // Generado por flutterfire configure
import 'package:app_mascotas/state/notification_state.dart'; // Importar el estado global
import 'package:firebase_messaging/firebase_messaging.dart';


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Mensaje recibido en segundo plano: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Configurar el controlador de mensajes en segundo plano
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Iniciar la escucha de notificaciones
  NotificationState.startListening();

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

void _solicitarPermisosNotificaciones() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('Permisos de notificaciones concedidos');
  } else {
    print('Permisos de notificaciones denegados');
  }
}
