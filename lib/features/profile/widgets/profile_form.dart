import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/profile_model.dart';
import '../providers/profile_provider.dart';
import 'profile_avatar.dart';

class ProfileForm extends StatefulWidget {
  final ProfileModel? profile;

  const ProfileForm({
    super.key,
    this.profile,
  });

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _fullNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _dobController;
  late final TextEditingController _addressController;
  late final TextEditingController _emergencyController;

  String _bloodGroup = 'Not specified';
  String _profileImage = '';

  final List<String> _bloodGroups = [
    'Not specified',
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  @override
  void initState() {
    super.initState();

    final profile = widget.profile;

    _fullNameController = TextEditingController(
      text: profile?.fullName ?? '',
    );

    _phoneController = TextEditingController(
      text: profile?.phone ?? '',
    );

    _emailController = TextEditingController(
      text: profile?.email ?? '',
    );

    _dobController = TextEditingController(
      text: profile?.dob ?? '',
    );

    _addressController = TextEditingController(
      text: profile?.address ?? '',
    );

    _emergencyController = TextEditingController(
      text: profile?.emergencyContact ?? '',
    );

    _bloodGroup = profile?.bloodGroup.isNotEmpty == true
        ? profile!.bloodGroup
        : 'Not specified';

    _profileImage = profile?.profileImage ?? '';
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    _addressController.dispose();
    _emergencyController.dispose();
    super.dispose();
  }

  Future<void> _pickProfileImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result == null || result.files.single.path == null) {
      return;
    }

    setState(() {
      _profileImage = result.files.single.path!;
    });
  }

  Future<void> _selectDate() async {
    DateTime initialDate = DateTime.now();

    if (_dobController.text.isNotEmpty) {
      final parts = _dobController.text.split('/');

      if (parts.length == 3) {
        final day = int.tryParse(parts[0]);
        final month = int.tryParse(parts[1]);
        final year = int.tryParse(parts[2]);

        if (day != null && month != null && year != null) {
          initialDate = DateTime(year, month, day);
        }
      }
    }

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (selectedDate == null) {
      return;
    }

    final day = selectedDate.day.toString().padLeft(2, '0');
    final month = selectedDate.month.toString().padLeft(2, '0');
    final year = selectedDate.year.toString();

    setState(() {
      _dobController.text = '$day/$month/$year';
    });
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final profile = ProfileModel(
      fullName: _fullNameController.text.trim(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      dob: _dobController.text.trim(),
      bloodGroup: _bloodGroup,
      address: _addressController.text.trim(),
      emergencyContact: _emergencyController.text.trim(),
      profileImage: _profileImage,
    );

    await context.read<ProfileProvider>().saveProfile(profile);

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile saved successfully.'),
      ),
    );

    Navigator.pop(context);
  }

  InputDecoration _decoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
      prefixIcon: Icon(icon),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>();

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: ProfileAvatar(
              imagePath: _profileImage,
              radius: 60,
              onTap: _pickProfileImage,
              showEditIcon: true,
            ),
          ),

          const SizedBox(height: 10),

          Center(
            child: TextButton.icon(
              onPressed: _pickProfileImage,
              icon: const Icon(Icons.photo),
              label: const Text('Choose Profile Picture'),
            ),
          ),

          const SizedBox(height: 25),

          TextFormField(
            controller: _fullNameController,
            textInputAction: TextInputAction.next,
            decoration: _decoration(
              label: 'Full Name',
              icon: Icons.person,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your full name';
              }

              return null;
            },
          ),

          const SizedBox(height: 16),

          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            decoration: _decoration(
              label: 'Phone Number',
              icon: Icons.phone,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your phone number';
              }

              return null;
            },
          ),

          const SizedBox(height: 16),

          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: _decoration(
              label: 'Email',
              icon: Icons.email,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your email';
              }

              if (!value.contains('@')) {
                return 'Please enter a valid email';
              }

              return null;
            },
          ),

          const SizedBox(height: 16),

          TextFormField(
            controller: _dobController,
            readOnly: true,
            onTap: _selectDate,
            decoration: _decoration(
              label: 'Date of Birth',
              icon: Icons.cake,
            ),
          ),

          const SizedBox(height: 16),

          DropdownButtonFormField<String>(
            initialValue: _bloodGroup,
            decoration: _decoration(
              label: 'Blood Group',
              icon: Icons.bloodtype,
            ),
            items: _bloodGroups.map((group) {
              return DropdownMenuItem<String>(
                value: group,
                child: Text(group),
              );
            }).toList(),
            onChanged: (value) {
              if (value == null) {
                return;
              }

              setState(() {
                _bloodGroup = value;
              });
            },
          ),

          const SizedBox(height: 16),

          TextFormField(
            controller: _addressController,
            maxLines: 3,
            textInputAction: TextInputAction.newline,
            decoration: _decoration(
              label: 'Address',
              icon: Icons.home,
            ),
          ),

          const SizedBox(height: 16),

          TextFormField(
            controller: _emergencyController,
            keyboardType: TextInputType.phone,
            decoration: _decoration(
              label: 'Emergency Contact',
              icon: Icons.contact_phone,
            ),
          ),

          const SizedBox(height: 30),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton.icon(
              onPressed: provider.isLoading ? null : _saveProfile,
              icon: provider.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.save),
              label: Text(
                provider.isLoading
                    ? 'Saving...'
                    : 'Save Profile',
              ),
            ),
          ),
        ],
      ),
    );
  }
}