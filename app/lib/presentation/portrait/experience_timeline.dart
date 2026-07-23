import 'package:flutter/material.dart';
import 'package:portfolio/data/models/experience_entry.dart';
import 'package:portfolio/presentation/portrait/timeline_item.dart';

class ExperienceTimeline extends StatelessWidget {
  const ExperienceTimeline({super.key, required this.experience});

  final List<ExperienceEntry> experience;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Experience', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            for (var i = 0; i < experience.length; i++)
              TimelineItem(experience: experience[i], isLast: i == experience.length - 1),
          ],
        ),
      ),
    );
  }
}
