import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PortfolioLandscapeApp extends StatelessWidget {
  const PortfolioLandscapeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      home: const LandScapeView(),
    );
  }
}

class LandScapeView extends StatelessWidget {
  const LandScapeView({super.key});

  static const _email = 'huy.vanminh@returnself.studio';
  static const _github = 'https://github.com/arlix-returnself';
  static const _portfolio = 'https://arlix-returnself.github.io/portfolio';
  static const _phone = '+84 354 726 583';
  static const _cvUrl = 'https://arlix-returnself.github.io/portfolio';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Văn Minh Huy'),
        centerTitle: true,
        actions: [
          TextButton.icon(
            onPressed: () => _launchUrl(Uri.parse(_cvUrl)),
            icon: const Icon(Icons.download_rounded, color: Colors.white),
            label: const Text('Download CV', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 900;
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 1200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHero(context, isWide),
                const SizedBox(height: 28),
                _buildSectionsGrid(isWide),
                const SizedBox(height: 28),
                const Divider(),
                const SizedBox(height: 12),
                _buildProjectsSection(context, isWide),
                const SizedBox(height: 28),
                _buildContactSection(context),
                const SizedBox(height: 40),
                Center(child: Text('© ${_year()} Văn Minh Huy')),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildHero(BuildContext context, bool isWide) {
    return isWide
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _profileCard(160),
              const SizedBox(width: 28),
              Expanded(child: _introCard()),
            ],
          )
        : Column(
            children: [
              _profileCard(120),
              const SizedBox(height: 14),
              _introCard(),
            ],
          );
  }

  Widget _profileCard(double size) {
    return SizedBox(
      width: size,
      height: size,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            'https://avatars.githubusercontent.com/u/your_github_id?s=400&v=4', // replace with hosted avatar or local asset
            fit: BoxFit.cover,
            errorBuilder: (c, e, s) => Container(
              color: Colors.indigo.shade50,
              child: const Icon(Icons.person, size: 64, color: Colors.indigo),
            ),
          ),
        ),
      ),
    );
  }

  Widget _introCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Mobile Developer — Flutter', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Text(
          'Dedicated mobile developer with 3.5 years building cross-platform and native apps. Experienced in leading teams, designing scalable architectures, and shipping production apps to iOS & Android.',
          style: TextStyle(fontSize: 15, color: Colors.grey.shade800),
        ),
        const SizedBox(height: 12),
        Wrap(spacing: 8, runSpacing: 8, children: _skillChips()),
        const SizedBox(height: 12),
        Row(children: [
          ElevatedButton.icon(
            onPressed: () => _launchUrl(Uri.parse(_portfolio)),
            icon: const Icon(Icons.web),
            label: const Text('Full portfolio'),
          ),
          const SizedBox(width: 8),
          OutlinedButton.icon(
            onPressed: () => _launchEmail(_email, subject: 'Hi Huy — Opportunity'),
            icon: const Icon(Icons.mail_outline),
            label: const Text('Contact'),
          ),
        ])
      ],
    );
  }

  List<Widget> _skillChips() {
    const skills = [
      'Flutter', 'Dart', 'Kotlin', 'Jetpack Compose', 'React Native', 'SwiftUI', 'CI/CD', 'Fastlane', 'AWS', 'Docker'
    ];
    return skills.map((s) => Chip(label: Text(s))).toList();
  }

  Widget _buildSectionsGrid(bool isWide) {
    return isWide
        ? Row(children: [Expanded(child: _buildAboutCard()), const SizedBox(width: 16), Expanded(child: _buildExperienceCard())])
        : Column(children: [_buildAboutCard(), const SizedBox(height: 12), _buildExperienceCard()]);
  }

  Widget _buildAboutCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
          Text('About', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          SizedBox(height: 8),
          Text('I build mobile apps with a strong focus on clean architecture, automated delivery, and delightful UX. I enjoy mentoring teams and improving development processes.'),
        ]),
      ),
    );
  }

  Widget _buildExperienceCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
          Text('Experience', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          SizedBox(height: 8),
          Text('• Mobile Development Team Lead — AEGONA (Feb 2022 - Sep 2025)\n• 3.5 years building cross-platform & native apps\n• CI/CD, Fastlane, Docker, AWS'),
        ]),
      ),
    );
  }

  Widget _buildProjectsSection(BuildContext context, bool isWide) {
    final projects = sampleProjects;
    final crossAxis = isWide ? 3 : (MediaQuery.of(context).size.width > 600 ? 2 : 1);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Selected Projects', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
      const SizedBox(height: 12),
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: projects.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxis,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.4,
        ),
        itemBuilder: (context, idx) => _projectCard(projects[idx]),
      )
    ]);
  }

  Widget _projectCard(Project p) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(p.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Expanded(child: Text(p.description, style: const TextStyle(fontSize: 13))),
          const SizedBox(height: 8),
          Wrap(spacing: 6, children: p.tags.map((t) => Chip(label: Text(t))).toList()),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(onPressed: () => _launchUrl(Uri.parse(p.link)), child: const Text('Details')),
          )
        ]),
      ),
    );
  }

  Widget _buildContactSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Contact', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Row(children: [
            const Icon(Icons.email_outlined),
            const SizedBox(width: 8),
            SelectableText(_email),
            const SizedBox(width: 16),
            OutlinedButton(onPressed: () => _launchEmail(_email), child: const Text('Send email')),
          ]),
          const SizedBox(height: 8),
          Row(children: [
            const Icon(Icons.link),
            const SizedBox(width: 8),
            SelectableText(_github),
            const SizedBox(width: 16),
            OutlinedButton(onPressed: () => _launchUrl(Uri.parse(_github)), child: const Text('GitHub')),
          ]),
          const SizedBox(height: 8),
          Row(children: [
            const Icon(Icons.phone),
            const SizedBox(width: 8),
            SelectableText(_phone),
          ])
        ]),
      ),
    );
  }

  static Future<void> _launchUrl(Uri uri) async {
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      // ignore: avoid_print
      print('Could not launch $uri');
    }
  }

  static Future<void> _launchEmail(String to, {String subject = '', String body = ''}) async {
    final uri = Uri(
      scheme: 'mailto',
      path: to,
      queryParameters: {'subject': subject, 'body': body},
    );
    await _launchUrl(uri);
  }

  static int _year() => DateTime.now().year;
}

