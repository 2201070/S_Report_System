import '../../data/models/settings_model.dart';
import 'package:equatable/equatable.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object> get props => [];
}

class SettingsInitial extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final SettingsModel settings;

  const SettingsLoaded(this.settings);

  @override
  List<Object> get props => [
        settings.language,
        settings.smsNotifications,
        settings.pushNotifications,
        settings.dataSharing,
        settings.isVolunteerMode, 
      ];
}