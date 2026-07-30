import 'package:flutter/material.dart';

import 'widgets/profile_header.dart';
import 'widgets/profile_tile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children:  [
            ProfileHeader(),

            SizedBox(height: 30),

            ProfileTile(
              icon: Icons.person,
              title: "Full Name",
              value: "Ved Naik",
            ),

            ProfileTile(
              icon: Icons.phone,
              title: "Phone",
              value: "+91 XXXXX XXXXX",
            ),

            ProfileTile(
              icon: Icons.email,
              title: "Email",
              value: "example@gmail.com",
            ),

            ProfileTile(
              icon: Icons.cake,
              title: "Date of Birth",
              value: "DD/MM/YYYY",
            ),

            ProfileTile(
              icon: Icons.bloodtype,
              title: "Blood Group",
              value: "B+",
            ),

            ProfileTile(
              icon: Icons.home,
              title: "Address",
              value: "Pernem, Goa",
            ),

            ProfileTile(
              icon: Icons.contact_phone,
              title: "Emergency Contact",
              value: "+91 XXXXX XXXXX",
            ),

            SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: null,
                icon: Icon(Icons.edit),
                label: Text("Edit Profile"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}