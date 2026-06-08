import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:s_report_system/core/navigation/app_router.dart';
import 'package:s_report_system/core/utils/size_config.dart';
import 'package:s_report_system/core/localization/language_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:s_report_system/features/auth/logic/firebase_options.dart';
import 'package:s_report_system/features/report/data/models/create_report_model.dart';
import 'package:s_report_system/features/report/data/models/offline_report_model.dart';
import 'package:s_report_system/features/report/presentation/cubit/report_cubit.dart';
import 'package:s_report_system/features/volunteer/presentation/cubit/volunteer_cubit.dart';
import 'package:s_report_system/features/leaderboard/presentation/cubit/leaderboard_cubit.dart';
import 'package:s_report_system/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:s_report_system/report_injection.dart';
import 'package:s_report_system/features/settings/presentation/cubit/settings_cubit.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("System Log: تم استقبال إشعار في الخلفية - ${message.messageId}");

}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    if (message.notification != null) {
      final String currentUserId =
          FirebaseAuth.instance.currentUser?.uid ?? "unknown";

      if (currentUserId != "unknown") {
        // الحقن في قاعدة البيانات
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUserId)
            .collection('notifications')
            .add({
              'title': message.notification!.title,
              'body': message.notification!.body,
              'date':
                  FieldValue.serverTimestamp(), 
            });
        print("System Log: تم استلام الإشعار وحفظه في الداتابيز بنجاح!");

        
      }
    }
  });
  
  await Hive.initFlutter();
  
  // Register adapters
  Hive.registerAdapter(CreateReportModelAdapter());
  Hive.registerAdapter(OfflineReportModelAdapter());
  
  // Open Boxes
  final reportBox = await Hive.openBox<CreateReportModel>('reports_box');
  GetIt.instance.registerSingleton<Box<CreateReportModel>>(reportBox);

  final offlineBox = await Hive.openBox<OfflineReportModel>('offline_reports_box');
  GetIt.instance.registerSingleton<Box<OfflineReportModel>>(offlineBox);

  initReport();

  await LanguageManager.init();

  runApp(
    EasyLocalization(
      supportedLocales: LanguageManager.supportedLocales,
      path: LanguageManager.path,
      fallbackLocale: LanguageManager.fallbackLocale,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ReportCubit>(
          create: (context) => sl<ReportCubit>(),
        ),
        BlocProvider<VolunteerCubit>(
          create: (context) => sl<VolunteerCubit>(),
        ),
        BlocProvider<LeaderboardCubit>(
          create: (context) => sl<LeaderboardCubit>(),
        ),
        BlocProvider<ProfileCubit>(
          create: (context) => sl<ProfileCubit>(),
        ),
        BlocProvider<SettingsCubit>(
          create: (context) => sl<SettingsCubit>(),
        ),
      ],
      child: MaterialApp(
        title: 'S-Report System',
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale, // Handles RTL/LTR layout switching automatically
        theme: ThemeData(
          brightness: Brightness.dark,
          fontFamily: 'Inter',
          useMaterial3: true,
        ),
        builder: (context, child) {
          SizeConfig().init(context);
          return child!;
        },
        onGenerateRoute: AppRouter.onGenerateRoute,
        initialRoute: AppRouter.splash,
      ),
    );
  }
}