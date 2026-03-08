import 'package:flutter/material.dart';

class FolderViewScreen extends StatelessWidget {
  const FolderViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Folders')),
      body: const Center(child: Text('Folder structure will appear here')),
    );
  }
}
