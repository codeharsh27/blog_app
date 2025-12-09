part of 'job_bloc.dart';

@immutable
sealed class JobEvent {}

final class JobFetchAllJobs extends JobEvent {}

final class JobFilterSelect extends JobEvent {
  final String filter;
  JobFilterSelect(this.filter);
}

final class JobToggleSave extends JobEvent {
  final Job job;
  JobToggleSave(this.job);
}

final class JobSearch extends JobEvent {
  final String query;
  JobSearch(this.query);
}
