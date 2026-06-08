import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:s_report_system/features/splash/presentation/screens/splash_screen.dart';
import 'package:s_report_system/features/auth/presentation/screens/onboarding_screen.dart';
import 'package:s_report_system/features/auth/presentation/screens/login_screen.dart';
import 'package:s_report_system/features/report/presentation/screens/dashboard_screen.dart';
import 'package:s_report_system/features/report/presentation/screens/category_selection_screen.dart';
import 'package:s_report_system/features/report/presentation/screens/add_evidence_screen.dart';
import 'package:s_report_system/features/report/presentation/screens/location_picker_screen.dart';
import 'package:s_report_system/features/report/presentation/screens/review_report_screen.dart';
import 'package:s_report_system/features/report/presentation/screens/submission_success_screen.dart';
import 'package:s_report_system/features/report/data/models/create_report_model.dart';
import 'package:s_report_system/features/report/domain/usecases/get_report_details_usecase.dart';
import 'package:s_report_system/features/report/domain/usecases/cancel_report_usecase.dart';
import 'package:s_report_system/features/alerts/presentation/screens/public_alerts_screen.dart';
import 'package:s_report_system/features/alerts/presentation/cubit/alerts_cubit.dart';
import 'package:s_report_system/features/history/presentation/screens/report_history_screen.dart';
import 'package:s_report_system/features/history/presentation/screens/report_details_screen.dart';
import 'package:s_report_system/features/history/presentation/screens/report_tracking_screen.dart';
import 'package:s_report_system/features/history/presentation/cubit/history_cubit.dart';
import 'package:s_report_system/features/profile/presentation/screens/profile_screen.dart';
import 'package:s_report_system/features/profile/presentation/screens/edit_user_profile_screen.dart';
import 'package:s_report_system/features/profile/data/models/user_profile_model.dart';
import 'package:s_report_system/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:s_report_system/features/settings/presentation/screens/settings_screen.dart';
import 'package:s_report_system/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:s_report_system/features/volunteer/presentation/screens/volunteer_layout.dart';
import 'package:s_report_system/features/volunteer/presentation/screens/volunteer_inbox_screen.dart';
import 'package:s_report_system/features/volunteer/presentation/screens/mission_details_screen.dart';
import 'package:s_report_system/features/volunteer/presentation/screens/volunteer_history_screen.dart';
import 'package:s_report_system/features/volunteer/presentation/cubit/volunteer_history_cubit.dart';
import 'package:s_report_system/features/volunteer/domain/entities/volunteer_task_entity.dart';
import 'package:s_report_system/features/leaderboard/presentation/screens/leaderboard_screen.dart';
import 'package:s_report_system/features/leaderboard/presentation/cubit/leaderboard_cubit.dart';
import 'package:s_report_system/report_injection.dart';

