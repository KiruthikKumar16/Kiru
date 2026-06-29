class PackingListItem {
  final String id;
  final String title;
  final String category;
  final bool isPacked;

  const PackingListItem({
    required this.id,
    required this.title,
    required this.category,
    this.isPacked = false,
  });

  PackingListItem copyWith({bool? isPacked}) {
    return PackingListItem(
      id: id,
      title: title,
      category: category,
      isPacked: isPacked ?? this.isPacked,
    );
  }
}

class TripModel {
  final String id;
  final String destination;
  final String country;
  final String imageUrl;
  final DateTime startDate;
  final DateTime endDate;
  final String occasion;
  final String weatherTemp;
  final String weatherCondition;
  final List<PackingListItem> packingList;
  final bool isPrivate;

  const TripModel({
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
  });
}
