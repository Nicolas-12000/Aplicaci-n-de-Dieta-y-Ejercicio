// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'configuracion.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ConfiguracionAdapter extends TypeAdapter<Configuracion> {
  @override
  final int typeId = 12; // keep consistent with project registrations

  @override
  Configuracion read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Configuracion(
      metaCalorias: (fields[0] as num).toDouble(),
      pesoActual: (fields[1] as num).toDouble(),
      pesoMeta: (fields[2] as num).toDouble(),
    );
  }

  @override
  void write(BinaryWriter writer, Configuracion obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.metaCalorias)
      ..writeByte(1)
      ..write(obj.pesoActual)
      ..writeByte(2)
      ..write(obj.pesoMeta);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConfiguracionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
