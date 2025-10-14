import 'package:flutter/material.dart';
import '../../domain/entity/job_essential.dart';
import '../../../../core/theme/app_pallet.dart';

class JobCard extends StatelessWidget {
  final JobEssential job;
  const JobCard({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      decoration: BoxDecoration(
        color: AppPallete.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppPallete.borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppPallete.primaryColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Job Title
            Text(
              job.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppPallete.whiteColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            /// Company
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppPallete.primaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppPallete.primaryColor, width: 1),
              ),
              child: Text(
                job.company,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppPallete.primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 16),

            /// Location + Employment Type Row
            Row(
              children: [
                Expanded(
                  child: _buildInfoChip(Icons.location_on_rounded, job.location),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildInfoChip(Icons.access_time_rounded, job.employmentType),
                ),
              ],
            ),
            const SizedBox(height: 12),

            /// Salary (if available)
            if (job.salary != null && job.salary!.isNotEmpty)
              _buildInfoChip(Icons.attach_money_rounded, job.salary!),

            const SizedBox(height: 16),

            /// Skills
            if (job.skills.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: job.skills.map((skill) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppPallete.accentColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppPallete.accentColor, width: 1),
                    ),
                    child: Text(
                      skill,
                      style: TextStyle(
                        color: AppPallete.accentColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),

            const SizedBox(height: 20),

            /// Apply Now Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppPallete.primaryColor,
                  foregroundColor: AppPallete.whiteColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                onPressed: () {
                  // TODO: Implement job application URL opening
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Apply Now",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.arrow_forward_rounded, size: 18),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// Custom Info Chip Builder
  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppPallete.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppPallete.borderColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppPallete.textSecondary, size: 16),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: AppPallete.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
