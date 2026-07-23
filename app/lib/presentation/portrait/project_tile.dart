import 'package:flutter/material.dart';
import 'package:portfolio/data/models/project.dart';
import 'package:portfolio/presentation/portrait/project_detail_page.dart';
import 'package:portfolio/presentation/portrait/technical_stack_widget.dart';

class ProjectTile extends StatelessWidget {
  final Project project;
  const ProjectTile({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ProjectDetailPage(project: project)),
      ),
      child: SizedBox(
        width: 260,
        child: Card(
          elevation: 0,
          color: colorScheme.surfaceContainerHighest,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        project.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                    if (project.nda) Icon(Icons.lock_outline, size: 16, color: colorScheme.onSurfaceVariant),
                  ],
                ),
                const SizedBox(height: 6),
                Expanded(
                  child: Text(
                    project.description,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12.5, color: colorScheme.onSurfaceVariant),
                  ),
                ),
                const SizedBox(height: 8),
                TechChipList(project.techChips),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
