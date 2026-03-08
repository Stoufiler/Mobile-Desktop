import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:server_core/server_core.dart';

import '../../data/models/aggregated_item.dart';
import 'logo_view.dart';
import 'simple_info_row.dart';

const _textShadows = [Shadow(blurRadius: 4, color: Colors.black54)];

class InfoArea extends StatelessWidget {
  final AggregatedItem? item;

  const InfoArea({super.key, this.item});

  @override
  Widget build(BuildContext context) {
    final item = this.item;
    if (item == null) return const SizedBox.shrink();

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: _InfoAreaContent(key: ValueKey(item.id), item: item),
    );
  }
}

class _InfoAreaContent extends StatelessWidget {
  final AggregatedItem item;

  const _InfoAreaContent({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasLogo = item.logoImageTag != null;

    return SizedBox(
      width: 500,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasLogo)
            LogoView(
              imageUrl: _logoUrl,
              maxHeight: 100,
              maxWidth: 400,
            )
          else
            Text(
              item.displayTitle,
              style: theme.textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                shadows: _textShadows,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          const SizedBox(height: 8),
          SimpleInfoRow(item: item),
          if (item.overview != null) ...[
            const SizedBox(height: 8),
            Text(
              item.overview!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.9),
                shadows: _textShadows,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  String? get _logoUrl {
    final tag = item.logoImageTag;
    if (tag == null) return null;
    final client = GetIt.instance<MediaServerClient>();
    return client.imageApi.getLogoImageUrl(item.id, maxWidth: 400, tag: tag);
  }
}
