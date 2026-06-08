import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:s_report_system/features/report/domain/usecases/get_categories_usecase.dart';
import 'package:s_report_system/features/report/presentation/cubit/categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  final GetCategoriesUseCase getCategoriesUseCase;

  CategoriesCubit({required this.getCategoriesUseCase}) : super(const CategoriesInitial()) {
    getCategories();
  }

  Future<void> getCategories() async {
    emit(const CategoriesLoading());
    final result = await getCategoriesUseCase();
    result.fold(
      (failure) => emit(CategoriesError(message: failure.errorMessage)),
      (cats) => emit(CategoriesSuccess(categories: cats)),
    );
  }

  void refresh() => getCategories();
}
