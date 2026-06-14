import 'package:equatable/equatable.dart';

class UserProfileModel extends Equatable {
  final String nationalId;
  final String firstName;
  final String secondName;
  final int points;
  final String gender;
  final String birthdate;
  final String homeAddress;
  final String phone;
  final String email;
  final bool volunteer;
  final int cityId;
  final int rate; 

  const UserProfileModel({
    required this.nationalId,
    required this.firstName,
    required this.secondName,
    required this.points,
    required this.gender,
    required this.birthdate,
    required this.homeAddress,
    required this.phone,
    required this.email,
    required this.volunteer,
    required this.cityId,
    required this.rate,
  });

  String get fullName => '$firstName $secondName'.trim();

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      nationalId: json['nationalId']?.toString() ?? '',
      firstName: json['firstName']?.toString() ?? '',
      secondName: json['secundName']?.toString() ?? '', 
      points: (json['rate'] as num?)?.toInt() ?? 0,     
      gender: json['gender']?.toString() ?? '',
      birthdate: json['birthdate']?.toString() ?? '',
      homeAddress: json['address']?.toString() ?? '',  
      phone: json['phone']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      volunteer: json['volunteer'] as bool? ?? false,
      cityId: (json['cityId'] as num?)?.toInt() ?? 0,
      rate: (json['rate'] as num?)?.toInt() ?? 0, 
    );
  }

  @override
  List<Object?> get props => [
        nationalId, firstName, secondName, points,
        gender, birthdate, homeAddress, phone, email, volunteer, cityId, rate,
      ];
}