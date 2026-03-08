import 'package:flutter/material.dart';

class MusicFavoritesScreen extends StatelessWidget {
  final String parentId;

  const MusicFavoritesScreen({super.key, required this.parentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorite Tracks')),
      body: const Center(child: Text('Favorite tracks will appear here')),
    );
  }
}
