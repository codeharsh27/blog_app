import 'package:flutter/material.dart';
import '../../data/model/job_model.dart';
import '../../domain/entity/job.dart';
import '../../domain/entity/job_essential.dart';
import '../widget/job_card.dart';
import '../../../../core/theme/app_pallet.dart';

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
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppPallete.primaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.work_rounded, size: 28, color: AppPallete.primaryColor),
            ),
            const SizedBox(width: 12),
            Text(
              'Job Opportunities',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppPallete.whiteColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        backgroundColor: AppPallete.transparentColor,
        elevation: 0,
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(
                color: AppPallete.primaryColor,
              ),
            )
          : jobs.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.work_off_rounded,
                    size: 64,
                    color: AppPallete.textSecondary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "No jobs available right now.",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppPallete.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Check back later for new opportunities!",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppPallete.textSecondary,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
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
