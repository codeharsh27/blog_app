class Job {
  final String title;
  final String company;
  final String location;
  final String employmentType;
  final String applyUrl;
  final DateTime? postedAt;
  final String description;
  final List<String> skills;
  final double? matchScore;
  final String? companyLogo;
  final bool isSaved;

  Job({
    required this.title,
    required this.company,
    required this.location,
    required this.employmentType,
    required this.applyUrl,
    required this.postedAt,
    required this.description,
    required this.skills,
    this.matchScore,
    this.companyLogo,
    this.isSaved = false,
  });
}
