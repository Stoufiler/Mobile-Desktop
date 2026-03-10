import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class GenreCardData {
  final String id;
  final String name;
  final int itemCount;
  String? backdropUrl;

  GenreCardData({
    required this.id,
    required this.name,
    required this.itemCount,
    this.backdropUrl,
  });
}

class GenreGridCard extends StatefulWidget {
  final GenreCardData genre;
  final VoidCallback onTap;
  final ValueChanged<bool> onHover;

  const GenreGridCard({
    super.key,
    required this.genre,
    required this.onTap,
    required this.onHover,
  });

  @override
  State<GenreGridCard> createState() => _GenreGridCardState();
}

class _GenreGridCardState extends State<GenreGridCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _hovered = true);
        widget.onHover(true);
      },
      onExit: (_) {
        setState(() => _hovered = false);
        widget.onHover(false);
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _hovered ? 1.03 : 1.0,
          duration: const Duration(milliseconds: 150),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (widget.genre.backdropUrl != null)
                  CachedNetworkImage(
                    imageUrl: widget.genre.backdropUrl!,
                    fit: BoxFit.cover,
                    fadeInDuration: const Duration(milliseconds: 200),
                    errorWidget: (_, __, ___) => Container(
                      color: Colors.white.withAlpha(20),
                    ),
                  )
                else
                  Container(color: Colors.white.withAlpha(20)),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withAlpha(180),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 12,
                  right: 12,
                  bottom: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.genre.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      if (widget.genre.itemCount > 0)
                        Text(
                          '${widget.genre.itemCount} items',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withAlpha(178),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
