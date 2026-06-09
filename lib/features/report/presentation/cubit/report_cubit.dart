import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:s_report_system/features/report/data/models/create_report_model.dart';
import 'package:s_report_system/features/report/domain/usecases/submit_report_usecase.dart';
import 'package:s_report_system/features/report/domain/usecases/sync_offline_reports_usecase.dart';
import 'package:s_report_system/features/report/presentation/cubit/report_state.dart';

class ReportCubit extends Cubit<ReportState> {
  final SubmitReportUseCase submitReportUseCase;
  final SyncOfflineReportsUseCase syncOfflineReportsUseCase;

  // ── Draft data accumulated across the multi-step flow ──
  String? _draftCategory;
  List<String> _draftImages = [];
  String _draftDescription = '';
  double _draftLat = 0.0;
  double _draftLng = 0.0;
  String? _draftVoicePath;
  int _draftCityId = 1; // 👈 1. إضافة المتغير الخاص بالمدينة

  String? get draftCategory => _draftCategory;
  List<String> get draftImages => List.unmodifiable(_draftImages);
  String get draftDescription => _draftDescription;
  double get draftLat => _draftLat;
  double get draftLng => _draftLng;
  String? get draftVoicePath => _draftVoicePath;
  int get draftCityId => _draftCityId; // 👈 2. إضافة الـ Getter

  ReportCubit({
    required this.submitReportUseCase,
    required this.syncOfflineReportsUseCase,
  }) : super(const ReportInitial());

  // ── Draft setters called by Add Evidence / Location Picker screens ──
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

  // 👈 3. دالة لتحديث المدينة من الـ UI
  void updateCityId(int cityId) => _draftCityId = cityId; 

  // ── Final submission ──
  Future<void> submitReport([CreateReportModel? overrideReport]) async {
    emit(const ReportLoading());

    final report = overrideReport ??
        CreateReportModel(
          description: _draftDescription,
          latitude: _draftLat,
          longitude: _draftLng,
          reportType: _draftCategory ?? 'environmental',
          cityId: _draftCityId, // 👈 4. تمرير المتغير للـ Model هنا بدلاً من تركه فارغاً
          imageFiles: _draftImages,
          voiceFile: _draftVoicePath,
        );

    final result = await submitReportUseCase(report);

    result.fold(
      (failure) => emit(ReportError(message: failure.errorMessage)),
      (response) => emit(ReportSuccess(response: response)),
    );
  }

  // ── Offline Sync ──
  Future<void> syncOfflineReports() async {
    debugPrint('CUBIT_DEBUG: Attempting to sync offline reports...');
    
    final result = await syncOfflineReportsUseCase();
    
    result.fold(
      (failure) {
        debugPrint('CUBIT_DEBUG: Sync Failed -> ${failure.errorMessage}');
      },
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

  /// Reset all draft data and state.
  void reset() {
    _draftCategory = null;
    _draftImages = [];
    _draftDescription = '';
    _draftLat = 0.0;
    _draftLng = 0.0;
    _draftVoicePath = null;
    _draftCityId = 1; // 👈 5. تصفير قيمة المدينة
    emit(const ReportInitial());
  }
}