import 'package:flutter/material.dart';

class AppearanceSettingsScreen extends StatelessWidget {
  const AppearanceSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Appearance')),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.palette),
            title: Text('Theme'),
            subtitle: Text('Dark'),
          ),
          ListTile(
            leading: Icon(Icons.border_outer),
            title: Text('Focus Border Color'),
            subtitle: Text('White'),
          ),
          ListTile(
            leading: Icon(Icons.visibility),
            title: Text('Watched Indicators'),
            subtitle: Text('Always'),
          ),
        ],
      ),
    );
  }
}
