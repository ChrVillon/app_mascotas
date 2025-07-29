import 'dart:convert';
import 'dart:io';

import 'package:app_mascotas/screens/home.dart';
import 'package:app_mascotas/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Para PlatformException
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginRegisterScreen extends StatefulWidget {
  const LoginRegisterScreen({super.key});

  @override
  State<LoginRegisterScreen> createState() => _LoginRegisterScreenState();
}

class _LoginRegisterScreenState extends State<LoginRegisterScreen> {
  bool isLogin = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  String? _base64ProfilePhoto;
  File? _profileImage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickProfileImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File image = File(pickedFile.path);
      final bytes = await image.readAsBytes();
      setState(() {
        _profileImage = image;
        _base64ProfilePhoto = base64Encode(bytes);
      });
    }
  }

  Future<void> _handleAuth() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      if (isLogin) {
        // --- Lógica de Inicio de Sesión ---
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        // --- Lógica de Registro ---
        final methods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
        if (methods.isNotEmpty) {
          throw FirebaseAuthException(
            code: 'email-already-in-use',
            message: 'El correo ya está registrado.',
          );
        }

        final userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
              'email': email,
              'name': _nameController.text,
              'photo': _base64ProfilePhoto ?? '',
            });
      }

      // Si la autenticación o registro fue exitoso, navega a HomeScreen
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      _showFirebaseError(e); // Llama a la función para manejar errores de Firebase Auth
    } on PlatformException catch (e) {
      if (!mounted) return;
      _showPlatformError(e); // Llama a la función para manejar errores de plataforma
    } catch (e, stacktrace) {
      // Captura cualquier otro error inesperado
      debugPrint('Error inesperado: $e');
      debugPrint('$stacktrace');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ocurrió un error inesperado, por favor, inténtalo de nuevo.')),
      );
    }
  }

  // --- Funciones de Manejo de Errores ---
  void _showFirebaseError(FirebaseAuthException e) {
    String message;
    switch (e.code) {
      case 'user-not-found':
        message = 'No se encontró ningún usuario con ese correo.';
        break;
      case 'wrong-password':
      case 'invalid-credential':
        message = 'Correo o contraseña incorrectos.';
        break;
      case 'invalid-email':
        message = 'Correo inválido.';
        break;
      case 'email-already-in-use':
        message = 'Este correo ya está registrado.';
        break;
      case 'weak-password':
        message = 'La contraseña es muy débil.';
        break;
      case 'too-many-requests':
        message = 'Demasiados intentos. Intenta más tarde.';
        break;
      default:
        message = 'Error de autenticación: ${e.message ?? 'Desconocido'}';
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showPlatformError(PlatformException e) {
    String message = e.code == 'ERROR_INVALID_CREDENTIAL'
        ? 'Correo o contraseña incorrectos.'
        : 'Error de plataforma: ${e.message ?? e.code}';
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isLogin ? 'Iniciar Sesión' : 'Registrarse')),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(), // Oculta teclado
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              // --- SECCIÓN DE LA FOTO DE PERFIL (SOLO PARA REGISTRO) ---
              if (!isLogin) ...[ // Usar el operador spread `...` para incluir múltiples widgets
                GestureDetector(
                  onTap: _pickProfileImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    backgroundImage:
                        _profileImage != null ? FileImage(_profileImage!) : null,
                    child: _profileImage == null
                        ? const Icon(Icons.person, size: 50, color: Colors.white)
                        : null,
                  ),
                ),
                const SizedBox(height: 8),
                const Center(child: Text('Toca el icono para subir tu foto de perfil')),
                const SizedBox(height: 20),
              ],

              // --- CAMPO DE NOMBRE COMPLETO (SOLO PARA REGISTRO) ---
              if (!isLogin)
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre completo',
                    floatingLabelStyle: TextStyle(color: AppColors.borderFocus),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.borderFocus,
                        width: 2,
                      ),
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                  ),
                ),
              const SizedBox(height: 10),

              // --- CAMPO DE CORREO ---
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Correo',
                  floatingLabelStyle: TextStyle(color: AppColors.borderFocus),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.borderFocus,
                      width: 2,
                    ),
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // --- CAMPO DE CONTRASEÑA ---
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  floatingLabelStyle: TextStyle(color: AppColors.borderFocus),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.borderFocus,
                      width: 2,
                    ),
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // --- BOTÓN PRINCIPAL ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonPrimColor,
                  ),
                  onPressed: _handleAuth,
                  child: Text(
                    isLogin ? 'Iniciar Sesión' : 'Registrarse',
                    style: const TextStyle(color: AppColors.buttonText),
                  ),
                ),
              ),

              // --- BOTÓN DE CAMBIO DE MODO ---
              TextButton(
                onPressed: () => setState(() => isLogin = !isLogin),
                child: Text(
                  isLogin
                      ? '¿No tienes cuenta? Regístrate aquí'
                      : '¿Ya tienes cuenta? Inicia sesión',
                  style: const TextStyle(color: AppColors.letterPrimary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}