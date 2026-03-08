import 'package:flutter/material.dart';

class MusicBrowseScreen extends StatelessWidget {
  final String libraryId;

  const MusicBrowseScreen({super.key, required this.libraryId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Music')),
      body: const Center(child: Text('Music library will appear here')),
    );
  }
}
