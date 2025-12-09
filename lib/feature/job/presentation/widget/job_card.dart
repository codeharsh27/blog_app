import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entity/job.dart';
import '../bloc/job_bloc.dart';

class JobCard extends StatelessWidget {
  final Job job;
  const JobCard({super.key, required this.job});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey[200]!, width: 1),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(158, 158, 158, 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Logo + Company + Bookmark
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF6C5CE7), // Purple brand color
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: job.companyLogo != null
                      ? CachedNetworkImage(
                          imageUrl: job.companyLogo!,
                          fit: BoxFit.cover,
                          // Optimize memory usage
                          memCacheHeight: 100,
                          memCacheWidth: 100,
                          maxHeightDiskCache: 100,
                          maxWidthDiskCache: 100,
                          // Remove custom headers that might be triggering 403s
                          // httpHeaders: const { ... },
                          placeholder: (context, url) => Container(
                            color: const Color(0xFF6C5CE7),
                            child: Center(
                              child: Text(
                                job.company.isNotEmpty
                                    ? job.company[0].toUpperCase()
                                    : 'C',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: const Color(0xFF6C5CE7),
                            child: Center(
                              child: Text(
                                job.company.isNotEmpty
                                    ? job.company[0].toUpperCase()
                                    : 'C',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        )
                      : Center(
                          child: Text(
                            job.company.isNotEmpty
                                ? job.company[0].toUpperCase()
                                : 'C',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job.company,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              if (job.matchScore != null && job.matchScore! > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green[200]!),
                  ),
                  child: Text(
                    '${job.matchScore!.toInt()}% Match',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  context.read<JobBloc>().add(JobToggleSave(job));
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: job.isSaved ? Colors.pink[50] : Colors.grey[100],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    job.isSaved ? Icons.bookmark : Icons.bookmark_border,
                    color: job.isSaved ? Colors.pink[400] : Colors.grey[600],
                    size: 20,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Job Title
          Text(
            job.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              height: 1.2,
            ),
          ),

          const SizedBox(height: 24),

          // Info Grid
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(Icons.location_on_outlined, job.location),
              ),
              Expanded(
                child: _buildInfoItem(Icons.access_time, job.employmentType),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  Icons.work_outline,
                  'Senior level', // Placeholder as Adzuna might not give level
                ),
              ),
              Expanded(
                child: _buildInfoItem(
                  Icons.attach_money,
                  '\$10k/mo - 250/mo', // Placeholder
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Apply Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                if (job.applyUrl.isNotEmpty) {
                  _launchUrl(job.applyUrl);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Apply',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[400]),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[800],
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
