import 'package:portfolio/data/models/labeled_entry.dart';

class ExperienceSection {
  final String heading;
  final List<String> bullets;

  const ExperienceSection({required this.heading, required this.bullets});

  factory ExperienceSection.fromJson(Map<String, dynamic> json) {
    return ExperienceSection(
      heading: json['heading'] as String,
      bullets: (json['bullets'] as List).cast<String>(),
    );
  }
}

class ExperienceEntry {
  final String id;
  final String title;
  final String company;
  final String dateRange;
  final String intro;
  final List<ExperienceSection> sections;
  final List<LabeledEntry> technologies;
  final List<String> projectTypes;

  const ExperienceEntry({
    required this.id,
    required this.title,
    required this.company,
    required this.dateRange,
    required this.intro,
    required this.sections,
    required this.technologies,
    required this.projectTypes,
  });

  factory ExperienceEntry.fromJson(Map<String, dynamic> json) {
    return ExperienceEntry(
      id: json['id'] as String,
      title: json['title'] as String,
      company: json['company'] as String,
      dateRange: json['date_range'] as String,
      intro: json['intro'] as String,
      sections: (json['sections'] as List)
          .map((e) => ExperienceSection.fromJson(e as Map<String, dynamic>))
          .toList(),
      technologies: (json['technologies'] as List)
          .map((e) => LabeledEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      projectTypes: (json['project_types'] as List).cast<String>(),
    );
  }
}
