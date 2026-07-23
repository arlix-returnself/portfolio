import 'package:flutter/material.dart';
import 'package:portfolio/data/models/project.dart';
import 'package:portfolio/presentation/portrait/technical_stack_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectDetailPage extends StatelessWidget {
  final Project project;
  const ProjectDetailPage({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final link = project.link;
    return Scaffold(
      appBar: AppBar(title: Text(project.title)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (project.nda)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(Icons.lock_outline, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
                    const SizedBox(width: 6),
                    Text('Confidential / NDA', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 13)),
                  ],
                ),
              ),
            Text(project.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TechChipList(project.techChips),
            const SizedBox(height: 16),
            Text(project.description, style: const TextStyle(height: 1.5)),
            if (link != null) ...[
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => launchUrl(Uri.parse(link), mode: LaunchMode.externalApplication),
                icon: const Icon(Icons.open_in_new),
                label: const Text('View project'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
