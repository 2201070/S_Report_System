import 'package:hive_flutter/hive_flutter.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:s_report_system/core/api/dio_factory.dart'; 
import 'package:s_report_system/core/network/network_info.dart';

// Report Feature Imports
import 'package:s_report_system/features/report/data/models/create_report_model.dart';
import 'package:s_report_system/features/report/data/models/offline_report_model.dart';
import 'package:s_report_system/features/report/data/datasources/report_local_datasource.dart';
import 'package:s_report_system/features/report/data/datasources/report_remote_data_source.dart';
import 'package:s_report_system/features/report/data/repositories/report_repository_impl.dart';
import 'package:s_report_system/features/report/domain/repositories/i_report_repository.dart';
import 'package:s_report_system/features/report/domain/usecases/submit_report_usecase.dart';
import 'package:s_report_system/features/report/domain/usecases/get_my_reports_usecase.dart';
import 'package:s_report_system/features/report/domain/usecases/get_report_details_usecase.dart';
import 'package:s_report_system/features/report/domain/usecases/get_categories_usecase.dart';
import 'package:s_report_system/features/report/domain/usecases/cancel_report_usecase.dart';
import 'package:s_report_system/features/report/domain/usecases/sync_offline_reports_usecase.dart';
import 'package:s_report_system/features/report/presentation/cubit/report_cubit.dart';
import 'package:s_report_system/features/report/presentation/cubit/categories_cubit.dart';

// History Feature Imports
import 'package:s_report_system/features/history/presentation/cubit/history_cubit.dart';

// Profile Feature Imports
import 'package:s_report_system/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:s_report_system/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:s_report_system/features/profile/domain/repositories/i_profile_repository.dart';
import 'package:s_report_system/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:s_report_system/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:s_report_system/features/profile/presentation/cubit/profile_cubit.dart';

// Volunteer Profile Imports 
import 'package:s_report_system/features/profile/data/datasources/volunteer_profile_remote_data_source.dart';
import 'package:s_report_system/features/profile/data/repositories/volunteer_profile_repository_impl.dart';
import 'package:s_report_system/features/profile/domain/repositories/volunteer_profile_repository.dart';
import 'package:s_report_system/features/profile/domain/usecases/get_volunteer_profile_usecase.dart';
import 'package:s_report_system/features/profile/presentation/cubit/volunteer_profile_cubit.dart';

// Volunteer Feature Imports
import 'package:s_report_system/features/volunteer/data/datasources/volunteer_remote_data_source.dart';
import 'package:s_report_system/features/volunteer/data/repositories/volunteer_repository_impl.dart';
import 'package:s_report_system/features/volunteer/domain/repositories/i_volunteer_repository.dart';
import 'package:s_report_system/features/volunteer/domain/usecases/volunteer_usecases.dart';
import 'package:s_report_system/features/volunteer/presentation/cubit/volunteer_cubit.dart'; // تم تعديل الخطأ هنا
import 'package:s_report_system/features/volunteer/presentation/cubit/volunteer_history_cubit.dart';
// Leaderboard Feature Imports
import 'package:s_report_system/features/leaderboard/data/datasources/leaderboard_remote_data_source.dart';
import 'package:s_report_system/features/leaderboard/data/repositories/leaderboard_repository_impl.dart';
import 'package:s_report_system/features/leaderboard/domain/repositories/i_leaderboard_repository.dart';
import 'package:s_report_system/features/leaderboard/domain/usecases/get_leaderboard_usecase.dart';
import 'package:s_report_system/features/leaderboard/presentation/cubit/leaderboard_cubit.dart';

// Settings Import
import 'package:s_report_system/features/settings/presentation/cubit/settings_cubit.dart';

final sl = GetIt.instance;

