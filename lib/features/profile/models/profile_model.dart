import 'package:hive/hive.dart';

part 'profile_model.g.dart';

@HiveType(typeId: 0)
class ProfileModel {
  @HiveField(0)
  String fullName;

  @HiveField(1)
  String phone;

  @HiveField(2)
  String email;

  @HiveField(3)
  String dob;

  @HiveField(4)
  String bloodGroup;

  @HiveField(5)
  String address;

  @HiveField(6)
  String emergencyContact;

  @HiveField(7)
  String profileImage;

  ProfileModel({
    required this.fullName,
    required this.phone,
    required this.email,
    required this.dob,
    required this.bloodGroup,
    required this.address,
    required this.emergencyContact,
    required this.profileImage,
  });
}