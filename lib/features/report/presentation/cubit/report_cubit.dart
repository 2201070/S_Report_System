import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:s_report_system/features/report/data/models/create_report_model.dart';
import 'package:s_report_system/features/report/domain/usecases/submit_report_usecase.dart';
import 'package:s_report_system/features/report/domain/usecases/sync_offline_reports_usecase.dart';
import 'package:s_report_system/features/report/presentation/cubit/report_state.dart';

class ReportCubit extends Cubit<ReportState> {
  final SubmitReportUseCase submitReportUseCase;
  final SyncOfflineReportsUseCase syncOfflineReportsUseCase;

  String? _draftCategory;
  List<String> _draftImages = [];
  String _draftDescription = '';
  double _draftLat = 0.0;
  double _draftLng = 0.0;
  String? _draftVoicePath;
  int _draftCityId = 1; 

  String? get draftCategory => _draftCategory;
  List<String> get draftImages => List.unmodifiable(_draftImages);
  String get draftDescription => _draftDescription;
  double get draftLat => _draftLat;
  double get draftLng => _draftLng;
  String? get draftVoicePath => _draftVoicePath;
  int get draftCityId => _draftCityId; 

  ReportCubit({
    required this.submitReportUseCase,
    required this.syncOfflineReportsUseCase,
  }) : super(const ReportInitial());

  void updateCategory(String categoryId) => _draftCategory = categoryId;

  void addImages(List<String> paths) {
    _draftImages = [...paths];
  }

  void updateDescription(String text) => _draftDescription = text;

  void updateLocation(double lat, double lng) {
    _draftLat = lat;
    _draftLng = lng;
  }

  void updateVoicePath(String path) => _draftVoicePath = path;

  void updateCityId(int cityId) => _draftCityId = cityId; 

  Future<void> submitReport({int userRate = 0, CreateReportModel? overrideReport}) async {
    
    if (userRate < 2) {
      emit(const ReportError(message: "Your account is temporarily restricted from submitting reports due to repeated inaccurate submissions."));
      return;
    }

    emit(const ReportLoading());

    final report = overrideReport ??
        CreateReportModel(
          description: _draftDescription,
          latitude: _draftLat,
          longitude: _draftLng,
          reportType: _draftCategory ?? 'environmental',
          cityId: _draftCityId, 
          imageFiles: _draftImages,
          voiceFile: _draftVoicePath,
        );

    final result = await submitReportUseCase(report);

    result.fold(
      (failure) => emit(ReportError(message: failure.errorMessage)),
      (response) => emit(ReportSuccess(response: response)),
    );
  }

  Future<void> syncOfflineReports() async {
    debugPrint('CUBIT_DEBUG: Attempting to sync offline reports...');
    final result = await syncOfflineReportsUseCase();
    result.fold(
      (failure) => debugPrint('CUBIT_DEBUG: Sync Failed -> ${failure.errorMessage}'),
      (syncResponse) {
        if (syncResponse.successCount > 0) {
          debugPrint('CUBIT_DEBUG: Successfully synced ${syncResponse.successCount} reports!');
        }
        if (syncResponse.failureCount > 0) {
          debugPrint('CUBIT_DEBUG: Failed to sync ${syncResponse.failureCount} reports.');
        }
      },
    );
  }

  void reset() {
    _draftCategory = null;
    _draftImages = [];
    _draftDescription = '';
    _draftLat = 0.0;
    _draftLng = 0.0;
    _draftVoicePath = null;
    _draftCityId = 1; 
    emit(const ReportInitial());
  }
}