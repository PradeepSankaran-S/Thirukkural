import 'package:flutter/material.dart';

class CommonCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final double? elevation;
  final BorderSide? borderSide;

  const CommonCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.color,
    this.elevation,
    this.borderSide,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: margin ?? const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (theme.brightness == Brightness.light
                ? theme.colorScheme.secondary.withOpacity(0.08)
                : Colors.black.withOpacity(0.2)),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Card(
        margin: EdgeInsets.zero,
        elevation: elevation ?? 0,
        color: color ?? theme.cardTheme.color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: borderSide ?? theme.cardTheme.shape?.shadowBorderSide ?? BorderSide(
            color: theme.colorScheme.primary.withOpacity(0.06),
            width: 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          splashColor: theme.colorScheme.primary.withOpacity(0.05),
          highlightColor: theme.colorScheme.primary.withOpacity(0.02),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(18.0),
            child: child,
          ),
        ),
      ),
    );
  }
}

// Extension to read border side from shape safely
extension on ShapeBorder? {
  BorderSide get shadowBorderSide {
    if (this is RoundedRectangleBorder) {
      return (this as RoundedRectangleBorder).side;
    }
    return BorderSide.none;
  }
}
