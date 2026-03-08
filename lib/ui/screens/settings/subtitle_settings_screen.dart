import 'package:flutter/material.dart';

class SubtitleSettingsScreen extends StatelessWidget {
  const SubtitleSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Subtitles')),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.language),
            title: Text('Default Subtitle Language'),
            subtitle: Text('None'),
          ),
          ListTile(
            leading: Icon(Icons.format_size),
            title: Text('Subtitle Size'),
            subtitle: Text('Normal'),
          ),
          ListTile(
            leading: Icon(Icons.format_color_fill),
            title: Text('Subtitle Background'),
            subtitle: Text('Semi-transparent'),
          ),
        ],
      ),
    );
  }
}
