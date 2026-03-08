import 'package:flutter/material.dart';

class JellyseerrSettingsScreen extends StatelessWidget {
  const JellyseerrSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jellyseerr Settings')),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.link),
            title: Text('Connection URL'),
            subtitle: Text('Not configured'),
          ),
          ListTile(
            leading: Icon(Icons.security),
            title: Text('Authentication'),
            subtitle: Text('None'),
          ),
          SwitchListTile(
            title: Text('NSFW Filter'),
            subtitle: Text('Hide adult content'),
            value: true,
            onChanged: null,
          ),
        ],
      ),
    );
  }
}
