import 'dart:io';
import 'package:blog_app/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:blog_app/feature/profile/domain/entities/user_profile.dart';
import 'package:blog_app/feature/profile/presentation/bloc/profile_bloc.dart';
import 'package:blog_app/feature/profile/presentation/bloc/profile_event.dart';
import 'package:blog_app/feature/profile/presentation/bloc/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class ProfileDetailsPage extends StatefulWidget {
  const ProfileDetailsPage({super.key});

  @override
  State<ProfileDetailsPage> createState() => _ProfileDetailsPageState();
}

class _ProfileDetailsPageState extends State<ProfileDetailsPage> {
  // Local state variables for form fields
  late String _name;
  late String _email;
  late String _phoneNumber;
  late String _bio;
  late String _currentRole;
  late String _experienceLevel;
  late String _jobType;
  late String _location;
  late String _learningGoals;
  late String _linkedinUrl;
  late String _githubUrl;
  late String _xUrl;

  File? _imageFile;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      if (mounted) {
        context.read<ProfileBloc>().add(
          ProfileImageUploadRequested(
            image: _imageFile!,
            userId: _userProfile.id,
          ),
        );
      }
    }
  }

  late UserProfile _userProfile;
  bool _isUploading = false;
  bool _isImageUpdate = false;
  String _selectedCountryCode = '+1';
  List<String> _preferredRoles = [];
  List<String> _preferredLocations = [];
  List<String> _primarySkills = [];
  List<String> _additionalSkills = [];
  List<String> _interests = [];

  final List<String> _countryCodes = [
    '+1 (USA)',
    '+91 (India)',
    '+44 (UK)',
    '+81 (Japan)',
    '+49 (Germany)',
    '+33 (France)',
    '+86 (China)',
    '+7 (Russia)',
    '+55 (Brazil)',
    '+61 (Australia)',
  ];

  final List<String> _techRoles = [
    'Software Engineer',
    'Frontend Developer',
    'Backend Developer',
    'Full Stack Developer',
    'Mobile Developer',
    'DevOps Engineer',
    'Data Scientist',
    'Product Manager',
    'UI/UX Designer',
    'QA Engineer',
    'System Architect',
    'Cloud Engineer',
    'Security Engineer',
    'Machine Learning Engineer',
  ];

  final List<String> _skillOptions = [
    'Flutter',
    'Dart',
    'Firebase',
    'React',
    'Node.js',
    'Python',
    'Java',
    'Kotlin',
    'Swift',
    'AWS',
    'Docker',
    'Kubernetes',
    'Git',
    'Figma',
    'Adobe XD',
    'SQL',
    'NoSQL',
    'GraphQL',
    'REST API',
    'CI/CD',
  ];

  final List<String> _interestOptions = [
    'Open Source',
    'AI',
    'Machine Learning',
    'Web3',
    'Blockchain',
    'IoT',
    'Robotics',
    'Game Development',
    'UI/UX Design',
    'Writing',
    'Public Speaking',
    'Mentoring',
    'Traveling',
    'Photography',
    'Music',
  ];

  final List<String> _locations = [
    'Remote',
    'New York, USA',
    'San Francisco, USA',
    'London, UK',
    'Berlin, Germany',
    'Bangalore, India',
    'Mumbai, India',
    'Toronto, Canada',
    'Sydney, Australia',
    'Singapore',
    'Paris, France',
    'Amsterdam, Netherlands',
    'Austin, USA',
    'Seattle, USA',
  ];

  @override
  void initState() {
    super.initState();

    final appUserState = context.read<AppUserCubit>().state;
    String initialName = '';
    String initialEmail = '';
    String initialId = '1';

    if (appUserState is AppUserLoggedIn) {
      initialName = appUserState.user.name;
      initialEmail = appUserState.user.email;
      initialId = appUserState.user.id;
    }

    _userProfile = UserProfile(
      id: initialId,
      name: initialName,
      email: initialEmail,
      phone: '',
      currentRole: 'Senior Developer',
      experienceLevel: 'Senior',
      location: 'Sweden',
      jobType: 'Remote',
      bio: '',
      profilePhotoUrl:
          'https://i.pinimg.com/564x/00/39/a2/0039a2e95c08e729a18c8e0a350f1ac7.jpg',
      primarySkills: ['Flutter', 'Dart', 'Firebase'],
      additionalSkills: ['Git', 'Figma'],
      learningGoals: 'Mastering Advanced Animations',
      interests: ['Open Source', 'AI'],
      preferredRoles: ['Lead Developer', 'Tech Lead'],
      preferredLocations: ['Remote', 'USA'],
      linkedinUrl: 'linkedin.com/in/jenny',
      githubUrl: 'github.com/jenny',
      xUrl: 'x.com/jenny',
      resumeUrl: 'jenny_wilson_resume.pdf',
    );

    // Initialize local state
    _name = _userProfile.name;
    _email = _userProfile.email;
    _phoneNumber = _userProfile.phone ?? '';
    _bio = _userProfile.bio ?? '';
    _currentRole = _userProfile.currentRole ?? '';
    _experienceLevel = _userProfile.experienceLevel ?? 'Senior';
    _jobType = _userProfile.jobType ?? 'Remote';
    _location = _userProfile.location ?? '';
    _learningGoals = _userProfile.learningGoals ?? '';
    _linkedinUrl = _userProfile.linkedinUrl ?? '';
    _githubUrl = _userProfile.githubUrl ?? '';
    _xUrl = _userProfile.xUrl ?? '';

    _preferredRoles = List.from(_userProfile.preferredRoles);
    _preferredLocations = List.from(_userProfile.preferredLocations);
    _primarySkills = List.from(_userProfile.primarySkills);
    _additionalSkills = List.from(_userProfile.additionalSkills);
    _interests = List.from(_userProfile.interests);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLoaded) {
          if (_isImageUpdate) {
            setState(() {
              _isImageUpdate = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile image saved!'),
                backgroundColor: Colors.green,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile saved successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          }
        } else if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        } else if (state is ProfileImageUploaded) {
          setState(() {
            _isImageUpdate = true;
            _userProfile = UserProfile(
              id: _userProfile.id,
              name: _userProfile.name,
              email: _userProfile.email,
              phone: _userProfile.phone,
              bio: _userProfile.bio,
              currentRole: _userProfile.currentRole,
              experienceLevel: _userProfile.experienceLevel,
              jobType: _userProfile.jobType,
              location: _userProfile.location,
              learningGoals: _userProfile.learningGoals,
              linkedinUrl: _userProfile.linkedinUrl,
              githubUrl: _userProfile.githubUrl,
              xUrl: _userProfile.xUrl,
              primarySkills: _userProfile.primarySkills,
              additionalSkills: _userProfile.additionalSkills,
              interests: _userProfile.interests,
              preferredRoles: _userProfile.preferredRoles,
              preferredLocations: _userProfile.preferredLocations,
              profilePhotoUrl: state.imageUrl,
              resumeUrl: _userProfile.resumeUrl,
            );
          });

          // Auto-save to DB
          final updatedProfile = UserProfile(
            id: _userProfile.id,
            name: _name,
            email: _email,
            phone: _phoneNumber,
            bio: _bio,
            currentRole: _currentRole,
            experienceLevel: _experienceLevel,
            jobType: _jobType,
            location: _location,
            learningGoals: _learningGoals,
            linkedinUrl: _linkedinUrl,
            githubUrl: _githubUrl,
            xUrl: _xUrl,
            primarySkills: _primarySkills,
            additionalSkills: _additionalSkills,
            interests: _interests,
            preferredRoles: _preferredRoles,
            preferredLocations: _preferredLocations,
            profilePhotoUrl: state.imageUrl,
            resumeUrl: _userProfile.resumeUrl,
          );

          context.read<ProfileBloc>().add(
            ProfileUpdateRequested(updatedProfile),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F9FF),
        appBar: AppBar(
          title: const Text(
            'Edit Profile',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color(0xFF1A237E),
            ),
          ),
          centerTitle: true,
          backgroundColor: const Color(0xFFF5F9FF),
          elevation: 0,
          leading: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(13),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                size: 18,
                color: Color(0xFF1A237E),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 32),

              // Resume Autofill Section - The "Stress Reliever"
              _buildResumeAutofillSection(),

              const SizedBox(height: 32),

              const Text(
                'Profile Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A237E),
                ),
              ),
              const SizedBox(height: 16),

              _buildExpandableSection(
                title: 'Personal Information',
                icon: Icons.person_outline_rounded,
                isExpanded: true,
                children: [
                  _buildTextField(
                    'Username',
                    _name,
                    hintText: 'User Name',
                    onChanged: (val) => _name = val,
                  ),
                  _buildTextField(
                    'Email',
                    _email,
                    hintText: 'User Email',
                    onChanged: (val) => _email = val,
                  ),
                  _buildPhoneNumberInput(
                    onChanged: (val) => _phoneNumber = val,
                  ),
                  _buildTextField(
                    'Bio',
                    _bio,
                    maxLines: 3,
                    hintText: 'Passionate about building cool stuff',
                    onChanged: (val) => _bio = val,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildExpandableSection(
                title: 'Professional Details',
                icon: Icons.work_outline_rounded,
                children: [
                  _buildAutocompleteField(
                    'Current Role',
                    _currentRole,
                    _techRoles,
                    onChanged: (val) => _currentRole = val,
                  ),
                  _buildDropdown(
                    'Experience Level',
                    ['Junior', 'Mid-Level', 'Senior', 'Lead'],
                    _experienceLevel,
                    (val) => setState(() => _experienceLevel = val!),
                  ),
                  _buildDropdown(
                    'Job Type',
                    ['Full-time', 'Remote', 'Part-time', 'Contract'],
                    _jobType,
                    (val) => setState(() => _jobType = val!),
                  ),
                  _buildAutocompleteField(
                    'Current Location',
                    _location,
                    _locations,
                    onChanged: (val) => _location = val,
                  ),
                  _buildAutocompleteChipInput(
                    'Preferred Roles',
                    _preferredRoles,
                    _techRoles,
                    (value) {
                      if (!_preferredRoles.contains(value)) {
                        setState(() {
                          _preferredRoles.add(value);
                        });
                      }
                    },
                    (value) {
                      setState(() {
                        _preferredRoles.remove(value);
                      });
                    },
                  ),
                  _buildAutocompleteChipInput(
                    'Preferred Locations',
                    _preferredLocations,
                    _locations,
                    (value) {
                      if (!_preferredLocations.contains(value)) {
                        setState(() {
                          _preferredLocations.add(value);
                        });
                      }
                    },
                    (value) {
                      setState(() {
                        _preferredLocations.remove(value);
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildExpandableSection(
                title: 'Skills & Growth',
                icon: Icons.lightbulb_outline_rounded,
                children: [
                  _buildAutocompleteChipInput(
                    'Primary Skills',
                    _primarySkills,
                    _skillOptions,
                    (value) {
                      if (!_primarySkills.contains(value)) {
                        setState(() {
                          _primarySkills.add(value);
                        });
                      }
                    },
                    (value) {
                      setState(() {
                        _primarySkills.remove(value);
                      });
                    },
                  ),
                  _buildAutocompleteChipInput(
                    'Additional Skills',
                    _additionalSkills,
                    _skillOptions,
                    (value) {
                      if (!_additionalSkills.contains(value)) {
                        setState(() {
                          _additionalSkills.add(value);
                        });
                      }
                    },
                    (value) {
                      setState(() {
                        _additionalSkills.remove(value);
                      });
                    },
                  ),
                  _buildTextField(
                    'Learning Goals',
                    _learningGoals,
                    onChanged: (val) => _learningGoals = val,
                  ),
                  _buildAutocompleteChipInput(
                    'Interests',
                    _interests,
                    _interestOptions,
                    (value) {
                      if (!_interests.contains(value)) {
                        setState(() {
                          _interests.add(value);
                        });
                      }
                    },
                    (value) {
                      setState(() {
                        _interests.remove(value);
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildExpandableSection(
                title: 'Social Links',
                icon: Icons.share_outlined,
                children: [
                  _buildSocialInput(
                    FontAwesomeIcons.linkedin,
                    'LinkedIn URL',
                    _linkedinUrl,
                    onChanged: (val) => _linkedinUrl = val,
                  ),
                  _buildSocialInput(
                    FontAwesomeIcons.github,
                    'GitHub URL',
                    _githubUrl,
                    onChanged: (val) => _githubUrl = val,
                  ),
                  _buildSocialInput(
                    FontAwesomeIcons.xTwitter,
                    'X (Twitter) URL',
                    _xUrl,
                    onChanged: (val) => _xUrl = val,
                  ),
                ],
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // Validation Logic
                    List<String> missingFields = [];
                    if (_name.isEmpty) missingFields.add('Username');
                    if (_email.isEmpty) missingFields.add('Email');
                    if (_phoneNumber.isEmpty) missingFields.add('Phone Number');
                    if (_currentRole.isEmpty) missingFields.add('Current Role');
                    if (_preferredRoles.isEmpty)
                      missingFields.add('Preferred Roles');
                    if (_preferredLocations.isEmpty)
                      missingFields.add('Preferred Locations');
                    if (_primarySkills.isEmpty)
                      missingFields.add('Primary Skills');
                    if (_linkedinUrl.isEmpty) missingFields.add('LinkedIn URL');
                    if (_githubUrl.isEmpty) missingFields.add('GitHub URL');

                    if (missingFields.isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Profile is incomplete. Missing: ${missingFields.join(', ')}',
                          ),
                          backgroundColor: Colors.red,
                          duration: const Duration(seconds: 4),
                        ),
                      );
                    } else {
                      final updatedProfile = UserProfile(
                        id: _userProfile.id,
                        name: _name,
                        email: _email,
                        phone: _phoneNumber,
                        bio: _bio,
                        currentRole: _currentRole,
                        experienceLevel: _experienceLevel,
                        jobType: _jobType,
                        location: _location,
                        learningGoals: _learningGoals,
                        linkedinUrl: _linkedinUrl,
                        githubUrl: _githubUrl,
                        xUrl: _xUrl,
                        primarySkills: _primarySkills,
                        additionalSkills: _additionalSkills,
                        interests: _interests,
                        preferredRoles: _preferredRoles,
                        preferredLocations: _preferredLocations,
                        profilePhotoUrl: _userProfile.profilePhotoUrl,
                        resumeUrl: _userProfile.resumeUrl,
                      );
                      context.read<ProfileBloc>().add(
                        ProfileUpdateRequested(updatedProfile),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A237E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 8,
                    shadowColor: const Color(0xFF1A237E).withAlpha(102),
                  ),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Center(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(26),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: _imageFile != null
                      ? FileImage(_imageFile!)
                      : (_userProfile.profilePhotoUrl != null &&
                            _userProfile.profilePhotoUrl!.isNotEmpty)
                      ? NetworkImage(_userProfile.profilePhotoUrl!)
                            as ImageProvider
                      : null,
                  child:
                      (_imageFile == null &&
                          (_userProfile.profilePhotoUrl == null ||
                              _userProfile.profilePhotoUrl!.isEmpty))
                      ? const Icon(Icons.person, size: 60, color: Colors.grey)
                      : null,
                ),
              ),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2196F3),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Keep your profile updated',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResumeAutofillSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFE3F2FD).withOpacity(0.9),
            Colors.white.withOpacity(0.95),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A237E).withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: Color(0xFF2196F3),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Autofill with Resume',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A237E),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Upload your CV to instantly fill your profile details.',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              setState(() {
                _isUploading = true;
              });
              // Simulate upload
              Future.delayed(const Duration(seconds: 2), () {
                if (mounted) {
                  setState(() {
                    _isUploading = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profile autofilled from resume!'),
                      backgroundColor: Color(0xFF4CAF50),
                    ),
                  );
                }
              });
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF2196F3).withOpacity(0.5),
                  width: 1,
                ),
              ),
              child: _isUploading
                  ? const Center(
                      child: SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF2196F3),
                          ),
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.cloud_upload_rounded,
                          color: Color(0xFF2196F3),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Tap to Upload Resume (PDF)',
                          style: TextStyle(
                            color: Color(0xFF2196F3),
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
    bool isExpanded = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFE3F2FD).withOpacity(0.9),
            Colors.white.withOpacity(0.95),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A237E).withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: isExpanded,
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF1A237E), size: 20),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Color(0xFF1A237E),
            ),
          ),
          trailing: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.grey,
          ),
          childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          children: children,
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    String initialValue, {
    int maxLines = 1,
    String? hintText,
    Function(String)? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF1A237E),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          TextFormField(
            initialValue: initialValue,
            maxLines: maxLines,
            onChanged: onChanged,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey[400]),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
              border: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.withAlpha(77)),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF2196F3), width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAutocompleteField(
    String label,
    String initialValue,
    List<String> options, {
    Function(String)? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF1A237E),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          Autocomplete<String>(
            initialValue: TextEditingValue(text: initialValue),
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text == '') {
                return const Iterable<String>.empty();
              }
              return options.where((String option) {
                return option.toLowerCase().contains(
                  textEditingValue.text.toLowerCase(),
                );
              });
            },
            onSelected: (String selection) {
              if (onChanged != null) onChanged(selection);
            },
            fieldViewBuilder:
                (context, controller, focusNode, onEditingComplete) {
                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    onEditingComplete: onEditingComplete,
                    onChanged: onChanged,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      border: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey.withAlpha(77),
                        ),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF2196F3),
                          width: 2,
                        ),
                      ),
                    ),
                  );
                },
          ),
        ],
      ),
    );
  }

  Widget _buildAutocompleteChipInput(
    String label,
    List<String> chips,
    List<String> options,
    Function(String) onAdd,
    Function(String) onDelete,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF1A237E),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Autocomplete<String>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text == '') {
                return const Iterable<String>.empty();
              }
              return options.where((String option) {
                return option.toLowerCase().contains(
                  textEditingValue.text.toLowerCase(),
                );
              });
            },
            onSelected: (String selection) {
              onAdd(selection);
            },
            fieldViewBuilder:
                (context, controller, focusNode, onEditingComplete) {
                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    onEditingComplete: onEditingComplete,
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        onAdd(value);
                        controller.clear();
                      }
                    },
                    style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Type to add...',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      border: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey.withAlpha(77),
                        ),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF2196F3),
                          width: 2,
                        ),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.add_circle_outline,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          if (controller.text.isNotEmpty) {
                            onAdd(controller.text);
                            controller.clear();
                          }
                        },
                      ),
                    ),
                  );
                },
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: chips
                .map(
                  (chip) => Chip(
                    label: Text(chip),
                    backgroundColor: Colors.black,
                    labelStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    deleteIcon: const Icon(
                      Icons.close,
                      size: 16,
                      color: Colors.white,
                    ),
                    side: BorderSide.none,
                    onDeleted: () => onDelete(chip),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneNumberInput({Function(String)? onChanged}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Phone Number',
            style: TextStyle(
              color: Color(0xFF1A237E),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Country Code Autocomplete
              SizedBox(
                width: 100,
                child: Autocomplete<String>(
                  initialValue: TextEditingValue(text: _selectedCountryCode),
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text == '') {
                      return const Iterable<String>.empty();
                    }
                    return _countryCodes.where((String option) {
                      return option.toLowerCase().contains(
                        textEditingValue.text.toLowerCase(),
                      );
                    });
                  },
                  onSelected: (String selection) {
                    setState(() {
                      _selectedCountryCode = selection.split(' ')[0];
                    });
                  },
                  fieldViewBuilder:
                      (context, controller, focusNode, onEditingComplete) {
                        return TextField(
                          controller: controller,
                          focusNode: focusNode,
                          onEditingComplete: onEditingComplete,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            hintText: '+1',
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 8,
                            ),
                            border: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.withAlpha(77),
                              ),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF2196F3),
                                width: 2,
                              ),
                            ),
                          ),
                        );
                      },
                ),
              ),
              const SizedBox(width: 16),
              // Phone Number
              Expanded(
                child: TextFormField(
                  initialValue: _userProfile.phone,
                  keyboardType: TextInputType.phone,
                  onChanged: onChanged,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    hintText: '000-000-0000',
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    border: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.withAlpha(77)),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF2196F3),
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    List<String> items,
    String value,
    Function(String?)? onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF1A237E),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          DropdownButtonFormField<String>(
            value: value,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
              border: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.withAlpha(77)),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF2196F3), width: 2),
              ),
            ),
            items: items.map((item) {
              return DropdownMenuItem(value: item, child: Text(item));
            }).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildSocialInput(
    IconData icon,
    String hint,
    String? initialValue, {
    Function(String)? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        initialValue: initialValue,
        onChanged: onChanged,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, size: 20, color: Colors.grey[600]),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400]),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          border: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          enabledBorder: BorderSide(
            color: Colors.grey.withAlpha(77),
          ).toUnderlineInputBorder(),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF2196F3), width: 2),
          ),
        ),
      ),
    );
  }
}

extension BorderSideExtension on BorderSide {
  UnderlineInputBorder toUnderlineInputBorder() {
    return UnderlineInputBorder(borderSide: this);
  }
}
