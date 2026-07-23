import 'package:connectivity_banner/connectivity_banner.dart';
import 'package:flutter/material.dart';
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

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${profile.person.name} — ${profile.person.defaultTitle}'),
        centerTitle: true,
      ),
      body: ConnectivityBanner(
        onConnected: () {},
        child: ListView(
          padding: const EdgeInsets.all(20),
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
            EducationSection(education: profile.education),
            const SizedBox(height: 20),
            AdditionalInfoSection(entries: profile.additionalInfo),
            const SizedBox(height: 20),
            ContactSection(contact: profile.person.contact),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
