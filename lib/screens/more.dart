import 'package:app_mascotas/Components/app_bar.dart';
import 'package:app_mascotas/Components/shearch_field.dart';
import 'package:flutter/material.dart';
import 'package:app_mascotas/Components/card.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> services = [
      {
        'title': 'Campaña de vacunación',
        'location': 'Parque Samanes',
        'rating': 4.8,
        'image': 'assets/images/vacunas.svg',
        'favorite': true,
      },
      {
        'title': 'Adopciones',
        'location': 'Centro de rescate',
        'rating': 4.6,
        'image': 'assets/images/adopcion.svg',
        'favorite': false,
      },
      {
        'title' : 'Mascotas encontradas',
        'location' : 'Samanes',
        'rating' : 4.5,
        'image' : 'assets/images/encontradas.svg',  
        'favorite': false,
      },
      {
        'title' : 'Foro de información',
        'location' : 'Zona Norte',
        'rating' : 4.7,
        'image' : 'assets/images/foro.svg',
        'favorite': true,
      }
    ];

    return Scaffold(
      appBar: AppBarComponent(showLeading: false, title: 'Más servicios'),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0,),
            child: SearchField(
              hintText: 'Buscar servicios',
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(10),
            itemCount: services.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              final item = services[index];
              return ServiceCard(
                title: item['title'],
                location: item['location'],
                rating: item['rating'],
                imagePath: item['image'],
                isFavorite: item['favorite'],
                onTap: () {
                  // Abrir detalles
                },
                onAdd: () {
                  // Acción al presionar "+"
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
