import 'package:flutter/material.dart';

class GenreBrowseScreen extends StatelessWidget {
  final String genreName;
  final String? parentId;
  final String? includeType;

  const GenreBrowseScreen({
    super.key,
    required this.genreName,
    this.parentId,
    this.includeType,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(genreName)),
      body: const Center(child: Text('Genre items will appear here')),
    );
  }
}
