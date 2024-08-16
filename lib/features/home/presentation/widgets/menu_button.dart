/* Flutter Imports */
import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  final VoidCallback onLogout;
  final VoidCallback onThemeSwitch;

  const MenuButton({
    super.key,
    required this.onLogout,
    required this.onThemeSwitch,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: PopupMenuButton<String>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: Theme.of(context).scaffoldBackgroundColor,
        icon: const Icon(Icons.more_vert_outlined),
        onSelected: (value) {
          if (value == 'logout') {
            onLogout();
          } else if (value == 'theme') {
            onThemeSwitch();
          }
        },
        itemBuilder: (context) => [
          const PopupMenuItem<String>(
            value: 'logout',
            child: Row(
              children: [
                Icon(
                  Icons.exit_to_app_outlined,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text('Logout'),
              ],
            ),
          ),
          const PopupMenuItem<String>(
            value: 'theme',
            child: Row(
              children: [
                Icon(
                  Icons.brightness_6_outlined,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text('Alternar Tema'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