class AppRouter {
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String dashboard = '/';
  static const String alerts = '/alerts';
  static const String history = '/history';
  static const String reportDetails = '/report-details';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String settings = '/settings';
  static const String volunteer = '/volunteer';
  static const String volunteerInbox = '/volunteer_inbox';
  static const String volunteerHistory = '/volunteer-history';
  static const String leaderboard = '/leaderboard';
  static const String missionDetails = '/mission_details';
  static const String selectCategory = '/select_category';
  static const String addEvidence = '/add_evidence';
  static const String locationPicker = '/location_picker';
  static const String reviewReport = '/review_report';
  static const String submissionSuccess = '/submission_success';
  static const String reportTracking = '/report_tracking';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        );
      case onboarding:
        return MaterialPageRoute(
          builder: (context) => const OnboardingScreen(),
        );
      case login:
        return MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        );
      case register:
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(
              child: Text(
                'Register Screen Placeholder',
                style: TextStyle(color: Colors.white),
              ),
            ),
            backgroundColor: Color(0xFF0D1117),
          ),
        );
      case dashboard:
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: sl<SettingsCubit>(), // 🚀 تم الحقن المباشر
            child: const DashboardScreen(),
          ),
        );
      case alerts:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (blocContext) => AlertsCubit(),
            child: PublicAlertsScreen(
              onBack: () => Navigator.of(context).pop(),
            ),
          ),
        );
      case history:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (_) => sl<HistoryCubit>(),
            child: ReportHistoryScreen(
              onBack: () => Navigator.of(context).pop(),
            ),
          ),
        );
      case reportDetails:
        final id = settings.arguments as int;
        return MaterialPageRoute(
          builder: (context) => MultiRepositoryProvider(
            providers: [
              RepositoryProvider.value(value: sl<GetReportDetailsUseCase>()),
              RepositoryProvider.value(value: sl<CancelReportUseCase>()),
            ],
            child: ReportDetailsScreen(reportId: id),
          ),
        );
      case profile:
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: sl<ProfileCubit>()..getProfile(),
            child: ProfileScreen(
              onBack: () => Navigator.of(context).pop(),
            ),
          ),
        );
      case editProfile:
        final user = settings.arguments as UserProfileModel;
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: sl<ProfileCubit>(),
            child: EditUserProfileScreen(user: user),
          ),
        );
      case AppRouter.settings:
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: sl<SettingsCubit>(), // 🚀 تم الحقن المباشر لحل الشاشة الحمراء
            child: SettingsScreen(
              onBack: () => Navigator.of(context).pop(),
            ),
          ),
        );
      case AppRouter.volunteer:
        return MaterialPageRoute(
          builder: (context) => VolunteerLayout(
            onNavigateHome: () => Navigator.of(context).pop(),
            onNavigateSettings: () =>
                Navigator.of(context).pushNamed(AppRouter.settings),
          ),
        );
      case AppRouter.volunteerInbox:
        return MaterialPageRoute(
          builder: (context) => VolunteerInboxScreen(
            onBack: () => Navigator.of(context).pop(),
            onViewMap: () =>
                Navigator.of(context).pushNamed('/volunteer_map'),
          ),
        );
      case AppRouter.volunteerHistory:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (_) => sl<VolunteerHistoryCubit>(),
            child: const VolunteerHistoryScreen(),
          ),
        );
      case AppRouter.leaderboard:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => sl<LeaderboardCubit>()..getLeaderboard(), 
            child: const LeaderboardScreen(),
          ),
        );
      case AppRouter.missionDetails:
        final mission = settings.arguments as VolunteerTaskEntity;
        return MaterialPageRoute(
          builder: (context) => MissionDetailsScreen(
            mission: mission,
            onBack: () => Navigator.of(context).pop(),
          ),
        );
      case AppRouter.selectCategory:
        return MaterialPageRoute(
          builder: (context) => CategorySelectionScreen(
            onBack: () => Navigator.of(context).pop(),
          ),
        );
      case AppRouter.addEvidence:
        final categoryId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (context) => AddEvidenceScreen(
            categoryId: categoryId,
            onBack: () => Navigator.of(context).pop(),
          ),
        );
      case AppRouter.locationPicker:
        return MaterialPageRoute(
          builder: (context) => LocationPickerScreen(
            onBack: () => Navigator.of(context).pop(),
          ),
        );
      case AppRouter.reviewReport:
        final reportData = settings.arguments as CreateReportModel?;
        final data = reportData ??
            CreateReportModel(
              reportType: 'environmental',
              imageFiles: const [],
              description: '',
              latitude: 30.0444,
              longitude: 31.2357,
              cityId: 2,
            );
        return MaterialPageRoute(
          builder: (context) => ReviewReportScreen(
            reportData: data,
            onBack: () => Navigator.of(context).pop(),
          ),
        );
      case AppRouter.submissionSuccess:
        final trackingId =
            settings.arguments as String? ?? 'SR-UNKNOWN';
        return MaterialPageRoute(
          builder: (context) => SubmissionSuccessScreen(
            trackingId: trackingId,
          ),
        );
      case AppRouter.reportTracking:
        final trackingId =
            settings.arguments as String? ?? 'SR-UNKNOWN';
        return MaterialPageRoute(
          builder: (context) => ReportTrackingScreen(
            reportId: trackingId,
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}