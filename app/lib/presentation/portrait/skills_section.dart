import 'package:flutter/material.dart';
import 'package:portfolio/data/models/skill_category.dart';
import 'package:portfolio/presentation/widgets/bold_text.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key, required this.skills});

  final List<SkillCategory> skills;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Skills', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            for (final category in skills) ...[
              _SkillCategoryCard(category: category),
              if (category != skills.last) const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }
}

class _SkillCategoryCard extends StatelessWidget {
  const _SkillCategoryCard({required this.category});

  final SkillCategory category;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(category.icon, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Text(category.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 8),
          for (final item in category.items)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: BoldText(
                '${item.label}: ${item.content}',
                style: const TextStyle(fontSize: 13),
              ),
            ),
        ],
      ),
    );
  }
}
