import 'package:flutter/material.dart';
import 'package:portfolio/data/models/project.dart';
import 'package:portfolio/presentation/portrait/project_tile.dart';

class ProjectShowcaseSection extends StatelessWidget {
  const ProjectShowcaseSection({super.key, required this.categories, required this.projects});

  final List<ProjectCategory> categories;
  final List<Project> projects;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Projects', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            for (final category in categories) ...[
              _CategoryProjects(category: category, projects: projects.where((p) => p.category == category.id).toList()),
              if (category != categories.last) const SizedBox(height: 20),
            ],
          ],
        ),
      ),
    );
  }
}

class _CategoryProjects extends StatelessWidget {
  const _CategoryProjects({required this.category, required this.projects});

  final ProjectCategory category;
  final List<Project> projects;

  @override
  Widget build(BuildContext context) {
    if (projects.isEmpty) return const SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(category.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        SizedBox(
          height: 190,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: projects.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (_, index) => ProjectTile(project: projects[index]),
          ),
        ),
      ],
    );
  }
}
