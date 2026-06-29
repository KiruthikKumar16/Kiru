class WardrobeItem {
  final String id;
  final String title;
  final String category; // Tops, Bottoms, Dresses, Outerwear, Shoes, Accessories
  final String imageUrl;
  final String color;
  final String season;
  final int wearCount;
  final double cost;

  const WardrobeItem({
    required this.id,
    required this.title,
    required this.category,
    required this.imageUrl,
    required this.color,
    required this.season,
    this.wearCount = 0,
    this.cost = 0.0,
  });
}
