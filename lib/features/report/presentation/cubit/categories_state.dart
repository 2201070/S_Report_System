import 'package:equatable/equatable.dart';
import 'package:s_report_system/features/report/data/models/report_category_model.dart';

abstract class CategoriesState extends Equatable {
  const CategoriesState();
  @override
  List<Object?> get props => [];
}

class CategoriesInitial extends CategoriesState {
  const CategoriesInitial();
}

class CategoriesLoading extends CategoriesState {
  const CategoriesLoading();
}

class CategoriesSuccess extends CategoriesState {
  final List<ReportCategoryModel> categories;
  const CategoriesSuccess({required this.categories});

  @override
  List<Object?> get props => [categories];
}

class CategoriesError extends CategoriesState {
  final String message;
  const CategoriesError({required this.message});

  @override
  List<Object?> get props => [message];
}
