import 'package:flutter/material.dart';

/// Browsing screen for a specific library (Movies, TV Shows, Music, etc.).
class LibraryBrowseScreen extends StatelessWidget {
  final String libraryId;

  const LibraryBrowseScreen({super.key, required this.libraryId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'), // TODO: Load library name
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              // TODO: Show sort options
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Show filter options
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Library content will appear here'),
      ),
    );
  }
}
