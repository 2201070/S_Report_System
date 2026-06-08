// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_report_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CreateReportModelAdapter extends TypeAdapter<CreateReportModel> {
  @override
  final int typeId = 0;

  @override
  CreateReportModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CreateReportModel(
      description: fields[0] as String,
      latitude: fields[1] as double,
      longitude: fields[2] as double,
      reportType: fields[3] as String,
      cityId: fields[4] as int,
      imageFiles: (fields[5] as List).cast<String>(),
      voiceFile: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CreateReportModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.description)
      ..writeByte(1)
      ..write(obj.latitude)
      ..writeByte(2)
      ..write(obj.longitude)
      ..writeByte(3)
      ..write(obj.reportType)
      ..writeByte(4)
      ..write(obj.cityId)
      ..writeByte(5)
      ..write(obj.imageFiles)
      ..writeByte(6)
      ..write(obj.voiceFile);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateReportModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
