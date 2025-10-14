class JobModel {
  final String title;
  final String company;
  final String location;
  final String employmentType;
  final String applyUrl;
  final DateTime? postedAt;
  final List<String> skills;

  JobModel({
    required this.title,
    required this.company,
    required this.location,
    required this.employmentType,
    required this.applyUrl,
    this.postedAt,
    required this.skills,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      title: json['title'] ?? 'No title',
      company: json['company']?['display_name'] ?? 'Unknown Company',
      location: json['location']?['display_name'] ?? 'Unknown Location',
      employmentType: json['contract_type'] ?? 'Not specified',
      applyUrl: json['redirect_url'] ?? '',
      postedAt: json['created'] != null
          ? DateTime.tryParse(json['created'])
          : null,
      // Adzuna API doesn’t always provide skills, so we make it safe
      skills: (json['skills'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
    );
  }
}
