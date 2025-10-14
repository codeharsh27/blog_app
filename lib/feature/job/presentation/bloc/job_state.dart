import 'package:equatable/equatable.dart';
import '../../data/model/job_model.dart';

abstract class JobState extends Equatable {
  @override List<Object?> get props => [];
}

class JobInitial extends JobState {}
class JobLoading extends JobState {}
class JobLoaded extends JobState {
  final List<JobModel> jobs;
  final bool hasMore;
  final int page;
  JobLoaded({required this.jobs, required this.hasMore, required this.page});
  @override List<Object?> get props => [jobs, hasMore, page];
}
class JobError extends JobState {
  final String message;
  JobError(this.message);
  @override List<Object?> get props => [message];
}
