class ContactEntry {
  final String type;
  final String icon;
  final String value;
  final String? link;

  const ContactEntry({
    required this.type,
    required this.icon,
    required this.value,
    this.link,
  });

  factory ContactEntry.fromJson(Map<String, dynamic> json) {
    return ContactEntry(
      type: json['type'] as String,
      icon: json['icon'] as String,
      value: json['value'] as String,
      link: json['link'] as String?,
    );
  }
}
