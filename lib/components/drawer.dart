import 'package:flutter/material.dart';
import 'package:minimal_notes_app/components/drawer_tile.dart';

import '../pages/settings.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        children: [
          //header
          const DrawerHeader(child: RotatedBox(quarterTurns: 1,
          child: Icon(Icons.hexagon))),

          //notes tile
          DrawerTile(
              title: "Notes",
              leading: const Icon(Icons.home),
              onTap: () => Navigator.pop(context),
          ),

          //setting tile
          DrawerTile(
              title: "Settings",
              leading: const Icon(Icons.settings),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage())
                );
              }
          ),

        ],
      ),
    );
  }
}
