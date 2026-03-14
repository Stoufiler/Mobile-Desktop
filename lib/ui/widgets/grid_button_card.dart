import 'package:flutter/material.dart';
import 'package:jellyfin_design/jellyfin_design.dart';

class GridButtonCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final double width;
  final double height;
  final Color? focusColor;

  const GridButtonCard({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.width = 160,
    this.height = 120,
    this.focusColor,
  });

  @override
  State<GridButtonCard> createState() => _GridButtonCardState();
}

class _GridButtonCardState extends State<GridButtonCard> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final color = _focused
        ? (widget.focusColor ?? AppColorScheme.buttonFocused)
        : AppColorScheme.buttonNormal;

    return Focus(
      onFocusChange: (f) => setState(() => _focused = f),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(AppSpacing.spaceSm),
            border: _focused
                ? Border.all(
                    color: widget.focusColor ?? AppColorScheme.accent,
                    width: 2,
                  )
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                size: 36,
                color: AppColorScheme.onButtonNormal,
              ),
              const SizedBox(height: AppSpacing.spaceSm),
              Text(
                widget.label,
                style: const TextStyle(
                  color: AppColorScheme.onButtonNormal,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
