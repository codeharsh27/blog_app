import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/secrets/job_secrets.dart';
import '../../data/model/job_model.dart';

class Jobs {
  List<JobModel> jobs = [];

  Future<void> getJobs() async {
    final url = Uri.parse(
        'https://api.adzuna.com/v1/api/jobs/gb/search/1?app_id=${JobSecrets.appId}&app_key=${JobSecrets.apiKey}'
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      if (jsonData['results'] != null) {
        jobs = (jsonData['results'] as List)
            .map((job) => JobModel.fromJson(job))
            .toList();
      }
    } else {
      throw Exception("Failed to load jobs. Status: ${response.statusCode}");
    }
  }
}
