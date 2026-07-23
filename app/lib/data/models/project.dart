class ProjectCategory {
  final String id;
  final String title;

  const ProjectCategory({required this.id, required this.title});

  factory ProjectCategory.fromJson(Map<String, dynamic> json) {
    return ProjectCategory(
      id: json['id'] as String,
      title: json['title'] as String,
    );
  }
}

/// The single Project model, sourced from content/profile.yaml via
/// app/assets/data/profile.json. `title` is already NDA-safe by the time it
/// reaches this file — scripts/build.rs substitutes `alter_title` and strips
/// `link` for any project with `nda: true` before writing profile.json, so
/// this model never has access to a real project's censored name or link.
class Project {
  final String id;
  final String category;
  final String title;
  final String tech;
  final String description;
  final bool nda;
  final String? link;

  const Project({
    required this.id,
    required this.category,
    required this.title,
    required this.tech,
    required this.description,
    required this.nda,
    this.link,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] as String,
      category: json['category'] as String,
      title: json['title'] as String,
      tech: json['tech'] as String,
      description: json['description'] as String,
      nda: json['nda'] as bool,
      link: json['link'] as String?,
    );
  }

  /// `tech` is a free-form string like "Flutter, Golang" — split into chips.
  List<String> get techChips => tech
      .split(RegExp(r'[,/]'))
      .map((t) => t.trim())
      .where((t) => t.isNotEmpty)
      .toList();
}
