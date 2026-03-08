import 'package:flutter/material.dart';

class LibraryGenresScreen extends StatelessWidget {
  final String libraryId;

  const LibraryGenresScreen({super.key, required this.libraryId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Genres')),
      body: const Center(child: Text('Library genres will appear here')),
    );
  }
}
