import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
<<<<<<< HEAD
import '../database/database.dart';
import 'Places_information_page.dart';
=======

>>>>>>> 5ddc415 (Refactor backend structure and update dependencies)

class FavoritePlacesScreen extends StatefulWidget {
  const FavoritePlacesScreen({super.key});

  @override
  _FavoritePlacesScreenState createState() => _FavoritePlacesScreenState();
}

class _FavoritePlacesScreenState extends State<FavoritePlacesScreen> {
<<<<<<< HEAD
  final DatabaseService _databaseService = DatabaseService();
  List<PlaceInfo> favoritePlaces = [];

  @override
  void initState() {
    super.initState();
    _loadFavoritePlaces();
  }

  Future<void> _loadFavoritePlaces() async {
    final places = await _databaseService.getAllPlaces();
    if (mounted) {
      setState(() {
        favoritePlaces = places
            .map((place) => PlaceInfo.fromMap(place))
            .where((place) => place.isFavorite)
            .toList();
      });
    }
  }

  Future<void> _toggleFavorite(PlaceInfo place) async {
    await _databaseService.updatePlaceFavoriteStatus(place.id!, !place.isFavorite);
    // Add a small delay to ensure database update is complete
    await Future.delayed(const Duration(milliseconds: 100));
    if (mounted) {
      await _loadFavoritePlaces();
      // Pop back to previous screen if no favorites left
      if (favoritePlaces.isEmpty) {
        Navigator.of(context).pop();
      }
    }
  }
=======
  List<Map<String, dynamic>> favoritePlaces = [
    {'title': 'Santa Cruz', 'location': 'Oran', 'category': 'Historical', 'imagePath': 'assets/Images/Places/Oran.jpg', 'rating': 4.5, 'categoryIcon': 'assets/Images/Icons/historic.png'},
    {'title': 'Oued El Bared', 'location': 'Setif', 'category': 'Nature', 'imagePath': 'assets/Images/Places/Oued_bared.jpg', 'rating': 3.7, 'categoryIcon': 'assets/Images/Icons/nature.png'},
    {'title': 'Timguad', 'location': 'Oran', 'category': 'Nature', 'imagePath': 'assets/Images/Places/Timguad.jpg', 'rating': 4.8, 'categoryIcon': 'assets/Images/Icons/nature.png'},
    {'title': 'Santa Cruz', 'location': 'Oran', 'category': 'Historical', 'imagePath': 'assets/Images/Places/timimoun.jpg', 'rating': 4.5, 'categoryIcon': 'assets/Images/Icons/historic.png'},
    {'title': 'Santa Cruz', 'location': 'Oran', 'category': 'Historical', 'imagePath': 'assets/Images/Places/Tassili.jpg', 'rating': 4.5, 'categoryIcon': 'assets/Images/Icons/historic.png'},
    {'title': 'Santa Cruz', 'location': 'Oran', 'category': 'Historical', 'imagePath': 'assets/Images/Places/Oued_bared.jpg', 'rating': 4.5, 'categoryIcon': 'assets/Images/Icons/historic.png'},
  ];
>>>>>>> 5ddc415 (Refactor backend structure and update dependencies)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favourite Places'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 0.635,
                  children: favoritePlaces.map((place) {
                    return TouristicPlaceCard(
<<<<<<< HEAD
                      placeInfo: place,
                      onFavoriteToggled: () => _toggleFavorite(place),
=======
                      title: place['title'],
                      location: place['location'],
                      category: place['category'],
                      imagePath: place['imagePath'],
                      rating: place['rating'],
                      isFavorite: true,
                      onFavoriteToggle: () {
                        setState(() {
                          favoritePlaces.remove(place);
                        });
                      },
                      categoryIcon: place['categoryIcon'],
>>>>>>> 5ddc415 (Refactor backend structure and update dependencies)
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 1),
    );
  }
}

<<<<<<< HEAD
class TouristicPlaceCard extends StatelessWidget {
  final PlaceInfo placeInfo;
  final VoidCallback onFavoriteToggled;

  const TouristicPlaceCard({
    required this.placeInfo,
    required this.onFavoriteToggled,
=======

class TouristicPlaceCard extends StatelessWidget {
  final String title;
  final String location;
  final String category;
  final String imagePath;
  final double rating;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final String categoryIcon;

  const TouristicPlaceCard({super.key, 
    required this.title,
    required this.location,
    required this.category,
    required this.imagePath,
    required this.rating,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.categoryIcon,
>>>>>>> 5ddc415 (Refactor backend structure and update dependencies)
  });

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InformationPagess(placeInfo: placeInfo),
          ),
        );
      },
      child: Card(
        color: const Color(0xFFF9F2EC),
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  placeInfo.imageUrl,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      placeInfo.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Color.fromARGB(255, 198, 178, 3)),
                      const SizedBox(width: 4),
                      Text(
                        placeInfo.rating.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFD79384)),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.location_pin, color: Color(0xFFD79384), size: 16),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      placeInfo.location,
                      style: const TextStyle(color: Color(0xFFD79384)),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Image.asset(placeInfo.categoryIcon, height: 16, width: 16),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      placeInfo.category,
                      style: const TextStyle(color: Color(0xFFD79384)),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      icon: Icon(
                        placeInfo.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: const Color(0xFF6D071A),
                      ),
                      onPressed: onFavoriteToggled,
                    ),
                  ),
                ],
              ),
            ],
          ),
=======
    return Card(
      color: const Color(0xFFF9F2EC),
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                imagePath,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.star, color: Color.fromARGB(255, 198, 178, 3)),
                    const SizedBox(width: 4),
                    Text(
                      rating.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFD79384)),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_pin, color: Color(0xFFD79384), size: 16),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    location,
                    style: const TextStyle(color: Color(0xFFD79384)),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Image.asset(categoryIcon, height: 16, width: 16),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    category,
                    style: const TextStyle(color: Color(0xFFD79384)),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 10),
                Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: const Color(0xFF6D071A),
                    ),
                    onPressed: onFavoriteToggle,
                  ),
                ),
              ],
            ),
          ],
>>>>>>> 5ddc415 (Refactor backend structure and update dependencies)
        ),
      ),
    );
  }
}