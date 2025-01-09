// lib/screens/event_info_new.dart
class EventInfo {
  final String id;
  final String title;
  final String description;
  final String date;
  final String wilaya;
  final String location;
  final String imageUrl;
  final double rating;

  EventInfo({
    this.id = '',
    required this.title,
    required this.description,
    required this.date,
    required this.wilaya,
    required this.location,
    required this.imageUrl,
    required this.rating,
  });

  factory EventInfo.fromMap(Map<String, dynamic> map) {
    return EventInfo(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      date: map['date'] ?? '',
      wilaya: map['wilaya'] ?? '',
      location: map['location'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      rating: (map['rating'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'date': date,
      'wilaya': wilaya,
      'location': location,
      'imageUrl': imageUrl,
      'rating': rating,
    };
  }
}