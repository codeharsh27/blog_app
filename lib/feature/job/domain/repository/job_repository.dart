import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failure.dart';
import '../entity/job.dart';

abstract class JobRepository {
  Future<Either<Failure, List<Job>>> getRemoteJobs();
  Future<Either<Failure, List<Job>>> getCachedJobs();
  Future<Either<Failure, void>> toggleSaveJob(String jobId);
}
