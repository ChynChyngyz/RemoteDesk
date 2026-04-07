import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:front/core/theme/app_theme.dart';

class GlassPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Color? color;
  final double blur;
  final BoxBorder? border;

  const GlassPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24.0),
    this.borderRadius = 16.0,
    this.color,
    this.blur = 16.0,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: color ?? AppTheme.panelBg,
            borderRadius: BorderRadius.circular(borderRadius),
            border: border ?? Border.all(color: AppTheme.borderGlass, width: 1.0),
          ),
          child: child,
        ),
      ),
    );
  }
}
