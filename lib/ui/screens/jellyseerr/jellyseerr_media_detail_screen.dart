import 'package:flutter/material.dart';

class JellyseerrMediaDetailScreen extends StatelessWidget {
  final String itemId;

  const JellyseerrMediaDetailScreen({super.key, required this.itemId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Media Details')),
      body: const Center(
        child: Text('Jellyseerr media details will appear here'),
      ),
    );
  }
}
