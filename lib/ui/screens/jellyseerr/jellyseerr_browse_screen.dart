import 'package:flutter/material.dart';

class JellyseerrBrowseScreen extends StatelessWidget {
  final String? filterId;
  final String? filterName;
  final String? mediaType;
  final String? filterType;

  const JellyseerrBrowseScreen({
    super.key,
    this.filterId,
    this.filterName,
    this.mediaType,
    this.filterType,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(filterName ?? 'Browse')),
      body: const Center(
        child: Text('Jellyseerr browse results will appear here'),
      ),
    );
  }
}
