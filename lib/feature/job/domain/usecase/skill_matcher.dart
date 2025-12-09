import '../../../../core/common/entity/user.dart';
import '../entity/job.dart';

class SkillMatcher {
  double match(User user, Job job) {
    if (user.skills.isEmpty) return 0.0;

    final jobText = '${job.title} ${job.description} ${job.skills.join(" ")}'
        .toLowerCase();
    int matches = 0;

    for (final skill in user.skills) {
      if (jobText.contains(skill.toLowerCase())) {
        matches++;
      }
    }

    return (matches / user.skills.length) * 100;
  }

  List<String> getMissingSkills(User user, Job job) {
    List<String> missing = [];

    // This is a basic implementation. Ideally, we'd extract skills from the job description
    // and compare them against user skills.
    // For now, we check if user skills are present in the job.
    // But the requirement is "what skills need to learn".
    // This implies extracting keywords from Job that are NOT in User skills.
    // Since we don't have a keyword extractor, we can only check the explicit 'skills' list from the Job
    // if available, or just return nothing for now until we have a better NLP solution.
    // However, Adzuna provides a 'category' which we mapped to skills.

    for (final skill in job.skills) {
      if (!user.skills.any((s) => s.toLowerCase() == skill.toLowerCase())) {
        missing.add(skill);
      }
    }
    return missing;
  }
}
