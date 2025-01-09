class EventInfo {
  final String title;
  final String description;
  final String date;
  final String wilaya;
  final String location;
  final String imageUrl;

  EventInfo({
    required this.title,
    required this.description,
    required this.date,
    required this.wilaya,
    required this.location,
    required this.imageUrl,
  });

  factory EventInfo.fromMap(Map<String, dynamic> map) {
    return EventInfo(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      date: map['date'] ?? '',
      wilaya: map['wilaya'] ?? '',
      location: map['location'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }
}