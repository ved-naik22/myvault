import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'edit_profile_page.dart';
import 'providers/profile_provider.dart';
import 'widgets/profile_info_card.dart';
import 'widgets/profile_tile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>();
    final profile = provider.profile;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          if (profile != null)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditProfilePage(
                      profile: profile,
                    ),
                  ),
                );
              },
            ),
        ],
      ),
      body: provider.isLoading && profile == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : profile == null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.account_circle_outlined,
                          size: 100,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'No Profile Created',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Create your profile to store your personal information.',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 25),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: FilledButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const EditProfilePage(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.person_add),
                            label: const Text('Create Profile'),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: provider.loadProfile,
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      ProfileInfoCard(profile: profile),

                      const SizedBox(height: 25),

                      ProfileTile(
                        icon: Icons.person,
                        title: 'Full Name',
                        value: profile.fullName,
                      ),

                      ProfileTile(
                        icon: Icons.phone,
                        title: 'Phone',
                        value: profile.phone,
                      ),

                      ProfileTile(
                        icon: Icons.email,
                        title: 'Email',
                        value: profile.email,
                      ),

                      ProfileTile(
                        icon: Icons.cake,
                        title: 'Date of Birth',
                        value: profile.dob,
                      ),

                      ProfileTile(
                        icon: Icons.bloodtype,
                        title: 'Blood Group',
                        value: profile.bloodGroup,
                      ),

                      ProfileTile(
                        icon: Icons.home,
                        title: 'Address',
                        value: profile.address,
                      ),

                      ProfileTile(
                        icon: Icons.contact_phone,
                        title: 'Emergency Contact',
                        value: profile.emergencyContact,
                      ),

                      const SizedBox(height: 20),

                      SizedBox(
                        height: 52,
                        child: FilledButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditProfilePage(
                                  profile: profile,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.edit),
                          label: const Text('Edit Profile'),
                        ),
                      ),

                      const SizedBox(height: 12),

                      SizedBox(
                        height: 52,
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            final confirm =
                                await showDialog<bool>(
                              context: context,
                              builder: (dialogContext) {
                                return AlertDialog(
                                  title: const Text(
                                    'Delete Profile',
                                  ),
                                  content: const Text(
                                    'Are you sure you want to delete your profile?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(
                                          dialogContext,
                                          false,
                                        );
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    FilledButton(
                                      onPressed: () {
                                        Navigator.pop(
                                          dialogContext,
                                          true,
                                        );
                                      },
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                );
                              },
                            );

                            if (confirm == true) {
                              await provider.deleteProfile();

                              if (!context.mounted) return;

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Profile deleted successfully.',
                                  ),
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.delete),
                          label: const Text('Delete Profile'),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}