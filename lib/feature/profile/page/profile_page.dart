import 'package:blog_app/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:blog_app/core/common/entity/user.dart';
import 'package:blog_app/core/theme/app_pallet.dart';
import 'package:blog_app/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/feature/auth/presentation/bloc/auth_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppPallete.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<AppUserCubit, AppUserState>(
        listener: (context, state) {
          if (state is AppUserInitial) {
            // User logged out, navigate to login page
            Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
          }
        },
        builder: (context, state) {
          if (state is AppUserLoggedIn) {
            final User user = state.user;
            return _buildProfileContent(context, user);
          }

          // Fallback for loading or initial state
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, User user) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Profile Header Section
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppPallete.primaryColor,
                  AppPallete.primaryColor.withOpacity(0.8),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 20),
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 45,
                    backgroundImage: const AssetImage("assets/profile_placeholder.png"),
                    onBackgroundImageError: (_, __) => const Icon(
                      Icons.person,
                      size: 45,
                      color: AppPallete.primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  user.email,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Profile Options Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                _buildProfileOption(
                  icon: Icons.edit,
                  title: "Edit Profile",
                  subtitle: "Update your personal information",
                  onTap: () {
                    // TODO: Navigate to edit profile page
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Edit profile coming soon!")),
                    );
                  },
                ),
                const SizedBox(height: 8),
                _buildProfileOption(
                  icon: Icons.notifications,
                  title: "Notifications",
                  subtitle: "Manage your notification preferences",
                  onTap: () {
                    // TODO: Navigate to notifications settings
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Notifications settings coming soon!")),
                    );
                  },
                ),
                const SizedBox(height: 8),
                _buildProfileOption(
                  icon: Icons.privacy_tip,
                  title: "Privacy & Security",
                  subtitle: "Control your privacy settings",
                  onTap: () {
                    // TODO: Navigate to privacy settings
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Privacy settings coming soon!")),
                    );
                  },
                ),
                const SizedBox(height: 8),
                _buildProfileOption(
                  icon: Icons.help,
                  title: "Help & Support",
                  subtitle: "Get help and contact support",
                  onTap: () {
                    // TODO: Navigate to help page
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Help & support coming soon!")),
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Logout Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _showLogoutDialog(context);
                    },
                    icon: const Icon(Icons.logout, color: Colors.white),
                    label: const Text(
                      "Logout",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppPallete.primaryColor.withOpacity(0.1),
          child: Icon(
            icon,
            color: AppPallete.primaryColor,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
        onTap: onTap,
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
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                // Perform logout
                context.read<AuthBloc>().add(AuthLogout());
              },
              child: const Text(
                "Logout",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
