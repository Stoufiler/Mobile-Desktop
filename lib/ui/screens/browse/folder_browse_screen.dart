import 'package:flutter/material.dart';

class FolderBrowseScreen extends StatelessWidget {
  final String folderId;

  const FolderBrowseScreen({super.key, required this.folderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Folder')),
      body: const Center(child: Text('Folder contents will appear here')),
    );
  }
}
