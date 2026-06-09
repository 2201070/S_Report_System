import 'package:cloud_firestore/cloud_firestore.dart';

class UserRegistrationModel {
  final String uid;
  final String nationalId;
  final String firstName;
  final String secondName;
  final String homeAddress;
  final String email;
  final String phone;
  final String gender;
  final String birthdate;
  final bool volunteer;
  final int cityId;
  final String role;
  final bool emailVerified;

  UserRegistrationModel({
    this.uid = "",
    required this.nationalId,
    required this.firstName,
    required this.secondName,
    required this.homeAddress,
    required this.email,
    required this.phone,
    required this.gender,
    required this.birthdate,
    required this.volunteer,
    required this.cityId,
    this.role = "Citizen",
    this.emailVerified = false,
  });

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "nationalId": nationalId,
    "firstName": firstName,
    "secondName": secondName,
    "homeAddress": homeAddress,
    "email": email,
    "phone": phone,
    "gender": gender,
    "birthdate": birthdate,
    "volunteer": volunteer,
    "CityId": cityId,
    "role": role,
    "emailVerified": emailVerified,
    "createdAt": FieldValue.serverTimestamp(),
  };
}
