class EducationEntry {
  final String institution;
  final String degree;
  final int year;

  const EducationEntry({
    required this.institution,
    required this.degree,
    required this.year,
  });

  factory EducationEntry.fromJson(Map<String, dynamic> json) {
    return EducationEntry(
      institution: json['institution'] as String,
      degree: json['degree'] as String,
      year: json['year'] as int,
    );
  }
}
