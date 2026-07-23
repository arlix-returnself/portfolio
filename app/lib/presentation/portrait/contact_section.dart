import 'package:flutter/material.dart';
import 'package:portfolio/data/models/contact_entry.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key, required this.contact});

  final List<ContactEntry> contact;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Contact', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            for (final entry in contact) ...[
              _ContactRow(entry: entry),
              if (entry != contact.last) const SizedBox(height: 10),
            ],
          ],
        ),
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({required this.entry});

  final ContactEntry entry;

  @override
  Widget build(BuildContext context) {
    final link = entry.link;
    final row = Row(
      children: [
        Text(entry.icon, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 10),
        Expanded(child: Text(entry.value)),
        if (link != null) Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.onSurfaceVariant),
      ],
    );
    if (link == null) return row;
    return InkWell(
      onTap: () => launchUrl(Uri.parse(link), mode: LaunchMode.externalApplication),
      borderRadius: BorderRadius.circular(8),
      child: Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: row),
    );
  }
}
