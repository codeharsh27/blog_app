part of 'job_bloc.dart';

@immutable
sealed class JobState {}

final class JobInitial extends JobState {}

final class JobLoading extends JobState {}

final class JobFailure extends JobState {
  final String error;
  JobFailure(this.error);
}

final class JobDisplaySuccess extends JobState {
  final List<Job> jobs;
  final String selectedFilter;
  JobDisplaySuccess(this.jobs, {this.selectedFilter = 'Popular'});
}
