import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/data/models/profile.dart';
import 'package:portfolio/presentation/portrait/achievements_section.dart';
import 'package:portfolio/presentation/portrait/additional_info_section.dart';
import 'package:portfolio/presentation/portrait/contact_section.dart';
import 'package:portfolio/presentation/portrait/education_section.dart';
import 'package:portfolio/presentation/portrait/experience_timeline.dart';
import 'package:portfolio/presentation/portrait/hero_section.dart';
import 'package:portfolio/presentation/portrait/project_showcase_section.dart';
import 'package:portfolio/presentation/portrait/skills_section.dart';
import 'package:portfolio/presentation/portrait/summary_section.dart';
import 'package:portfolio/presentation/widgets/profile_load_error.dart';

/// Flutter-Web entry point (see core/bootstrap.dart — kIsWeb picks this app).
///
/// This used to hand-roll its own page with its own hard-coded project list
/// and its own duplicate Project class — which is how two NDA'd project real
/// names ("Galaxy Pynt", "NLCS - Sancro") ended up hard-coded here with fake
/// example.com links. It now reuses the exact same data-driven section
/// widgets as the portrait/mobile app, so there is exactly one place project
/// data is rendered from, and it is always the NDA-safe profile.json.
class PortfolioLandscapeApp extends StatelessWidget {
  const PortfolioLandscapeApp({super.key, required this.profile});

  final Profile? profile;

  @override
  Widget build(BuildContext context) {
    final profile = this.profile;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: profile == null ? const ProfileLoadError() : LandScapeView(profile: profile),
    );
  }
}

class LandScapeView extends StatelessWidget {
  const LandScapeView({super.key, required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(profile.person.name),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 900;
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeroSection(person: profile.person),
                    const SizedBox(height: 20),
                    SummarySection(summary: profile.summary),
                    const SizedBox(height: 20),
                    SkillsSection(skills: profile.skills),
                    const SizedBox(height: 20),
                    ExperienceTimeline(experience: profile.experience),
                    const SizedBox(height: 20),
                    ProjectShowcaseSection(
                      categories: profile.projectCategories,
                      projects: profile.projects,
                    ),
                    const SizedBox(height: 20),
                    AchievementsSection(achievements: profile.achievements),
                    const SizedBox(height: 20),
                    _SideBySide(
                      isWide: isWide,
                      left: EducationSection(education: profile.education),
                      right: AdditionalInfoSection(entries: profile.additionalInfo),
                    ),
                    const SizedBox(height: 20),
                    ContactSection(contact: profile.person.contact),
                    const SizedBox(height: 32),
                    Center(
                      child: Text(
                        '© ${DateTime.now().year} ${profile.person.name}',
                        style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SideBySide extends StatelessWidget {
  const _SideBySide({required this.isWide, required this.left, required this.right});

  final bool isWide;
  final Widget left;
  final Widget right;

  @override
  Widget build(BuildContext context) {
    if (!isWide) {
      return Column(children: [left, const SizedBox(height: 20), right]);
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: left),
        const SizedBox(width: 20),
        Expanded(child: right),
      ],
    );
  }
}
