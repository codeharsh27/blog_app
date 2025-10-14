import 'package:flutter_bloc/flutter_bloc.dart';
import 'job_event.dart';
import 'job_state.dart';
import '../../data/repository/job_repository.dart';

class JobBloc extends Bloc<JobEvent, JobState> {
  final JobRepository repository;
  int _page = 1;
  bool _isFetching = false;

  JobBloc(this.repository) : super(JobInitial()) {
    on<FetchJobs>(_onFetchJobs);
    on<FetchMoreJobs>(_onFetchMoreJobs);
  }

  Future<void> _onFetchJobs(FetchJobs event, Emitter<JobState> emit) async {
    try {
      emit(JobLoading());
      _page = 1;
      final jobs = await repository.getJobs(page: _page, query: event.query);
      emit(JobLoaded(jobs: jobs, hasMore: jobs.length >= 20, page: _page));
    } catch (e) {
      emit(JobError(e.toString()));
    }
  }

  Future<void> _onFetchMoreJobs(FetchMoreJobs event, Emitter<JobState> emit) async {
    if (_isFetching) return;
    final current = state;
    if (current is JobLoaded && current.hasMore) {
      _isFetching = true;
      try {
        final nextPage = current.page + 1;
        final more = await repository.getJobs(page: nextPage);
        final all = List.of(current.jobs)..addAll(more);
        emit(JobLoaded(jobs: all, hasMore: more.isNotEmpty, page: nextPage));
      } catch (e) {
        // keep current data and ignore additional error or emit error if you prefer
        emit(JobError(e.toString()));
      } finally {
        _isFetching = false;
      }
    }
  }
}
