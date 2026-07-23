import 'package:flutter/material.dart';

/// Generic tech-name chip, fed by free-form strings from profile.json
/// (e.g. project.techChips, skill item content) — no longer a fixed enum,
/// since the real data includes stacks (Next.js, Supabase, n8n, ...) that
/// a closed enum couldn't represent.
class TechChip extends StatelessWidget {
  const TechChip(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}

class TechChipList extends StatelessWidget {
  const TechChipList(this.items, {super.key});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return items.isEmpty
        ? const SizedBox()
        : Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [for (final item in items) TechChip(item)],
          );
  }
}
