import 'package:flutter/material.dart';
import '../../data/model/job_model.dart';
import '../../domain/entity/job.dart';
import '../../domain/entity/job_essential.dart';
import '../widget/job_card.dart';

class JobsPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (_) => const JobsPage());
  const JobsPage({super.key});

  @override
  State<JobsPage> createState() => _JobsPageState();
}

class _JobsPageState extends State<JobsPage> {
  List<JobModel> jobs = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    getJobs();
  }

  Future<void> getJobs() async {
    try {
      final jobsClass = Jobs();
      await jobsClass.getJobs();
      setState(() {
        jobs = jobsClass.jobs;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        jobs = [];
      });
      debugPrint("Error fetching jobs: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.work, size: 28),
            SizedBox(width: 6),
            Text(
              'Jobs',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : jobs.isEmpty
          ? const Center(child: Text("No jobs available right now."))
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: jobs.length,
        itemBuilder: (context, index) {
          final jobItem = JobEssential(
            title: jobs[index].title,
            company: jobs[index].company,
            location: jobs[index].location,
            employmentType: jobs[index].employmentType,
            skills: jobs[index].skills ?? [],
            applyUrl: jobs[index].applyUrl,
            postedAt: jobs[index].postedAt,
          );
          return JobCard(job: jobItem);
        },
      ),
    );
  }
}
