import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/common/cubit/app_user/app_user_cubit.dart';
import '../../domain/entity/job.dart';
import '../../domain/usecase/get_jobs.dart';
import '../../domain/usecase/skill_matcher.dart';
import '../../domain/repository/job_repository.dart';

part 'job_event.dart';
part 'job_state.dart';

class JobBloc extends Bloc<JobEvent, JobState> {
  final GetJobs _getJobs;
  final SkillMatcher _skillMatcher;
  final AppUserCubit _appUserCubit;
  final JobRepository _jobRepository;

  List<Job> _allJobs = [];

  JobBloc({
    required GetJobs getJobs,
    required SkillMatcher skillMatcher,
    required AppUserCubit appUserCubit,
    required JobRepository jobRepository,
  }) : _getJobs = getJobs,
       _skillMatcher = skillMatcher,
       _appUserCubit = appUserCubit,
       _jobRepository = jobRepository,
       super(JobInitial()) {
    on<JobFetchAllJobs>(_onFetchJobs);
    on<JobFilterSelect>(_onFilterSelect);
    on<JobToggleSave>(_onToggleSave);
    on<JobSearch>(_onSearch);
  }

  void _onSearch(JobSearch event, Emitter<JobState> emit) {
    debugPrint('JobBloc: Searching for ${event.query}');
    final query = event.query.toLowerCase();

    if (query.isEmpty) {
      emit(JobDisplaySuccess(_allJobs));
      return;
    }

    final filteredJobs = _allJobs.where((job) {
      final title = job.title.toLowerCase();
      final company = job.company.toLowerCase();
      return title.contains(query) || company.contains(query);
    }).toList();

    emit(JobDisplaySuccess(filteredJobs));
  }

  void _onFetchJobs(JobFetchAllJobs event, Emitter<JobState> emit) async {
    emit(JobLoading());

    // 1. Fetch Cached Jobs
    final cachedRes = await _getJobs(GetJobsParams(forceRemote: false));
    cachedRes.fold(
      (failure) {
        // If cache fails, just log it and proceed to remote
        debugPrint('Cache fetch failed: ${failure.message}');
      },
      (jobs) {
        if (jobs.isNotEmpty) {
          _processAndEmitJobs(jobs, emit);
        }
      },
    );

    // 2. Fetch Remote Jobs
    final remoteRes = await _getJobs(GetJobsParams(forceRemote: true));
    remoteRes.fold(
      (failure) {
        // Only emit failure if we have no jobs at all (cache was empty)
        if (_allJobs.isEmpty) {
          emit(JobFailure(failure.message));
        }
      },
      (jobs) {
        _processAndEmitJobs(jobs, emit);
      },
    );
  }

  void _processAndEmitJobs(List<Job> jobs, Emitter<JobState> emit) {
    final userState = _appUserCubit.state;
    if (userState is AppUserLoggedIn) {
      final user = userState.user;

      // Calculate match scores
      _allJobs = jobs.map((job) {
        final score = _skillMatcher.match(user, job);
        return Job(
          title: job.title,
          company: job.company,
          location: job.location,
          employmentType: job.employmentType,
          applyUrl: job.applyUrl,
          postedAt: job.postedAt,
          description: job.description,
          skills: job.skills,
          matchScore: score,
          companyLogo: job.companyLogo,
          isSaved: job.isSaved,
        );
      }).toList();

      // Sort by match score descending
      _allJobs.sort((a, b) {
        final scoreA = a.matchScore ?? 0.0;
        final scoreB = b.matchScore ?? 0.0;
        return scoreB.compareTo(scoreA);
      });
    } else {
      _allJobs = jobs;
    }
    emit(JobDisplaySuccess(_allJobs));
  }

  void _onFilterSelect(JobFilterSelect event, Emitter<JobState> emit) {
    if (_allJobs.isEmpty) return;

    final filter = event.filter;
    List<Job> filteredJobs = [];

    if (filter == 'Popular') {
      filteredJobs = List.from(_allJobs);
    } else if (filter == 'Remote') {
      filteredJobs = _allJobs.where((job) {
        final loc = job.location.toLowerCase();
        final type = job.employmentType.toLowerCase();
        return loc.contains('remote') || type.contains('remote');
      }).toList();
    } else if (filter == 'Full Time') {
      filteredJobs = _allJobs.where((job) {
        return job.employmentType.toLowerCase().contains('full');
      }).toList();
    } else if (filter == 'Part Time') {
      filteredJobs = _allJobs.where((job) {
        return job.employmentType.toLowerCase().contains('part');
      }).toList();
    } else {
      filteredJobs = List.from(_allJobs);
    }

    emit(JobDisplaySuccess(filteredJobs, selectedFilter: filter));
  }

  void _onToggleSave(JobToggleSave event, Emitter<JobState> emit) async {
    final job = event.job;
    final jobId = '${job.title}_${job.company}';

    // Optimistic update
    final updatedJob = Job(
      title: job.title,
      company: job.company,
      location: job.location,
      employmentType: job.employmentType,
      applyUrl: job.applyUrl,
      postedAt: job.postedAt,
      description: job.description,
      skills: job.skills,
      matchScore: job.matchScore,
      companyLogo: job.companyLogo,
      isSaved: !job.isSaved,
    );

    // Update _allJobs
    final index = _allJobs.indexWhere(
      (j) => j.title == job.title && j.company == job.company,
    );
    if (index != -1) {
      _allJobs[index] = updatedJob;
    }

    // Emit current state with updated list directly for instant feedback
    if (state is JobDisplaySuccess) {
      final currentFilter = (state as JobDisplaySuccess).selectedFilter;

      // Re-apply filter logic locally to avoid async event delay
      List<Job> filteredJobs = [];
      if (currentFilter == 'Popular') {
        filteredJobs = List.from(_allJobs);
      } else if (currentFilter == 'Remote') {
        filteredJobs = _allJobs.where((job) {
          final loc = job.location.toLowerCase();
          final type = job.employmentType.toLowerCase();
          return loc.contains('remote') || type.contains('remote');
        }).toList();
      } else if (currentFilter == 'Full Time') {
        filteredJobs = _allJobs.where((job) {
          return job.employmentType.toLowerCase().contains('full');
        }).toList();
      } else if (currentFilter == 'Part Time') {
        filteredJobs = _allJobs.where((job) {
          return job.employmentType.toLowerCase().contains('part');
        }).toList();
      } else {
        filteredJobs = List.from(_allJobs);
      }

      emit(JobDisplaySuccess(filteredJobs, selectedFilter: currentFilter));
    }

    // Persist change
    final res = await _jobRepository.toggleSaveJob(jobId);
    res.fold((l) {
      debugPrint('Failed to save job: ${l.message}');
      // Revert optimistic update if failed (optional, but good practice)
      // For now, we keep it simple as failure is rare.
    }, (r) => null);
  }
}
