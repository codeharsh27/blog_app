import 'package:flutter/material.dart';
import '../../domain/entity/job_essential.dart';
import 'package:url_launcher/url_launcher.dart';

class JobViewerPage extends StatelessWidget {
  final JobEssential job;
  const JobViewerPage({super.key, required this.job});

  static Route route(JobEssential job) =>
      MaterialPageRoute(builder: (_) => JobViewerPage(job: job));

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(job.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(job.company, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 6),
            Text(job.location),
            const SizedBox(height: 12),
            Text("Skills Required:",
                style:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 6,
              children:
              job.skills.map((skill) => Chip(label: Text(skill))).toList(),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () => _launchUrl(job.applyUrl),
              child: const Text("Apply on Website"),
            )
          ],
        ),
      ),
    );
  }
}
