import 'package:flutter/material.dart';

import '../../data/services/rating_icon_provider.dart';

const _textShadows = [Shadow(blurRadius: 4, color: Colors.black54)];

class RatingsRow extends StatelessWidget {
  final Map<String, double> ratings;
  final double? communityRating;
  final int? criticRating;
  final bool enableAdditionalRatings;
  final String enabledRatings;
  final String blockedRatings;
  final bool showLabels;

  const RatingsRow({
    super.key,
    required this.ratings,
    this.communityRating,
    this.criticRating,
    this.enableAdditionalRatings = false,
    this.enabledRatings = 'tomatoes,stars',
    this.blockedRatings = '',
    this.showLabels = true,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = enabledRatings
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toSet();
    final blocked = blockedRatings
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toSet();

    final allRatings = <String, double>{};

    if (communityRating != null) {
      allRatings['stars'] = communityRating!;
    }

    for (final entry in ratings.entries) {
      if (entry.key == 'tomatoes' && criticRating != null) continue;
      allRatings[entry.key] = entry.value;
    }

    if (!allRatings.containsKey('tomatoes') && criticRating != null) {
      allRatings['tomatoes'] = criticRating!.toDouble();
    }

    if (allRatings.isEmpty) return const SizedBox.shrink();

    final items = allRatings.entries.where((e) {
      if (blocked.contains(e.key)) return false;
      if (!enableAdditionalRatings) {
        return enabled.contains(e.key);
      }
      return true;
    }).toList();

    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) const SizedBox(width: 16),
            _SingleRating(
              source: items[i].key,
              value: items[i].value,
              showLabel: showLabels,
            ),
          ],
        ],
      ),
    );
  }
}

class _SingleRating extends StatelessWidget {
  final String source;
  final double value;
  final bool showLabel;

  const _SingleRating({
    required this.source,
    required this.value,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    final displayText = RatingIconProvider.formatRating(source, value);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (source == 'stars') ...[
          const Text(
            '\u2605',
            style: TextStyle(
              color: Color(0xFFFFC107),
              fontSize: 16,
              shadows: _textShadows,
            ),
          ),
          if (showLabel) const SizedBox(width: 4),
        ] else ...[
          _RatingIcon(source: source, value: value),
          if (showLabel) const SizedBox(width: 6),
        ],
        if (showLabel)
          Text(
            displayText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              shadows: _textShadows,
            ),
          ),
      ],
    );
  }
}

class _RatingIcon extends StatelessWidget {
  final String source;
  final double value;

  const _RatingIcon({
    required this.source,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final assetPath = RatingIconProvider.getIconAssetPath(
      source,
      value.toInt(),
    );

    if (assetPath == null) return const SizedBox.shrink();

    return Image.asset(
      assetPath,
      height: 20,
      filterQuality: FilterQuality.medium,
    );
  }
}
