import '../../domain/entity/job.dart';

class JobModel extends Job {
  JobModel({
    required super.title,
    required super.company,
    required super.location,
    required super.employmentType,
    required super.applyUrl,
    required super.postedAt,
    required super.description,
    required super.skills,
    super.companyLogo,
    super.isSaved,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      title: json['job_title'] ?? 'No title',
      company: json['employer_name'] ?? 'Unknown Company',
      location: '${json['job_city'] ?? ''}, ${json['job_country'] ?? ''}'
          .trim(),
      employmentType: json['job_employment_type'] ?? 'Not specified',
      applyUrl: json['job_apply_link'] ?? '',
      postedAt: json['job_posted_at_datetime_utc'] != null
          ? DateTime.tryParse(json['job_posted_at_datetime_utc'])
          : null,
      description: json['job_description'] ?? '',
      skills: [], // JSearch doesn't give explicit skills list
      companyLogo: json['employer_logo'],
      isSaved: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'job_title': title,
      'employer_name': company,
      'job_city': location.split(',').first.trim(),
      'job_country': location.contains(',')
          ? location.split(',').last.trim()
          : '',
      'job_employment_type': employmentType,
      'job_apply_link': applyUrl,
      'job_posted_at_datetime_utc': postedAt?.toIso8601String(),
      'job_description': description,
      'employer_logo': companyLogo,
    };
  }
}
