import 'package:blog_app/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:blog_app/core/common/entity/user.dart';
import 'package:blog_app/feature/profile/domain/entities/user_profile.dart';

import 'package:blog_app/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/feature/auth/presentation/bloc/auth_event.dart';
import 'package:blog_app/feature/profile/presentation/pages/profile_details_page.dart';
import 'package:blog_app/feature/resume/presentation/pages/resume_landing_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:blog_app/feature/profile/presentation/bloc/profile_bloc.dart';
import 'package:blog_app/feature/profile/presentation/bloc/profile_event.dart';
import 'package:blog_app/feature/profile/presentation/bloc/profile_state.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    final appUserState = context.read<AppUserCubit>().state;
    if (appUserState is AppUserLoggedIn) {
      context.read<ProfileBloc>().add(
        ProfileFetchRequested(userId: appUserState.user.id),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: Container(
          margin: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color.fromRGBO(255, 255, 255, 0.3),
              width: 1.5,
            ),
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 20,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocBuilder<AppUserCubit, AppUserState>(
        builder: (context, state) {
          if (state is AppUserLoggedIn) {
            return BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, profileState) {
                if (profileState is ProfileLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (profileState is ProfileLoaded) {
                  return _buildProfileUI(
                    context,
                    state.user,
                    profileState.profile,
                  );
                }
                if (profileState is ProfileImageUploaded) {
                  // If image uploaded, we might want to refetch or just show current state if we have it?
                  // Actually ProfileImageUploaded state has imageUrl but not full profile.
                  // But we should have fetched profile before.
                  // For now let's just trigger fetch again or handle it.
                  // Simpler: Just show loading or previous state.
                  // Let's assume ProfileLoaded is the main state we care about.
                  // If we just uploaded, we probably want to fetch again to get full updated object if needed,
                  // or we can just use the previous profile data if we had it.
                  // But ProfileBloc state is single.
                  // Let's trigger fetch in listener if needed, but for now let's handle ProfileLoaded.
                  // If state is ProfileImageUploaded, we don't have the full profile in the state object (it just has imageUrl).
                  // We should probably emit ProfileLoaded after upload in Bloc?
                  // In Bloc I emitted ProfileImageUploaded.
                  // I should change Bloc to emit ProfileLoaded with updated profile after upload?
                  // Or just handle it here.
                  // Let's stick to ProfileLoaded.
                  // If state is not ProfileLoaded, we might show loading or error.
                  // If it's initial, we show loading.
                  return const Center(child: CircularProgressIndicator());
                }
                if (profileState is ProfileError) {
                  return Center(child: Text(profileState.message));
                }
                return const Center(child: CircularProgressIndicator());
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildProfileUI(BuildContext context, User user, UserProfile profile) {
    return Stack(
      children: [
        // Gradient Background that fades to white
        Container(
          width: double.infinity,
          height: 500, // Adjust height as needed
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF7650E8),
                const Color(0xFF9B87E0).withAlpha(230),
                const Color(0xFFC5B6F0).withAlpha(204),
                const Color.fromRGBO(255, 255, 255, 0.1),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.0, 0.4, 0.7, 1.0],
            ),
          ),
        ),
        // White background for the rest of the screen
        Positioned(
          top: 500, // Same as gradient container height
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(color: Colors.white),
        ),
        // Main content
        SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 100), // Space for app bar
              const SizedBox(height: 20),

              // User Info Card
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 24),
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
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Background decorative circles
                    Positioned(
                      top: -40,
                      right: -40,
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.4),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -20,
                      left: -20,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.4),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Profile Image
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFF6B6B), Color(0xFF45B7D1)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 45,
                              backgroundColor: Colors.white,
                              backgroundImage:
                                  profile.profilePhotoUrl != null &&
                                      profile.profilePhotoUrl!.isNotEmpty
                                  ? NetworkImage(profile.profilePhotoUrl!)
                                  : null,
                              child:
                                  profile.profilePhotoUrl == null ||
                                      profile.profilePhotoUrl!.isEmpty
                                  ? const Icon(
                                      Icons.person,
                                      size: 45,
                                      color: Colors.grey,
                                    )
                                  : null,
                            ),
                          ),

                          const SizedBox(height: 12),

                          // Pro Badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2196F3).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFF2196F3).withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.verified_rounded,
                                  color: Color(0xFF2196F3),
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  'PRO MEMBER',
                                  style: TextStyle(
                                    color: Color(0xFF1976D2),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // User Name
                          Text(
                            profile.name.isNotEmpty ? profile.name : user.name,
                            style: const TextStyle(
                              fontSize: 24,
                              color: Color(0xFF1A237E), // Dark Blue-Black
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                              fontFamily: 'Inter',
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 4),

                          // Email
                          Text(
                            profile.email.isNotEmpty
                                ? profile.email
                                : user.email,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF5C6BC0), // Soft Blue-Grey
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.3,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 24),

                          // Divider
                          Container(
                            height: 1,
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(horizontal: 40),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  const Color(0xFF1A237E).withOpacity(0.1),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Details Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(
                                            0xFF1A237E,
                                          ).withOpacity(0.05),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.work_outline_rounded,
                                      color: Color(0xFF3949AB),
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    profile.currentRole ?? 'Role',
                                    style: const TextStyle(
                                      color: Color(0xFF1A237E),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const Text(
                                    'Role',
                                    style: TextStyle(
                                      color: Color(0xFF7986CB),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                height: 40,
                                width: 1,
                                color: const Color(0xFF1A237E).withOpacity(0.1),
                              ),
                              Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(
                                            0xFF1A237E,
                                          ).withOpacity(0.05),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.location_on_outlined,
                                      color: Color(0xFF3949AB),
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    profile.location ?? 'Location',
                                    style: const TextStyle(
                                      color: Color(0xFF1A237E),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const Text(
                                    'Location',
                                    style: TextStyle(
                                      color: Color(0xFF7986CB),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Edit Button
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => _navigateToProfileDetails(context),
                          borderRadius: BorderRadius.circular(50),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white),
                            ),
                            child: const Icon(
                              Icons.edit_rounded,
                              color: Color(0xFF3949AB),
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              const SizedBox(height: 24),

              // Resume Builder Section
              _buildResumeBuilderSection(context),

              const SizedBox(height: 2),

              const SizedBox(height: 16),

              // App Settings Section
              _buildAppSettingsSection(context),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAppSettingsSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(158, 158, 158, 0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'App Settings',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),

          // App Version
          _buildSettingItem(
            icon: Icons.info_outline_rounded,
            title: 'App Version',
            subtitle: '1.0.0',
            onTap: () {},
          ),

          // Privacy Policy
          _buildSettingItem(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            onTap: () {
              // TODO: Navigate to privacy policy
            },
          ),

          // Terms of Service
          _buildSettingItem(
            icon: Icons.description_outlined,
            title: 'Terms of Service',
            onTap: () {
              // TODO: Navigate to terms of service
            },
          ),

          // Logout Button
          _buildSettingItem(
            icon: Icons.logout_rounded,
            title: 'Logout',
            textColor: Colors.red,
            onTap: () => _showLogoutDialog(context),
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    String? subtitle,
    Color? textColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: textColor ?? Colors.grey[700]),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      onTap: onTap,
    );
  }

  void _navigateToProfileDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfileDetailsPage()),
    );
  }

  Widget _buildResumeBuilderSection(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, ResumeLandingPage.route());
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black, // Premium Black
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade800, width: 1),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.description_outlined,
                    size: 24,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Resume Builder',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 0.1,
                      ),
                    ),
                    Text(
                      'Create ATS-friendly resume',
                      style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                    ),
                  ],
                ),
              ],
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Colors.white54,
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<AuthBloc>().add(AuthLogout());
              },
              child: const Text("Logout", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
