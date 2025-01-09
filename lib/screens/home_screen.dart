import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/search_bar.dart' as custom;
import '../widgets/drawer.dart';
import 'package:tourista/screens/Eventinformation.dart';
import 'package:tourista/screens/Places_information_page.dart';
import '/database/database.dart';
import 'event_info_new.dart';
import 'Profile_page.dart';

class HomeScreen extends StatefulWidget {
  final String userEmail;

  const HomeScreen({
    super.key,
    required this.userEmail,
  });

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final DatabaseService _databaseService = DatabaseService();
  String get currentUserEmail => widget.userEmail;
  String selectedCategory = 'All';
  String selectedWilaya = 'Wilaya';
  List<PlaceInfo> touristicPlaces = [];
  List<PlaceInfo> filteredTouristicPlaces = [];
  List<EventInfo> events = [];

  void initState() {
    super.initState();
    selectedCategory = 'All';
    _loadPlaces();
    _loadEvents(); 
  }

Future<void> _loadEvents() async {
  try {
    final eventsData = await _databaseService.getAllEvents();
    setState(() {
      events = eventsData.map((eventMap) => EventInfo.fromMap(eventMap)).toList();
      events.sort((a, b) => DateTime.parse(b.date).compareTo(DateTime.parse(a.date))); // Sort events by date in descending order
      events = events.take(3).toList(); // Take only the latest three events
    });
    print('Loaded ${events.length} events'); // Debug print
  } catch (e) {
    print('Error loading events: $e');
  }
}

  Future<void> _loadPlaces() async {
    final places = await _databaseService.getAllPlaces();
    setState(() {
      touristicPlaces = places.map((place) => PlaceInfo.fromMap(place)).toList();
      _filterPlaces();
    });
  }



  void _onCategorySelected(String category) {
    setState(() {
      selectedCategory = category;
      _filterPlaces();
    });
  }

  void _onWilayaSelected(String wilaya) {
    setState(() {
      selectedWilaya = wilaya;
      _filterPlaces();
    });
  }

  void _filterPlaces() {
    setState(() {
      filteredTouristicPlaces = touristicPlaces.where((place) {
        final matchesCategory = selectedCategory == 'All' || place.category == selectedCategory;
        final matchesWilaya = selectedWilaya == 'Wilaya' || place.location == selectedWilaya.split('. ')[1];
        return matchesCategory && matchesWilaya;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
              icon: const Icon(Icons.menu, color: Color(0xFF6D071A)),
            ),
            Image.asset('assets/Images/Logo/logo_red_begin.png', height: 40),
            IconButton(
              icon: const Icon(Icons.person, color: Color(0xFF6D071A)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage(userEmail: currentUserEmail, databaseService: DatabaseService())),
                );
              },
            ),
          ],
        ),
      ),
      drawer: CustomDrawer(
        userEmail: currentUserEmail,
        databaseService: DatabaseService(),

      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              custom.SearchBar(onWilayaSelected: _onWilayaSelected),
              // Categories Section
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('Categories', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF6D071A))),
              ),
              SizedBox(
                height: 60,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _categoryChip('All', 'assets/Images/Icons/all_red.png', 'assets/Images/Icons/all_white.png'),
                    _categoryChip('Nature', 'assets/Images/Icons/nature_red.png', 'assets/Images/Icons/nature_white.png'),
                    _categoryChip('Sea', 'assets/Images/Icons/sea_red.png', 'assets/Images/Icons/sea_white.png'),
                    _categoryChip('Historical', 'assets/Images/Icons/historic_red.png', 'assets/Images/Icons/historic_white.png'),
                    _categoryChip('Forest', 'assets/Images/Icons/forest_red.png', 'assets/Images/Icons/forest_white.png'),
                    _categoryChip('Desert', 'assets/Images/Icons/desert_red.png', 'assets/Images/Icons/desert_white.png'),
                  ],
                ),
              ),
                // Events & Opportunities Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Events & Opportunities',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6D071A)
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/ev&opp');
                        },
                        child: Text(
                          'See All',
                          style: TextStyle(
                            color: const Color(0xFF6D071A).withOpacity(0.5)
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 140,
                  child: events.isEmpty
                    ? const Center(
                        child: Text('No events available'),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: events.length,
                        itemBuilder: (context, index) => _eventCard(context, events[index]),
                      ),
                ),
              // Touristic Places Section
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text('Touristic Places', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF6D071A))),
              ),
              Container(
                color: Colors.white,
                child: filteredTouristicPlaces.isEmpty
                    ? Container(
                        color: Colors.white,
                        margin: const EdgeInsets.only(bottom: 100),
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 25.0),
                        alignment: Alignment.center,
                        child: Text('No places found.', style: TextStyle(fontSize: 16, color: Colors.black.withOpacity(0.8))),
                      )
                    : GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        childAspectRatio: 0.66,
                        children: filteredTouristicPlaces.map((placeInfo) {
                          return TouristicPlaceCard(
                            placeInfo: placeInfo,
                            onFavoriteToggled: () async {
                              await _databaseService.updatePlaceFavoriteStatus(
                                placeInfo.id!,
                                !placeInfo.isFavorite,
                              );
                              _loadPlaces(); // Reload places after updating favorite status
                            },
                          );
                        }).toList(),
                      ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 2),
    );
  }

  Widget _categoryChip(String label, String imagePath, String selectedImagePath) {
    bool isSelected = selectedCategory == label;
    return GestureDetector(
      onTap: () => _onCategorySelected(label),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Chip(
          label: Row(
            children: [
              Image.asset(
                isSelected ? selectedImagePath : imagePath,
                width: 24,
                height: 24,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(fontSize: 16, color: isSelected ? Colors.white : const Color(0xFF6D071A)),
              ),
            ],
          ),
          backgroundColor: isSelected ? const Color(0xFF6D071A) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: const BorderSide(color: Color(0xFF6D071A)),
          ),
        ),
      ),
    );
  }

Widget _eventCard(BuildContext context, EventInfo eventInfo) {
  return Container(
    width: 300, // Fixed width for the card
    margin: const EdgeInsets.all(6),
    child: Card(
      color: const Color.fromARGB(255, 251, 248, 245),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  eventInfo.imageUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      eventInfo.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on, 
                          color: Color(0xFFD79384),
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            eventInfo.wilaya,
                            style: const TextStyle(
                              color: Color(0xFFD79384),
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.date_range,
                          color: Color(0xFFD79384),
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          eventInfo.date,
                          style: const TextStyle(
                            color: Color(0xFFD79384),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      height: 24,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Eventinformation(eventInfo: eventInfo),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6D071A),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        child: const Text(
                          'See More',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}

class TouristicPlaceCard extends StatelessWidget {
  final PlaceInfo placeInfo;
  final VoidCallback onFavoriteToggled;

  const TouristicPlaceCard({
    required this.placeInfo,
    required this.onFavoriteToggled,
  });

  @override
  Widget build(BuildContext context) {
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
              const SizedBox(height: 4),
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
        ),
      ),
    );
  }
}