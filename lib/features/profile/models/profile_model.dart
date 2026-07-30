class ProfileModel {
  final String fullName;
  final String phone;
  final String email;
  final String dob;
  final String bloodGroup;
  final String address;
  final String emergencyContact;
  final String profileImage;

  const ProfileModel({
    required this.fullName,
    required this.phone,
    required this.email,
    required this.dob,
    required this.bloodGroup,
    required this.address,
    required this.emergencyContact,
    required this.profileImage,
  });

  factory ProfileModel.empty() {
    return const ProfileModel(
      fullName: '',
      phone: '',
      email: '',
      dob: '',
      bloodGroup: '',
      address: '',
      emergencyContact: '',
      profileImage: '',
    );
  }
}