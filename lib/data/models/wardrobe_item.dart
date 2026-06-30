import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class WardrobeItem extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String category; // Tops, Bottoms, Dresses, Outerwear, Shoes, Accessories

  @HiveField(3)
  final String imageUrl;

  @HiveField(4)
  final String color;

  @HiveField(5)
  final String season;

  @HiveField(6)
  final int wearCount;

  @HiveField(7)
  final double cost;

  WardrobeItem({
    required this.id,
    required this.title,
    required this.category,
    required this.imageUrl,
    required this.color,
    required this.season,
    this.wearCount = 0,
    this.cost = 0.0,
  });

  WardrobeItem copyWith({
    String? id,
    String? title,
    String? category,
    String? imageUrl,
    String? color,
    String? season,
    int? wearCount,
    double? cost,
  }) {
    return WardrobeItem(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      color: color ?? this.color,
      season: season ?? this.season,
      wearCount: wearCount ?? this.wearCount,
      cost: cost ?? this.cost,
    );
  }
}

class WardrobeItemAdapter extends TypeAdapter<WardrobeItem> {
  @override
  final int typeId = 0;

  @override
  WardrobeItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WardrobeItem(
      id: fields[0] as String,
      title: fields[1] as String,
      category: fields[2] as String,
      imageUrl: fields[3] as String,
      color: fields[4] as String,
      season: fields[5] as String,
      wearCount: fields[6] as int? ?? 0,
      cost: fields[7] as double? ?? 0.0,
    );
  }

  @override
  void write(BinaryWriter writer, WardrobeItem obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.imageUrl)
      ..writeByte(4)
      ..write(obj.color)
      ..writeByte(5)
      ..write(obj.season)
      ..writeByte(6)
      ..write(obj.wearCount)
      ..writeByte(7)
      ..write(obj.cost);
  }
}
