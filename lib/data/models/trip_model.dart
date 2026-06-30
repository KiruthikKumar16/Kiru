import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class PackingListItem extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String category;

  @HiveField(3)
  final bool isPacked;

  PackingListItem({
    required this.id,
    required this.title,
    required this.category,
    this.isPacked = false,
  });

  PackingListItem copyWith({
    String? id,
    String? title,
    String? category,
    bool? isPacked,
  }) {
    return PackingListItem(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      isPacked: isPacked ?? this.isPacked,
    );
  }
}

@HiveType(typeId: 2)
class TripModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String destination;

  @HiveField(2)
  final String country;

  @HiveField(3)
  final String imageUrl;

  @HiveField(4)
  final DateTime startDate;

  @HiveField(5)
  final DateTime endDate;

  @HiveField(6)
  final String occasion;

  @HiveField(7)
  final String weatherTemp;

  @HiveField(8)
  final String weatherCondition;

  @HiveField(9)
  final List<PackingListItem> packingList;

  @HiveField(10)
  final bool isPrivate;

  @HiveField(11)
  final bool hideDates;

  @HiveField(12)
  final bool hideLocation;

  @HiveField(13)
  final List<String> dailyOutfits;

  TripModel({
    required this.id,
    required this.destination,
    required this.country,
    required this.imageUrl,
    required this.startDate,
    required this.endDate,
    required this.occasion,
    required this.weatherTemp,
    required this.weatherCondition,
    required this.packingList,
    this.isPrivate = true,
    this.hideDates = true,
    this.hideLocation = true,
    this.dailyOutfits = const [],
  });

  TripModel copyWith({
    String? id,
    String? destination,
    String? country,
    String? imageUrl,
    DateTime? startDate,
    DateTime? endDate,
    String? occasion,
    String? weatherTemp,
    String? weatherCondition,
    List<PackingListItem>? packingList,
    bool? isPrivate,
    bool? hideDates,
    bool? hideLocation,
    List<String>? dailyOutfits,
  }) {
    return TripModel(
      id: id ?? this.id,
      destination: destination ?? this.destination,
      country: country ?? this.country,
      imageUrl: imageUrl ?? this.imageUrl,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      occasion: occasion ?? this.occasion,
      weatherTemp: weatherTemp ?? this.weatherTemp,
      weatherCondition: weatherCondition ?? this.weatherCondition,
      packingList: packingList ?? this.packingList,
      isPrivate: isPrivate ?? this.isPrivate,
      hideDates: hideDates ?? this.hideDates,
      hideLocation: hideLocation ?? this.hideLocation,
      dailyOutfits: dailyOutfits ?? this.dailyOutfits,
    );
  }
}

class PackingListItemAdapter extends TypeAdapter<PackingListItem> {
  @override
  final int typeId = 1;

  @override
  PackingListItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PackingListItem(
      id: fields[0] as String,
      title: fields[1] as String,
      category: fields[2] as String,
      isPacked: fields[3] as bool? ?? false,
    );
  }

  @override
  void write(BinaryWriter writer, PackingListItem obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.isPacked);
  }
}

class TripModelAdapter extends TypeAdapter<TripModel> {
  @override
  final int typeId = 2;

  @override
  TripModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TripModel(
      id: fields[0] as String,
      destination: fields[1] as String,
      country: fields[2] as String,
      imageUrl: fields[3] as String,
      startDate: fields[4] as DateTime,
      endDate: fields[5] as DateTime,
      occasion: fields[6] as String,
      weatherTemp: fields[7] as String,
      weatherCondition: fields[8] as String,
      packingList: (fields[9] as List).cast<PackingListItem>(),
      isPrivate: fields[10] as bool? ?? true,
      hideDates: fields[11] as bool? ?? true,
      hideLocation: fields[12] as bool? ?? true,
      dailyOutfits: (fields[13] as List?)?.cast<String>() ?? const [],
    );
  }

  @override
  void write(BinaryWriter writer, TripModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.destination)
      ..writeByte(2)
      ..write(obj.country)
      ..writeByte(3)
      ..write(obj.imageUrl)
      ..writeByte(4)
      ..write(obj.startDate)
      ..writeByte(5)
      ..write(obj.endDate)
      ..writeByte(6)
      ..write(obj.occasion)
      ..writeByte(7)
      ..write(obj.weatherTemp)
      ..writeByte(8)
      ..write(obj.weatherCondition)
      ..writeByte(9)
      ..write(obj.packingList)
      ..writeByte(10)
      ..write(obj.isPrivate)
      ..writeByte(11)
      ..write(obj.hideDates)
      ..writeByte(12)
      ..write(obj.hideLocation)
      ..writeByte(13)
      ..write(obj.dailyOutfits);
  }
}
