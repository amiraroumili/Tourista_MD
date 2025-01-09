import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/search_bar.dart' as custom;
import '../widgets/drawer.dart';
import 'package:tourista/screens/Eventinformation.dart';
import 'package:tourista/screens/Places_information_page.dart';
import 'event_info_new.dart';
import 'Profile_page.dart';
import '../api/place_api.dart';
import '../api/event_api.dart';
import '../Admin/admin_utils.dart';
import '../Admin/place_info.dart';
import '../Admin/event_info.dart';
import 'place_class.dart';

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
  String get currentUserEmail => widget.userEmail;
  bool get isAdmin => AdminUtils.isAdmin(currentUserEmail);
  String selectedCategory = 'All';
  String selectedWilaya = 'Wilaya';
  List<EventInfo> events = [];
  final EventService _eventService = EventService();
  final PlaceApi _placeService = PlaceApi();

  @override
  void initState() {
    super.initState();
    selectedCategory = 'All';
    _loadEvents();
  }

  Future<void> _toggleFavorite(PlaceInfo placeInfo) async {
    try {
      await _placeService.toggleFavorite(placeInfo.id.toString(), !placeInfo.isFavorite);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to update favorite status. Please try again.'))
      );
    }
  }

  Future<void> _loadEvents() async {
    try {
      final eventsData = await _eventService.getEvents();
      if (mounted) {
        setState(() {
          events = eventsData;
          events.sort((a, b) => DateTime.parse(b.date).compareTo(DateTime.parse(a.date)));
          events = events.take(3).toList();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load events: $e')),
        );
      }
      print('Error loading events: $e');
    }
  }

  void _onCategorySelected(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  void _onWilayaSelected(String wilaya) {
    setState(() {
      selectedWilaya = wilaya;
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
            Row(
              children: [
                Image.asset('assets/Images/Logo/logo_red_begin.png', height: 40),
                if (isAdmin)
                  Container(
                    margin: EdgeInsets.only(left: 8),
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Color(0xFF6D071A),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'ADMIN',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.person, color: Color(0xFF6D071A)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage(userEmail: currentUserEmail)),
                );
              },
            ),
          ],
        ),
      ),
      drawer: CustomDrawer(
        userEmail: currentUserEmail,
      ),
      floatingActionButton: isAdmin ? FloatingActionButton(
        backgroundColor: Color(0xFF6D071A),
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () {
          _showAddPlaceDialog(context);
        },
      ) : null,
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              custom.SearchBar(onWilayaSelected: _onWilayaSelected),
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
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text('Touristic Places', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF6D071A))),
              ),
              _buildTouristicPlacesSection(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 2),
    );
  }
  void _showAddPlaceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Place or Event'),
          actions: [
            
             ElevatedButton(
              onPressed: () {
                // Navigate to add place screen
                Navigator.pushNamed(context, '/add_event');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF6D071A),
              ),
              child: Text('Add Event' , 
              style: 
              TextStyle( 
                color: Colors.white,
              ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to add place screen
                Navigator.pushNamed(context, '/add_place');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF6D071A),
              ),
              child: Text('Add Place' , 
              style: 
              TextStyle( 
                color: Colors.white,
              ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel', style: TextStyle(color: Color(0xFF6D071A))),
            ),
          ],
        );
      },
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
      width: 300,
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
                  child: eventInfo.imageUrl.startsWith('http')
                    ? Image.network(
                        eventInfo.imageUrl,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 100,
                            height: 100,
                            color: Colors.grey[300],
                            child: const Icon(Icons.error),
                          );
                        },
                      )
                    : Image.asset(
                        eventInfo.imageUrl,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 100,
                            height: 100,
                            color: Colors.grey[300],
                            child: const Icon(Icons.error),
                          );
                        },
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
                                builder: (context) => isAdmin
                                  ? AdminEventInformation(eventInfo: eventInfo)
                                  : Eventinformation(eventInfo: eventInfo),
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

 Widget _buildTouristicPlacesSection() {
    return StreamBuilder<List<PlaceInfo>>(
      stream: PlaceApi.getPlacesStream().map((list) => list.map((map) => PlaceInfo.fromMap(map)).toList()),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error loading places: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        final places = snapshot.data ?? [];
        final filteredPlaces = places.where((place) {
          final matchesCategory = selectedCategory == 'All' || place.category == selectedCategory;
          final matchesWilaya = selectedWilaya == 'Wilaya' || place.location == selectedWilaya.split('. ')[1];
          return matchesCategory && matchesWilaya;
        }).toList();

        if (filteredPlaces.isEmpty) {
          return Container(
            margin: const EdgeInsets.only(bottom: 100),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 25.0),
            alignment: Alignment.center,
            child: Text('No places found.',
              style: TextStyle(fontSize: 16, color: Colors.black.withOpacity(0.8))
            ),
          );
        }

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 0.66,
          children: filteredPlaces.map((placeInfo) {
            return TouristicPlaceCard(
              placeInfo: placeInfo,
              onFavoriteToggled: () => _toggleFavorite(placeInfo),
              isAdmin: isAdmin, 
            );
          }).toList(),
        );
      },
    );
  }
}

class TouristicPlaceCard extends StatelessWidget {
  final PlaceInfo placeInfo;
  final VoidCallback onFavoriteToggled;
  final bool isAdmin; 

  const TouristicPlaceCard({
    required this.placeInfo,
    required this.onFavoriteToggled,
    this.isAdmin = false, 
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFF9F2EC),
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 3,
      child: InkWell( 
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => isAdmin
                ? AdminPlaceInformation(placeInfo: placeInfo)
                : InformationPagess(placeInfo: placeInfo),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: placeInfo.imageUrl.startsWith('http')
                    ? Image.network(
                        placeInfo.imageUrl,
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
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