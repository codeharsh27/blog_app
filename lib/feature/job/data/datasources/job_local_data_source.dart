import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/job_model.dart';

abstract class JobLocalDataSource {
  Future<void> uploadLocalJobs(List<JobModel> jobs);
  Future<List<JobModel>> loadJobs();
  Future<List<String>> getSavedJobIds();
  Future<void> toggleSavedJob(String jobId);
}

class JobLocalDataSourceImpl implements JobLocalDataSource {
  final SharedPreferences sharedPreferences;

  JobLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<List<JobModel>> loadJobs() async {
    final jsonString = sharedPreferences.getString('CACHED_JOBS');
    final lastFetchTime = sharedPreferences.getInt('LAST_FETCH_TIME');
    final savedIds = await getSavedJobIds();

    if (jsonString != null && lastFetchTime != null) {
      final now = DateTime.now().millisecondsSinceEpoch;
      // 24 hours = 86400000 milliseconds
      if (now - lastFetchTime < 86400000) {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        return jsonList.map((jobJson) {
          final job = JobModel.fromJson(jobJson);
          // Check if saved
          // We need a unique ID. Using title + company as ID for now since API doesn't give one.
          final id = '${job.title}_${job.company}';
          return JobModel(
            title: job.title,
            company: job.company,
            location: job.location,
            employmentType: job.employmentType,
            applyUrl: job.applyUrl,
            postedAt: job.postedAt,
            description: job.description,
            skills: job.skills,
            companyLogo: job.companyLogo,
            isSaved: savedIds.contains(id),
          );
        }).toList();
      }
    }
    return [];
  }

  @override
  Future<void> uploadLocalJobs(List<JobModel> jobs) async {
    final jsonList = jobs.map((job) => job.toJson()).toList();
    await sharedPreferences.setString('CACHED_JOBS', jsonEncode(jsonList));
    await sharedPreferences.setInt(
      'LAST_FETCH_TIME',
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  @override
  Future<List<String>> getSavedJobIds() async {
    return sharedPreferences.getStringList('SAVED_JOB_IDS') ?? [];
  }

  @override
  Future<void> toggleSavedJob(String jobId) async {
    final savedIds = sharedPreferences.getStringList('SAVED_JOB_IDS') ?? [];
    if (savedIds.contains(jobId)) {
      savedIds.remove(jobId);
    } else {
      savedIds.add(jobId);
    }
    await sharedPreferences.setStringList('SAVED_JOB_IDS', savedIds);
  }
}
