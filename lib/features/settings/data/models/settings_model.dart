class SettingsModel {
  final String language;
  final bool smsNotifications;
  final bool pushNotifications;
  final bool dataSharing;
  final bool isVolunteerMode; 

  const SettingsModel({
    this.language = 'english',
    this.smsNotifications = true,
    this.pushNotifications = true,
    this.dataSharing = false,
    this.isVolunteerMode = false, 
  });

  SettingsModel copyWith({
    String? language,
    bool? smsNotifications,
    bool? pushNotifications,
    bool? dataSharing,
    bool? isVolunteerMode,
  }) {
    return SettingsModel(
      language: language ?? this.language,
      smsNotifications: smsNotifications ?? this.smsNotifications,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      dataSharing: dataSharing ?? this.dataSharing,
      isVolunteerMode: isVolunteerMode ?? this.isVolunteerMode, 
    );
  }
}