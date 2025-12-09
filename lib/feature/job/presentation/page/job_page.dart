import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lottie/lottie.dart';
import '../../../../core/common/cubit/app_user/app_user_cubit.dart';
import '../../../profile/presentation/pages/profile_details_page.dart';
import '../bloc/job_bloc.dart';
import '../widget/job_card.dart';

class JobsPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (_) => const JobsPage());
  const JobsPage({super.key});

  @override
  State<JobsPage> createState() => _JobsPageState();
}

class _JobsPageState extends State<JobsPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _showProfilePopup = true;

  @override
  void initState() {
    super.initState();
    context.read<JobBloc>().add(JobFetchAllJobs());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: BlocBuilder<AppUserCubit, AppUserState>(
          builder: (context, state) {
            String userName = 'Buddy';
            if (state is AppUserLoggedIn) {
              userName = state.user.name;
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hi',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            );
          },
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFBBDEFB), Colors.white],
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                _buildAppBarIcon(
                  icon: Icons.notifications_none_rounded,
                  onTap: () => _showNotificationDialog(context),
                ),
                const SizedBox(width: 12),
                _buildAppBarIcon(
                  icon: Icons.bookmark_border_rounded,
                  onTap: () => _showSavedJobsDialog(context),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async {
              context.read<JobBloc>().add(JobFetchAllJobs());
            },
            child: BlocBuilder<JobBloc, JobState>(
              builder: (context, state) {
                if (state is JobLoading) {
                  return Center(
                    child: Lottie.asset(
                      'assets/lottie/transition.json',
                      height: 200,
                      errorBuilder: (context, error, stackTrace) {
                        return const CircularProgressIndicator();
                      },
                    ),
                  );
                }
                if (state is JobFailure) {
                  return Center(child: Text(state.error));
                }
                if (state is JobDisplaySuccess) {
                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Search Bar
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Colors.grey[200]!),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 12),
                              const Icon(
                                Icons.search,
                                color: Colors.grey,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  textAlignVertical: TextAlignVertical.center,
                                  style: const TextStyle(fontSize: 16),
                                  onSubmitted: (value) {
                                    context.read<JobBloc>().add(
                                      JobSearch(value),
                                    );
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Search for jobs...',
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 16,
                                    ),
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                    suffixIcon:
                                        ValueListenableBuilder<
                                          TextEditingValue
                                        >(
                                          valueListenable: _searchController,
                                          builder: (context, value, child) {
                                            if (value.text.isEmpty) {
                                              return const SizedBox.shrink();
                                            }
                                            return GestureDetector(
                                              onTap: () {
                                                _searchController.clear();
                                                context.read<JobBloc>().add(
                                                  JobSearch(''),
                                                );
                                                FocusScope.of(
                                                  context,
                                                ).unfocus();
                                              },
                                              child: Icon(
                                                Icons.close,
                                                size: 20,
                                                color: Colors.grey[400],
                                              ),
                                            );
                                          },
                                        ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () {
                                  context.read<JobBloc>().add(
                                    JobSearch(_searchController.text),
                                  );
                                  FocusScope.of(context).unfocus();
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: const BoxDecoration(
                                    color: Colors.black,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),

                        // Job Categories
                        SizedBox(
                          height: 40,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 4,
                            itemBuilder: (context, index) {
                              final categories = [
                                {'icon': Icons.star_border, 'label': 'Popular'},
                                {
                                  'icon': Icons.business_center,
                                  'label': 'Full Time',
                                },
                                {
                                  'icon': Icons.work_outline,
                                  'label': 'Part Time',
                                },
                                {
                                  'icon': Icons.people_outline,
                                  'label': 'Remote',
                                },
                              ];
                              final category = categories[index];
                              final label = category['label'] as String;
                              final isSelected = state.selectedFilter == label;

                              return GestureDetector(
                                onTap: () {
                                  context.read<JobBloc>().add(
                                    JobFilterSelect(label),
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Colors.black87
                                        : Colors.grey[100],
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.black87
                                          : Colors.grey[300]!,
                                      width: 1,
                                    ),
                                    boxShadow: [
                                      if (isSelected)
                                        const BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 4,
                                          offset: Offset(0, 2),
                                        ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        category['icon'] as IconData,
                                        size: 16,
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.grey[600],
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        label,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.grey[700],
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 24),

                        const Text(
                          'Matched Jobs',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Job Listings or No Results
                        if (state.jobs.isEmpty)
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 40),
                                // Using Lottie animation for "not found"
                                Lottie.asset(
                                  'assets/lottie/not_found.json',
                                  height: 250,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.search_off_rounded,
                                      size: 80,
                                      color: Colors.grey,
                                    );
                                  },
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Not Found!',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'No jobs found matching your search.',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.jobs.length,
                            itemBuilder: (context, index) {
                              final job = state.jobs[index];
                              return JobCard(job: job);
                            },
                          ),
                      ],
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          if (_showProfilePopup)
            Positioned.fill(
              child: Stack(
                children: [
                  // Popup Box
                  Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey[300]!),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Complete your Profile details to Match jobs",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Continue Now Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _showProfilePopup = false;
                                });
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ProfileDetailsPage(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                "Continue now",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Remind Me Later Button
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  _showProfilePopup = false;
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                side: BorderSide(color: Colors.grey[300]!),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                "Remind me later",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Dismiss Button
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  _showProfilePopup = false;
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                side: BorderSide(color: Colors.grey[300]!),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                "Dismiss",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAppBarIcon({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.black87, size: 20),
      ),
    );
  }

  void _showNotificationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Notifications',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildNotificationItem(
                'New Job Alert',
                'Software Engineer at Google',
                '2m ago',
              ),
              _buildNotificationItem(
                'Application Viewed',
                'Your application for Flutter Dev was viewed',
                '1h ago',
              ),
              _buildNotificationItem(
                'New Job Alert',
                'Senior React Developer at Meta',
                '3h ago',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationItem(String title, String body, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 6, right: 12),
            decoration: const BoxDecoration(
              color: Colors.pinkAccent,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
          Text(time, style: TextStyle(color: Colors.grey[400], fontSize: 10)),
        ],
      ),
    );
  }

  void _showSavedJobsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          width: 320,
          constraints: const BoxConstraints(maxHeight: 500),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Saved Jobs',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Flexible(
                child: BlocBuilder<JobBloc, JobState>(
                  builder: (context, state) {
                    if (state is JobDisplaySuccess) {
                      final savedJobs = state.jobs
                          .where((j) => j.isSaved)
                          .toList();
                      if (savedJobs.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.bookmark_border,
                                size: 48,
                                color: Colors.grey[300],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'No saved jobs yet',
                                style: TextStyle(color: Colors.grey[500]),
                              ),
                            ],
                          ),
                        );
                      }
                      return ListView.separated(
                        shrinkWrap: true,
                        itemCount: savedJobs.length,
                        separatorBuilder: (_, __) => const Divider(height: 24),
                        itemBuilder: (context, index) {
                          final job = savedJobs[index];
                          return Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(8),
                                  image: job.companyLogo != null
                                      ? DecorationImage(
                                          image: CachedNetworkImageProvider(
                                            job.companyLogo!,
                                          ),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                ),
                                child: job.companyLogo == null
                                    ? Center(
                                        child: Text(
                                          job.company[0].toUpperCase(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      job.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      job.company,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.bookmark,
                                  color: Colors.pinkAccent,
                                  size: 20,
                                ),
                                onPressed: () {
                                  context.read<JobBloc>().add(
                                    JobToggleSave(job),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
