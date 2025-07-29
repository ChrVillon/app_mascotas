import 'package:app_mascotas/screens/notifications.dart';
import 'package:app_mascotas/styles/app_colors.dart';
import 'package:flutter/material.dart';

class AppBarComponent extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showLeading;

  const AppBarComponent({super.key, this.title, required this.showLeading});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.appBarPrimary,
      automaticallyImplyLeading: false,
      leading: showLeading
          ? Padding(
              padding: const EdgeInsets.only(left: 8.0,),
              child: CircleAvatar(
                child: Icon(Icons.person, color: AppColors.iconSecondary),
                radius: 21,
                backgroundColor: Colors.white,
              ),
            )
          : IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
      title: showLeading
          ? const Text(
              'Bienvenido Usuario',
              style: TextStyle(
                color: AppColors.letterSecondary,
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            )
          : Text(
              title ?? '',
              style: const TextStyle(
                color: AppColors.letterSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
      actions: [
        IconButton(
          icon: Icon(Icons.notifications, color: AppColors.iconColor),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NotificacionesScreen()),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
