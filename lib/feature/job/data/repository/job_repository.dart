import '../datasource/job_datasource.dart';
import '../model/job_model.dart';

abstract class JobRepository {
  Future<List<JobModel>> getJobs({int page, String? query});
}

class JobRepositoryImpl implements JobRepository {
  final JobApi api;
  JobRepositoryImpl(this.api);

  @override
  Future<List<JobModel>> getJobs({int page = 1, String? query}) =>
      api.fetchJobs(page: page, query: query);
}
