import 'package:flutter/material.dart';
import 'package:portfolio/data/models/labeled_entry.dart';

class AdditionalInfoSection extends StatelessWidget {
  const AdditionalInfoSection({super.key, required this.entries});

  final List<LabeledEntry> entries;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('More about me', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            for (final entry in entries)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(entry.label, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5, color: colorScheme.primary)),
                    const SizedBox(height: 2),
                    Text(entry.content, style: const TextStyle(fontSize: 13, height: 1.4)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
