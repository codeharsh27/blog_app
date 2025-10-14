import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/job_model.dart';

class JobApi {
  final http.Client client;
  final String baseUrl;
  final String apiKey;

  JobApi({required this.client, required this.baseUrl, required this.apiKey});

  Future<List<JobModel>> fetchJobs({int page = 1, String? query}) async {
    // many APIs accept apiKey as query; others use headers. Adjust accordingly.
    final uri = Uri.parse('$baseUrl?page=$page${query != null ? '&q=${Uri.encodeQueryComponent(query)}' : ''}&api_key=$apiKey');

    final res = await client.get(uri, headers: {
      // 'Authorization': 'Bearer $apiKey', // uncomment if needed by your API
      'Accept': 'application/json',
    });

    if (res.statusCode != 200) {
      throw Exception('Failed to load jobs: ${res.statusCode}');
    }

    final Map<String, dynamic> jsonMap = jsonDecode(res.body);
    // adjust key depending on API: 'results' | 'data' | 'jobs'
    final items = jsonMap['results'] ?? jsonMap['data'] ?? jsonMap['jobs'] ?? [];
    return (items as List).map((e) => JobModel.fromJson(e as Map<String, dynamic>)).toList();
  }
}
