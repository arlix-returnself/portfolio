import 'package:portfolio/data/models/contact_entry.dart';

class PersonInfo {
  final String name;
  final String defaultTitle;
  final List<ContactEntry> contact;

  const PersonInfo({
    required this.name,
    required this.defaultTitle,
    required this.contact,
  });

  factory PersonInfo.fromJson(Map<String, dynamic> json) {
    return PersonInfo(
      name: json['name'] as String,
      defaultTitle: json['default_title'] as String,
      contact: (json['contact'] as List)
          .map((e) => ContactEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Initials for the monogram avatar, e.g. "Văn Minh Huy" -> "VMH".
  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    final letters = parts.map((p) => p.isNotEmpty ? p[0] : '').join();
    return letters.length <= 3 ? letters.toUpperCase() : letters.substring(letters.length - 3).toUpperCase();
  }
}
