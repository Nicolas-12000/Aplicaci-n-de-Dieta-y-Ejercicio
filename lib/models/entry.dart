import 'package:hive/hive.dart';

/// Manual Hive adapters included so the project can run without build_runner.

@HiveType(typeId: 0)
enum EntryKind {
  @HiveField(0)
  diet,
  @HiveField(1)
  exercise,
}

@HiveType(typeId: 1)
class Entry extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  int calories;

  @HiveField(2)
  DateTime date;

  @HiveField(3)
  EntryKind kind;

  Entry({
    required this.title,
    required this.calories,
    required this.date,
    required this.kind,
  });
}

class EntryKindAdapter extends TypeAdapter<EntryKind> {
  @override
  final int typeId = 0;

  @override
  EntryKind read(BinaryReader reader) {
    final index = reader.readByte();
    return EntryKind.values[index];
  }

  @override
  void write(BinaryWriter writer, EntryKind obj) {
    writer.writeByte(obj.index);
  }
}

class EntryAdapter extends TypeAdapter<Entry> {
  @override
  final int typeId = 1;

  @override
  Entry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < numOfFields; i++) {
      final key = reader.readByte();
      fields[key] = reader.read();
    }
    return Entry(
      title: fields[0] as String,
      calories: fields[1] as int,
      date: fields[2] as DateTime,
      kind: fields[3] as EntryKind,
    );
  }

  @override
  void write(BinaryWriter writer, Entry obj) {
    writer.writeByte(4);
    writer.writeByte(0);
    writer.write(obj.title);
    writer.writeByte(1);
    writer.write(obj.calories);
    writer.writeByte(2);
    writer.write(obj.date);
    writer.writeByte(3);
    writer.write(obj.kind);
  }
}
