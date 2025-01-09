class PlaceInfo {
  final String id;
  String name;
  String description;
  final String category;
  String location;
  final String imageUrl;
  final double rating;
  String status;
  String historicalBackground;
  String mapUrl;
  bool isFavorite;
  final String categoryIcon;

  PlaceInfo({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.location,
    required this.imageUrl,
    required this.rating,
    required this.status,
    required this.historicalBackground,
    required this.mapUrl,
    required this.isFavorite,
    required this.categoryIcon,
  });

  factory PlaceInfo.fromMap(Map<String, dynamic> map) {
    return PlaceInfo(
      id: map['id'] as String,
      name: map['name'] as String,
      imageUrl: map['imageUrl'] as String,
      location: map['location'] as String,
      rating: (map['rating'] as num).toDouble(),
      status: map['status'] as String,
      description: map['description'] as String,
      historicalBackground: map['historicalBackground'] as String,
      mapUrl: map['mapUrl'] as String,
      category: map['category'] as String,
      categoryIcon: map['categoryIcon'] as String,
      isFavorite: map['isFavorite'] as bool,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'location': location,
      'rating': rating,
      'status': status,
      'description': description,
      'historicalBackground': historicalBackground,
      'mapUrl': mapUrl,
      'category': category,
      'categoryIcon': categoryIcon,
      'isFavorite': isFavorite,
    };
  }

  // Create a copy of the PlaceInfo with updated fields
  PlaceInfo copyWith({
    String? name,
    String? description,
    String? location,
    String? status,
    String? historicalBackground,
    String? mapUrl,
    bool? isFavorite,
  }) {
    return PlaceInfo(
      id: this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: this.category,
      location: location ?? this.location,
      imageUrl: this.imageUrl,
      rating: this.rating,
      status: status ?? this.status,
      historicalBackground: historicalBackground ?? this.historicalBackground,
      mapUrl: mapUrl ?? this.mapUrl,
      isFavorite: isFavorite ?? this.isFavorite,
      categoryIcon: this.categoryIcon,
    );
  }
}