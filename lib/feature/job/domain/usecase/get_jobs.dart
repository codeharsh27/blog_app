import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entity/job.dart';
import '../repository/job_repository.dart';

class GetJobsParams {
  final bool forceRemote;
  GetJobsParams({this.forceRemote = false});
}

class GetJobs implements Usecase<List<Job>, GetJobsParams> {
  final JobRepository repository;

  GetJobs(this.repository);

  @override
  Future<Either<Failure, List<Job>>> call(GetJobsParams params) async {
    if (params.forceRemote) {
      return await repository.getRemoteJobs();
    } else {
      return await repository.getCachedJobs();
    }
  }
}
