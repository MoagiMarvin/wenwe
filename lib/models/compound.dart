class Compound {
  final String id;
  final String name;
  final String street;
  final String city;
  final String province;
  final String postalCode;
  final String description;
  final List<String> amenities;
  final List<String> tags;
  final double latitude;
  final double longitude;
  final List<String> images;
  // ...rooms, restaurants, images, etc.

  Compound({
    required this.id,
    required this.name,
    required this.street,
    required this.city,
    required this.province,
    required this.postalCode,
    required this.description,
    required this.amenities,
    required this.tags,
    required this.latitude,
    required this.longitude,
    required this.images,
  });
} 