void initReport() {
  if (!sl.isRegistered<Dio>()) {
    sl.registerLazySingleton(() => DioFactory.getDio()); 
  }

  if (!sl.isRegistered<InternetConnectionChecker>()) {
    sl.registerLazySingleton(() => InternetConnectionChecker.createInstance());
  }

  if (!sl.isRegistered<NetworkInfo>()) {
    sl.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(sl<InternetConnectionChecker>()),
    );
  }

  // ==================== Report Feature ====================
  sl.registerLazySingleton<ReportRemoteDataSource>(
    () => ReportRemoteDataSourceImpl(dio: sl<Dio>()),
  );

  sl.registerLazySingleton<ReportLocalDataSource>(
    () => ReportLocalDataSourceImpl(reportBox: sl<Box<OfflineReportModel>>()),
  );

  sl.registerLazySingleton<IReportRepository>(
    () => ReportRepositoryImpl(
      remoteDataSource: sl<ReportRemoteDataSource>(),
      localDataSource: sl<ReportLocalDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  sl.registerLazySingleton(() => SubmitReportUseCase(sl<IReportRepository>()));
  sl.registerLazySingleton(() => GetMyReportsUseCase(sl<IReportRepository>()));
  sl.registerLazySingleton(() => GetReportDetailsUseCase(sl<IReportRepository>()));
  sl.registerLazySingleton(() => GetCategoriesUseCase(sl<IReportRepository>()));
  sl.registerLazySingleton(() => CancelReportUseCase(sl<IReportRepository>()));
  sl.registerLazySingleton(() => SyncOfflineReportsUseCase(sl<IReportRepository>()));

  sl.registerLazySingleton(() => ReportCubit(
    submitReportUseCase: sl<SubmitReportUseCase>(),
    syncOfflineReportsUseCase: sl<SyncOfflineReportsUseCase>(),
  ));
  
  sl.registerFactory(() => HistoryCubit(getMyReportsUseCase: sl<GetMyReportsUseCase>()));
  sl.registerFactory(() => CategoriesCubit(getCategoriesUseCase: sl<GetCategoriesUseCase>()));


  // ==================== Profile Feature ====================
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(dio: sl<Dio>()),
  );
  sl.registerLazySingleton<IProfileRepository>(
    () => ProfileRepositoryImpl(remoteDataSource: sl<ProfileRemoteDataSource>()),
  );
  sl.registerLazySingleton(() => GetProfileUseCase(sl<IProfileRepository>()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl<IProfileRepository>())); 

  sl.registerLazySingleton(() => ProfileCubit(
    getProfileUseCase: sl<GetProfileUseCase>(),
    updateProfileUseCase: sl<UpdateProfileUseCase>(), 
  ));

  sl.registerLazySingleton<VolunteerProfileRemoteDataSource>(
    () => VolunteerProfileRemoteDataSourceImpl(dio: sl<Dio>()),
  );
  sl.registerLazySingleton<VolunteerProfileRepository>(
    () => VolunteerProfileRepositoryImpl(remoteDataSource: sl<VolunteerProfileRemoteDataSource>()),
  );
  sl.registerLazySingleton(() => GetVolunteerProfileUseCase(sl<VolunteerProfileRepository>()));
  sl.registerFactory(() => VolunteerProfileCubit(getVolunteerProfileUseCase: sl<GetVolunteerProfileUseCase>()));


  // ==================== Volunteer Feature ====================
  sl.registerLazySingleton<VolunteerRemoteDataSource>(
    () => VolunteerRemoteDataSourceImpl(dio: sl<Dio>()),
  );

  sl.registerLazySingleton<IVolunteerRepository>(
    () => VolunteerRepositoryImpl(remoteDataSource: sl<VolunteerRemoteDataSource>()),
  );
  sl.registerLazySingleton(() => GetNearbyMissionsUseCase(sl<IVolunteerRepository>()));
  sl.registerLazySingleton(() => AcceptMissionUseCase(sl<IVolunteerRepository>()));
  sl.registerLazySingleton(() => CompleteMissionUseCase(sl<IVolunteerRepository>()));
  sl.registerLazySingleton(() => CancelMissionUseCase(sl<IVolunteerRepository>()));
  sl.registerLazySingleton(() => GetCurrentMissionUseCase(sl<IVolunteerRepository>()));
  sl.registerLazySingleton(() => GetVolunteerHistoryUseCase(sl<IVolunteerRepository>()));
  sl.registerFactory(() => VolunteerHistoryCubit(getVolunteerHistoryUseCase: sl<GetVolunteerHistoryUseCase>()));

  if (!sl.isRegistered<VolunteerCubit>()) {
    sl.registerFactory(() => VolunteerCubit(
      getNearbyMissionsUseCase: sl<GetNearbyMissionsUseCase>(),
      acceptMissionUseCase: sl<AcceptMissionUseCase>(),
      completeMissionUseCase: sl<CompleteMissionUseCase>(),
      cancelMissionUseCase: sl<CancelMissionUseCase>(),
      getCurrentMissionUseCase: sl<GetCurrentMissionUseCase>(),
    ));
  }


  // ==================== Leaderboard Feature ====================
  sl.registerLazySingleton<LeaderboardRemoteDataSource>(
    () => LeaderboardRemoteDataSourceImpl(dio: sl<Dio>()),
  );

  sl.registerLazySingleton<ILeaderboardRepository>(
    () => LeaderboardRepositoryImpl(remoteDataSource: sl<LeaderboardRemoteDataSource>()),
  );

  sl.registerLazySingleton(() => GetLeaderboardUseCase(sl<ILeaderboardRepository>()));
  sl.registerFactory(() => LeaderboardCubit(getLeaderboardUseCase: sl<GetLeaderboardUseCase>()));

  // ==================== Settings Feature ====================
  sl.registerLazySingleton(() => SettingsCubit());
}