import 'package:blog_app/core/theme/app_pallet.dart';
import 'package:blog_app/feature/auth/presentation/page/login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  String? _experienceLevel;
  final List<String> _selectedSkills = [];
  final List<String> _availableSkills = [
    'Flutter',
    'Dart',
    'Python',
    'Java',
    'React',
    'Node.js',
    'UI/UX',
    'Product Management',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  Future<void> _onContinue() async {
    if (_formKey.currentState!.validate()) {
      // Save data locally (mock implementation for now)
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboarding_complete', true);
      // You would typically save the user info here too

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tell us about yourself'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Help us personalize your experience.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 32),

              // Name Field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.person_outline),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Experience Level
              DropdownButtonFormField<String>(
                value: _experienceLevel,
                decoration: InputDecoration(
                  labelText: 'Experience Level',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.work_outline),
                ),
                items: ['Beginner', 'Intermediate', 'Advanced']
                    .map(
                      (level) =>
                          DropdownMenuItem(value: level, child: Text(level)),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _experienceLevel = value;
                  });
                },
                validator: (value) => value == null
                    ? 'Please select your experience level'
                    : null,
              ),
              const SizedBox(height: 24),

              // Preferred Job Role
              TextFormField(
                controller: _roleController,
                decoration: InputDecoration(
                  labelText: 'Preferred Job Role',
                  hintText: 'e.g. Mobile Developer',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.badge_outlined),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your preferred role';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Skills
              const Text(
                'Skills',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _availableSkills.map((skill) {
                  final isSelected = _selectedSkills.contains(skill);
                  return FilterChip(
                    label: Text(skill),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedSkills.add(skill);
                        } else {
                          _selectedSkills.remove(skill);
                        }
                      });
                    },
                    selectedColor: AppPallete.primaryColor.withAlpha(51),
                    checkmarkColor: AppPallete.primaryColor,
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),

              // Resume Upload (Placeholder)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade50,
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.cloud_upload_outlined,
                      size: 48,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 8),
                    const Text('Upload Resume (Optional)'),
                    TextButton(
                      onPressed: () {
                        // Placeholder action
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Resume upload coming soon!'),
                          ),
                        );
                      },
                      child: const Text('Choose File'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Continue Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppPallete.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
