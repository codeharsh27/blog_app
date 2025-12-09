import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../../core/secrets/job_secrets.dart';
import '../model/job_model.dart';

abstract class JobRemoteDataSource {
  Future<List<JobModel>> getJobs();
}

class JSearchRemoteDataSource implements JobRemoteDataSource {
  final http.Client client;

  JSearchRemoteDataSource(this.client);

  @override
  Future<List<JobModel>> getJobs() async {
    final headers = {
      'X-RapidAPI-Key': JobSecrets.rapidApiKey,
      'X-RapidAPI-Host': JobSecrets.rapidApiHost,
    };

    final queries = [
      'Software Developer in India',
      'Software Developer in USA',
    ];

    List<JobModel> allJobs = [];

    for (final query in queries) {
      try {
        final uri = Uri.parse(
          'https://jsearch.p.rapidapi.com/search',
        ).replace(queryParameters: {'query': query, 'num_pages': '1'});

        final response = await client.get(uri, headers: headers);

        if (response.statusCode == 200) {
          final jsonData = jsonDecode(response.body);
          if (jsonData['data'] != null) {
            final jobs = (jsonData['data'] as List)
                .map((job) => JobModel.fromJson(job))
                .toList();
            allJobs.addAll(jobs);
          }
        } else {
          debugPrint(
            'JSearch API Error: ${response.statusCode} - ${response.body}',
          );
        }
      } catch (e) {
        debugPrint('Error fetching jobs for query "$query": $e');
      }
    }

    return allJobs;
  }
}

class RemotiveRemoteDataSource implements JobRemoteDataSource {
  final http.Client client;

  RemotiveRemoteDataSource(this.client);

  @override
  Future<List<JobModel>> getJobs() async {
    try {
      final response = await client.get(
        Uri.parse('https://remotive.com/api/remote-jobs?category=software-dev'),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['jobs'] != null) {
          return (jsonData['jobs'] as List).map((job) {
            return JobModel(
              title: job['title'] ?? 'No title',
              company: job['company_name'] ?? 'Unknown Company',
              location: job['candidate_required_location'] ?? 'Remote',
              employmentType: job['job_type'] ?? 'Full-time',
              applyUrl: job['url'] ?? '',
              postedAt: job['publication_date'] != null
                  ? DateTime.tryParse(job['publication_date'])
                  : null,
              description: job['description'] ?? '',
              skills:
                  [], // Remotive tags are sometimes in description or tags list, keeping simple for now
              companyLogo: job['company_logo'],
              isSaved: false,
            );
          }).toList();
        }
      }
    } catch (e) {
      debugPrint('Remotive API Error: $e');
    }
    return [];
  }
}
