import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/data/models/profile.dart';
import 'package:portfolio/presentation/portrait/home_page.dart';
import 'package:portfolio/presentation/widgets/profile_load_error.dart';

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key, required this.profile});

  final Profile? profile;

  @override
  Widget build(BuildContext context) {
    final profile = this.profile;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: profile == null ? const ProfileLoadError() : HomePage(profile: profile),
    );
  }
}