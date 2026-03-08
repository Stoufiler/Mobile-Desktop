import 'package:flutter/material.dart';

class JellyseerrPersonScreen extends StatelessWidget {
  final String personId;

  const JellyseerrPersonScreen({super.key, required this.personId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Person')),
      body: const Center(
        child: Text('Jellyseerr person details will appear here'),
      ),
    );
  }
}
