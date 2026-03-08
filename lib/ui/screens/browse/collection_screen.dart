import 'package:flutter/material.dart';

class CollectionScreen extends StatelessWidget {
  final String collectionId;

  const CollectionScreen({super.key, required this.collectionId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Collection')),
      body: const Center(child: Text('Collection items will appear here')),
    );
  }
}
