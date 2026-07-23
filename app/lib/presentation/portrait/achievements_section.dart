import 'package:flutter/material.dart';
import 'package:portfolio/presentation/widgets/bold_text.dart';

class AchievementsSection extends StatelessWidget {
  const AchievementsSection({super.key, required this.achievements});

  final List<String> achievements;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Achievements', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            for (final achievement in achievements)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.star_rounded, size: 18, color: colorScheme.primary),
                    const SizedBox(width: 8),
                    Expanded(child: BoldText(achievement, style: const TextStyle(fontSize: 13.5, height: 1.4))),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
