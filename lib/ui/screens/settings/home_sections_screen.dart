import 'package:flutter/material.dart';

class HomeSectionsScreen extends StatelessWidget {
  const HomeSectionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Sections')),
      body: const Center(
        child: Text('Reorderable home section list will appear here'),
      ),
    );
  }
}
