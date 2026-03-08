import 'package:flutter/material.dart';

class ScreensaverSettingsScreen extends StatelessWidget {
  const ScreensaverSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Screensaver')),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.timer),
            title: Text('Timeout'),
            subtitle: Text('5 minutes'),
          ),
          ListTile(
            leading: Icon(Icons.brightness_low),
            title: Text('Dimming'),
            subtitle: Text('Enabled'),
          ),
        ],
      ),
    );
  }
}
