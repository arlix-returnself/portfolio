import 'package:portfolio/data/models/labeled_entry.dart';

class SkillCategory {
  final String id;
  final String title;
  final String icon;
  final List<LabeledEntry> items;

  const SkillCategory({
    required this.id,
    required this.title,
    required this.icon,
    required this.items,
  });

  factory SkillCategory.fromJson(Map<String, dynamic> json) {
    return SkillCategory(
      id: json['id'] as String,
      title: json['title'] as String,
      icon: json['icon'] as String,
      items: (json['items'] as List)
          .map((e) => LabeledEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
