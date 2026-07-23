/// A generic label/content pair — reused for skill items, experience
/// technologies, and additional_info entries in profile.json.
class LabeledEntry {
  final String label;
  final String content;

  const LabeledEntry({required this.label, required this.content});

  factory LabeledEntry.fromJson(Map<String, dynamic> json) {
    return LabeledEntry(
      label: json['label'] as String,
      content: json['content'] as String,
    );
  }
}
