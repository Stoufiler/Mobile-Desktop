import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:server_core/server_core.dart';

import '../../../data/services/background_service.dart';
import '../../navigation/destinations.dart';
import '../../widgets/genre_grid_card.dart';

const _navyBackground = Color(0xFF101528);
const _jellyfinBlue = Color(0xFF00A4DC);
const _horizontalPadding = 60.0;

class LibraryGenresScreen extends StatefulWidget {
  final String libraryId;

  const LibraryGenresScreen({super.key, required this.libraryId});

  @override
  State<LibraryGenresScreen> createState() => _LibraryGenresScreenState();
}

class _LibraryGenresScreenState extends State<LibraryGenresScreen> {
  final _client = GetIt.instance<MediaServerClient>();
  final _backgroundService = GetIt.instance<BackgroundService>();
  StreamSubscription<String?>? _backgroundSub;
  String? _backdropUrl;

  List<GenreCardData> _genres = [];
  bool _isLoading = true;
  String _libraryName = '';
  String? _collectionType;

  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    _backgroundSub = _backgroundService.backgroundStream.listen((url) {
      if (mounted) setState(() => _backdropUrl = url);
    });
    _backdropUrl = _backgroundService.currentUrl;
    _load();
  }

  @override
  void dispose() {
    _disposed = true;
    _backgroundSub?.cancel();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final parentData = await _client.itemsApi.getItem(widget.libraryId);
      _libraryName = parentData['Name'] as String? ?? '';
      _collectionType = (parentData['CollectionType'] as String?)?.toLowerCase();

      final response = await _client.itemsApi.getGenres(
        parentId: widget.libraryId,
        sortBy: 'SortName',
        sortOrder: 'Ascending',
      );

      final items = (response['Items'] as List?) ?? [];
      _genres = items.map((g) {
        final data = g as Map<String, dynamic>;
        return GenreCardData(
          id: data['Id'] as String,
          name: data['Name'] as String? ?? '',
          itemCount: data['ChildCount'] as int? ??
              (data['MovieCount'] as int? ?? 0) +
                  (data['SeriesCount'] as int? ?? 0) +
                  (data['AlbumCount'] as int? ?? 0),
        );
      }).where((g) => g.itemCount > 0).toList();
    } catch (e) {
      debugPrint('Failed to load genres: $e');
    }

    _isLoading = false;
    if (!_disposed && mounted) setState(() {});

    _loadBackdrops();
  }

  Future<void> _loadBackdrops() async {
    final includeType = _includeType;
    await Future.wait(_genres.map((genre) => _loadGenreBackdrop(genre, includeType)));
  }

  Future<void> _loadGenreBackdrop(GenreCardData genre, String? includeType) async {
    if (_disposed) return;
    try {
      final response = await _client.itemsApi.getItems(
        parentId: widget.libraryId,
        genreIds: [genre.id],
        includeItemTypes: includeType != null ? [includeType] : ['Movie', 'Series'],
        sortBy: 'Random',
        sortOrder: 'Ascending',
        recursive: true,
        limit: 10,
        fields: 'BackdropImageTags',
      );
      final items = (response['Items'] as List?) ?? [];
      for (final raw in items) {
        final item = raw as Map<String, dynamic>;
        final tags = (item['BackdropImageTags'] as List?) ?? [];
        if (tags.isNotEmpty) {
          genre.backdropUrl = _client.imageApi.getBackdropImageUrl(
            item['Id'] as String,
          );
          if (!_disposed && mounted) setState(() {});
          return;
        }
      }
    } catch (_) {}
  }

  String? get _includeType {
    switch (_collectionType) {
      case 'movies':
        return 'Movie';
      case 'tvshows':
        return 'Series';
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasBackdrop = _backdropUrl != null;
    return Scaffold(
      backgroundColor: _navyBackground,
      body: Stack(
        children: [
          if (hasBackdrop)
            Positioned.fill(
              child: AnimatedSwitcher(
                duration: BackgroundService.transitionDuration,
                child: CachedNetworkImage(
                  key: ValueKey(_backdropUrl),
                  imageUrl: _backdropUrl!,
                  fit: BoxFit.cover,
                  fadeInDuration: const Duration(milliseconds: 300),
                  errorWidget: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
            ),
          Positioned.fill(
            child: Container(
              color: _navyBackground.withAlpha(hasBackdrop ? 140 : 191),
            ),
          ),
          Column(
            children: [
              _GenresHeader(
                libraryName: _libraryName,
                onBack: () => context.pop(),
              ),
              Expanded(child: _buildBody()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: _jellyfinBlue),
      );
    }

    if (_genres.isEmpty) {
      return const Center(
        child: Text('No genres found', style: TextStyle(color: Colors.white70)),
      );
    }

    return LayoutBuilder(builder: (context, constraints) {
      const cardWidth = 280.0;
      const spacing = 16.0;
      final crossAxisCount =
          ((constraints.maxWidth - _horizontalPadding * 2 + spacing) /
                  (cardWidth + spacing))
              .floor()
              .clamp(2, 8);

      return GridView.builder(
        padding: const EdgeInsets.fromLTRB(
            _horizontalPadding, 20, _horizontalPadding, 32),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: spacing,
          crossAxisSpacing: spacing,
          childAspectRatio: 16 / 9,
        ),
        itemCount: _genres.length,
        itemBuilder: (context, index) {
          final genre = _genres[index];
          return GenreGridCard(
            genre: genre,
            onTap: () {
              context.push(Destinations.genre(
                genre.name,
                genreId: genre.id,
                parentId: widget.libraryId,
                includeType: _includeType,
              ));
            },
            onHover: (hovering) {
              if (hovering && genre.backdropUrl != null) {
                _backgroundService.setBackgroundUrl(genre.backdropUrl!);
              }
            },
          );
        },
      );
    });
  }
}

class _GenresHeader extends StatelessWidget {
  final String libraryName;
  final VoidCallback onBack;

  const _GenresHeader({required this.libraryName, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          _horizontalPadding, 20, _horizontalPadding, 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white70, size: 22),
            onPressed: onBack,
            tooltip: 'Back',
          ),
          const SizedBox(width: 12),
          Text(
            '$libraryName — Genres',
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
