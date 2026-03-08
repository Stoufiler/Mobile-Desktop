import 'package:flutter/material.dart';

class AllGenresScreen extends StatelessWidget {
  const AllGenresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Genres')),
      body: const Center(child: Text('Genre grid will appear here')),
    );
  }
}
