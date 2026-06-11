import 'package:easy_localization/easy_localization.dart';

extension LocalizationFallbackExtension on String {
  /// Translates the string key using easy_localization.
  /// If the translation key is missing in the JSON files, easy_localization returns
  /// the key itself (e.g. 'profile.edit_profile'). In that case, this method returns
  /// the [fallback] value instead, preventing raw translation keys from showing in the UI.
  String trWithFallback(
    String fallback, {
    List<String>? args,
    Map<String, String>? namedArgs,
    String? gender,
  }) {
    final translated = this.tr(args: args, namedArgs: namedArgs, gender: gender);

    return translated == this ? fallback : translated;
  }
}