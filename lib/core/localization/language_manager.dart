import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class LanguageManager {
  static const String path = 'assets/translations';
  static const Locale english = Locale('en');
  static const Locale arabic = Locale('ar');

  static const List<Locale> supportedLocales = [english, arabic];
  static const Locale fallbackLocale = arabic; // Defaults to Arabic since it's an Egyptian govt app

  static Future<void> init() async 
  {
    await EasyLocalization.ensureInitialized();
  }

  static Future<void> changeLanguage(BuildContext context, Locale newLocale) async 
  {
    await context.setLocale(newLocale);
  }

  static bool isArabic(BuildContext context) 
  {
    return context.locale.languageCode == 'ar'; 
  }
}
