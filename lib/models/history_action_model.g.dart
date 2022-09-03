// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_action_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HistoryActionAdapter extends TypeAdapter<HistoryAction> {
  @override
  final int typeId = 2;

  @override
  HistoryAction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HistoryAction(
      oldProduct: fields[0] as Product,
      updatedProduct: fields[1] as Product,
    );
  }

  @override
  void write(BinaryWriter writer, HistoryAction obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.oldProduct)
      ..writeByte(1)
      ..write(obj.updatedProduct);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HistoryActionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
