import 'package:flutter/material.dart';
import 'package:portfolio/presentation/widgets/bold_text.dart';

class SummarySection extends StatelessWidget {
  const SummarySection({super.key, required this.summary});

  final List<String> summary;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('About', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            for (final paragraph in summary) ...[
              BoldText(paragraph, style: const TextStyle(height: 1.5)),
              if (paragraph != summary.last) const SizedBox(height: 10),
            ],
          ],
        ),
      ),
    );
  }
}
