import 'package:portfolio/data/models/education_entry.dart';
import 'package:portfolio/data/models/experience_entry.dart';
import 'package:portfolio/data/models/labeled_entry.dart';
import 'package:portfolio/data/models/person_info.dart';
import 'package:portfolio/data/models/project.dart';
import 'package:portfolio/data/models/skill_category.dart';

class Profile {
  final PersonInfo person;
  final List<String> summary;
  final List<EducationEntry> education;
  final List<SkillCategory> skills;
  final List<ExperienceEntry> experience;
  final List<ProjectCategory> projectCategories;
  final List<Project> projects;
  final List<String> achievements;
  final List<LabeledEntry> additionalInfo;

  const Profile({
    required this.person,
    required this.summary,
    required this.education,
    required this.skills,
    required this.experience,
    required this.projectCategories,
    required this.projects,
    required this.achievements,
    required this.additionalInfo,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      person: PersonInfo.fromJson(json['person'] as Map<String, dynamic>),
      summary: (json['summary'] as List).cast<String>(),
      education: (json['education'] as List)
          .map((e) => EducationEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      skills: (json['skills'] as List)
          .map((e) => SkillCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
      experience: (json['experience'] as List)
          .map((e) => ExperienceEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      projectCategories: (json['project_categories'] as List)
          .map((e) => ProjectCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
      projects: (json['projects'] as List)
          .map((e) => Project.fromJson(e as Map<String, dynamic>))
          .toList(),
      achievements: (json['achievements'] as List).cast<String>(),
      additionalInfo: (json['additional_info'] as List)
          .map((e) => LabeledEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Projects for a given category id, in the order they appear in the source data.
  List<Project> projectsFor(String categoryId) =>
      projects.where((p) => p.category == categoryId).toList();
}
