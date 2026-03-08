import 'package:flutter/material.dart';

class AuthSettingsScreen extends StatelessWidget {
  const AuthSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Authentication')),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.login),
            title: Text('Auto Login'),
            subtitle: Text('Last User'),
          ),
          ListTile(
            leading: Icon(Icons.pin),
            title: Text('PIN Code'),
            subtitle: Text('Not set'),
          ),
          ListTile(
            leading: Icon(Icons.sort),
            title: Text('User Sort'),
            subtitle: Text('Last used'),
          ),
        ],
      ),
    );
  }
}
