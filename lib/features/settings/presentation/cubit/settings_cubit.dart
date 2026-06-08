import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/settings_model.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsLoaded(SettingsModel()));

  void updateLanguage(String language) {
    if (state is SettingsLoaded) {
      final currentSettings = (state as SettingsLoaded).settings;
      emit(SettingsLoaded(currentSettings.copyWith(language: language)));
    }
  }

  void toggleSmsNotifications(bool value) {
    if (state is SettingsLoaded) {
      final currentSettings = (state as SettingsLoaded).settings;
      emit(SettingsLoaded(currentSettings.copyWith(smsNotifications: value)));
    }
  }

  void togglePushNotifications(bool value) {
    if (state is SettingsLoaded) {
      final currentSettings = (state as SettingsLoaded).settings;
      emit(SettingsLoaded(currentSettings.copyWith(pushNotifications: value)));
    }
  }

  void toggleDataSharing(bool value) {
    if (state is SettingsLoaded) {
      final currentSettings = (state as SettingsLoaded).settings;
      emit(SettingsLoaded(currentSettings.copyWith(dataSharing: value)));
    }
  }

  void toggleVolunteerMode(bool value) {
    if (state is SettingsLoaded) {
      final currentSettings = (state as SettingsLoaded).settings;
      emit(SettingsLoaded(currentSettings.copyWith(isVolunteerMode: value)));
    }
  }
}