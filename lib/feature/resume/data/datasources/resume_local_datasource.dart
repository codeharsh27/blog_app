import 'package:blog_app/feature/resume/data/models/resume_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResumeLocalDataSource {
  final SharedPreferences _sharedPreferences;
  static const String _resumeKey = 'resume_data';

  ResumeLocalDataSource(this._sharedPreferences);

  Future<void> saveResume(ResumeData resumeData) async {
    await _sharedPreferences.setString(_resumeKey, resumeData.toJson());
  }

  Future<ResumeData?> loadResume() async {
    final jsonString = _sharedPreferences.getString(_resumeKey);
    if (jsonString != null) {
      return ResumeData.fromJson(jsonString);
    }
    return null;
  }
}
