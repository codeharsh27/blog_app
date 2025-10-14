class JobEssential {
  final String title;
  final String company;
  final String location;
  final String employmentType;
  final List<String> skills;
  final String applyUrl;
  final String? salary;       // <-- added
  final DateTime? postedAt;

  JobEssential({
    required this.title,
    required this.company,
    required this.location,
    required this.employmentType,
    required this.skills,
    required this.applyUrl,
    this.salary,
    this.postedAt,
  });
}
