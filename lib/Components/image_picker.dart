import 'package:app_mascotas/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // Necesario para trabajar con File

class PhotoUploadField extends StatefulWidget {
  final ValueChanged<File?>? onImageSelected;
  final String labelText; // Nuevo: Texto para indicar la acción
  final IconData defaultIcon; // Nuevo: Icono a mostrar cuando no hay imagen

  const PhotoUploadField({
    super.key,
    this.onImageSelected,
    this.labelText = 'Imagen de tu mascota', // Texto por defecto
    this.defaultIcon = Icons.camera_alt, // Icono por defecto
  });

  @override
  State<PhotoUploadField> createState() => _PhotoUploadFieldState();
}

class _PhotoUploadFieldState extends State<PhotoUploadField> {
  File? _selectedImage;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      widget.onImageSelected?.call(_selectedImage);
    } else {
      print('No se seleccionó ninguna imagen.');
    }
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Tomar foto'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Seleccionar de la galería'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            if (_selectedImage != null) // Opción para eliminar si ya hay una imagen
              ListTile(
                leading: const Icon(Icons.delete_forever, color: Colors.red),
                title: const Text('Eliminar foto', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _selectedImage = null;
                  });
                  widget.onImageSelected?.call(null);
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, // Ajusta al tamaño del contenido
      children: [
        GestureDetector( // <--- HACEMOS EL CONTENEDOR CLICKABLE
          onTap: () => _showImageSourceActionSheet(context),
          child: Container(
            width: 150, // Tamaño de visualización, ajusta a tus necesidades
            height: 150,
            decoration: BoxDecoration(
              color: AppColors.fillTextField,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey, width: 1.5),
            ),
            child: _selectedImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      _selectedImage!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  )
                : Center(
                    child: Column( // Centramos el icono y el texto de ayuda
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          widget.defaultIcon,
                          size: 60,
                          color: AppColors.iconSecondary, // Usamos un color secundario para el icono
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                          child: Text(
                            widget.labelText,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}