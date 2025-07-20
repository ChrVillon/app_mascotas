import 'package:app_mascotas/styles/app_colors.dart';
import 'package:flutter/material.dart';

class AppBarComponent extends StatelessWidget implements PreferredSizeWidget {
  const AppBarComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.appBarPrimary,
      leading: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 21,
            ),
            SizedBox(width: 16),
            Text('Bienvenido Usuario', style: TextStyle(color: AppColors.letterSecondary, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.notifications, color: AppColors.iconColor),
          onPressed: () {
            // Action for notifications button
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
