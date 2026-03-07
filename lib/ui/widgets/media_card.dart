import 'package:flutter/material.dart';

class MediaCard extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final String? imageUrl;
  final double width;
  final double aspectRatio;
  final VoidCallback? onTap;

  const MediaCard({
    super.key,
    this.title,
    this.subtitle,
    this.imageUrl,
    this.width = 150,
    this.aspectRatio = 2 / 3,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: aspectRatio,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: imageUrl != null
                      ? Image.network(
                          imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const _PlaceholderIcon(),
                        )
                      : const _PlaceholderIcon(),
                ),
              ),
            ),
            if (title != null) ...[
              const SizedBox(height: 6),
              Text(
                title!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            if (subtitle != null)
              Text(
                subtitle!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withAlpha(153),
                    ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PlaceholderIcon extends StatelessWidget {
  const _PlaceholderIcon();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Icon(Icons.movie, size: 32, color: Colors.white38),
    );
  }
}
