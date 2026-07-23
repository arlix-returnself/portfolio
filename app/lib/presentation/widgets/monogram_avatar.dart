import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_theme.dart';

/// A gradient-circle monogram avatar. Used instead of a photo because no
/// real profile photo asset exists in the repo yet.
class MonogramAvatar extends StatelessWidget {
  const MonogramAvatar({super.key, required this.initials, required this.size});

  final String initials;
  final double size;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gradientColors = isDark ? AppColors.heroGradientDark : AppColors.heroGradientLight;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(
          fontSize: size * 0.34,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: 1,
        ),
      ),
    );
  }
}
