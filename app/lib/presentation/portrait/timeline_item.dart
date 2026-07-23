import 'package:flutter/material.dart';
import 'package:portfolio/data/models/experience_entry.dart';
import 'package:portfolio/presentation/widgets/bold_text.dart';

class TimelineItem extends StatelessWidget {
  final ExperienceEntry experience;
  final bool isLast;

  const TimelineItem({super.key, required this.experience, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(shape: BoxShape.circle, color: colorScheme.primary),
              ),
              if (!isLast) Expanded(child: Container(width: 2, color: colorScheme.primary.withValues(alpha: 0.25))),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${experience.title} — ${experience.company}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(experience.dateRange, style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 13)),
                  const SizedBox(height: 8),
                  BoldText(experience.intro, style: const TextStyle(height: 1.4)),
                  for (final section in experience.sections) ...[
                    const SizedBox(height: 12),
                    Text(section.heading, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                    const SizedBox(height: 6),
                    for (final bullet in section.bullets)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('•  '),
                            Expanded(child: BoldText(bullet, style: const TextStyle(fontSize: 13, height: 1.4))),
                          ],
                        ),
                      ),
                  ],
                  if (experience.technologies.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    for (final tech in experience.technologies)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 3),
                        child: BoldText('${tech.label}: ${tech.content}', style: const TextStyle(fontSize: 12.5)),
                      ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
