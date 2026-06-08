import 'package:equatable/equatable.dart';

class ReportCategoryModel extends Equatable {
  final int id;
  final String name;

  const ReportCategoryModel({required this.id, required this.name});

  factory ReportCategoryModel.fromJson(Map<String, dynamic> json) {
    return ReportCategoryModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString() ?? '',
    );
  }

  @override
  List<Object?> get props => [id, name];
}