class Project {
  final String title;
  final String description;
  final List<String> tags;
  final String link;

  Project({required this.title, required this.description, required this.tags, required this.link});
}

final sampleProjects = [
  Project(
    title: 'FixME (Flutter, Golang)',
    description: 'Service-booking app for home cleaning and appliance repair. Google Maps, VNPay, MoMo, Fastlane CI/CD.',
    tags: ['Flutter', 'Golang', 'Maps', 'Payments'],
    link: 'https://example.com/fixme',
  ),
  Project(
    title: 'Pre:MIND (Flutter, Django)',
    description: 'Restaurant booking with custom iBeacon support and deep native integrations on iOS/Android.',
    tags: ['Flutter', 'Django', 'iBeacon'],
    link: 'https://example.com/premind',
  ),
  Project(
    title: 'Galaxy Pynt (Flutter)',
    description: 'Escape room booking platform with VNPay integration and automated iOS deployment scripts.',
    tags: ['Flutter', 'VNPay', 'CI/CD'],
    link: 'https://example.com/galaxypynt',
  ),
  Project(
    title: 'NLCS - Sancro (SwiftUI)',
    description: 'Student verification app using ClearPass API and Apple School Manager workflows.',
    tags: ['SwiftUI', 'ASM', 'ClearPass'],
    link: 'https://example.com/nlcs',
  ),
  Project(
    title: 'Simap (Kotlin, Jetpack Compose)',
    description: 'Native Android app for managing room-heating devices with barcode & NFC scanning.',
    tags: ['Kotlin', 'Compose', 'NFC'],
    link: 'https://example.com/simap',
  ),
];
