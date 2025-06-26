// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trabajador_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TrabajadorAdapter extends TypeAdapter<Trabajador> {
  @override
  final int typeId = 0;

  @override
  Trabajador read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Trabajador(
      nombres: fields[0] as String,
      apellidos: fields[1] as String,
      fechaNacimiento: fields[2] as DateTime,
      sueldo: fields[3] as double,
      imagenPath: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Trabajador obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.nombres)
      ..writeByte(1)
      ..write(obj.apellidos)
      ..writeByte(2)
      ..write(obj.fechaNacimiento)
      ..writeByte(3)
      ..write(obj.sueldo)
      ..writeByte(4)
      ..write(obj.imagenPath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrabajadorAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
