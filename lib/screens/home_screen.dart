import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/search_bar.dart' as custom;
import '../widgets/drawer.dart';
import 'package:tourista/screens/Eventinformation.dart';
import 'package:tourista/data/Eventdata.dart'; 
import 'package:tourista/screens/Places_information_page.dart';
import 'package:tourista/data/Placesdata.dart';

import 'Profile_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String selectedCategory = 'All';
  String selectedWilaya = 'Wilaya';
  List<PlaceInfo> touristicPlaces = [
    ouedElBared,
    santaCruz,
    tassili,
    timgad,
    timimoun,
  ];
  List<PlaceInfo> filteredTouristicPlaces = [];

  @override
  void initState() {
    super.initState();
    selectedCategory = 'All';
    filteredTouristicPlaces = touristicPlaces;
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
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
          ],
        ),
      ),
      drawer: const CustomDrawer(),
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
                    const Text('Events & Opportunities', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF6D071A))),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/ev&opp');
                      },
                      child: Text('See All', style: TextStyle(color: const Color(0xFF6D071A).withOpacity(0.5))),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 130,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _eventCard(context, musicFestival),
                    _eventCard(context, artExhibition),
                    _eventCard(context, foodFair),
               
                  ],
                ),
              ),
         
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Container(
                  height: 1,
                  color: const Color(0xFFD79384).withOpacity(0.4),
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
                        child: Text('No places.', style: TextStyle(fontSize: 16, color: Colors.black.withOpacity(0.8))),
                      )
                    : GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        childAspectRatio: 0.66,
                        children: filteredTouristicPlaces.map((placeInfo) {
                          return TouristicPlaceCard(
                            placeInfo: placeInfo,
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
    return Card(
      color: const Color.fromARGB(255, 251, 248, 245),
      margin: const EdgeInsets.all(6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, 
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 0.2,
                    blurRadius: 10,
                    offset: const Offset(0, 2), 
                  ),
                ],
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Image.asset(
                  eventInfo.imageUrl,
                  height: 90,
                  width: 140,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          eventInfo.name,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(width: 20),
                        const Icon(
                          Icons.star,
                          color: Color.fromARGB(255, 198, 178, 3),
                          size: 16,
                        ),
                        Text(eventInfo.rating.toString()),
                      ],
                    ),
                    const SizedBox(height: 4), // Space between title and location
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Color(0xFFD79384),
                          size: 16),
                        const SizedBox(width: 4),
                        Text(eventInfo.location, style: const TextStyle(color: Color(0xFFD79384))),
                      ],
                    ),
                    const SizedBox(height: 4), // Space between location and rating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(
                          Icons.date_range,
                          color: Color(0xFFD79384),
                          size: 16),
                        const SizedBox(width: 4),
                        Text(eventInfo.status, style: const TextStyle(color: Color(0xFFD79384))),
                      ],
                    ),
                    const SizedBox(height: 4), // Space between location and rating

                    SizedBox(
                      height: 23,
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to the event information screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Eventinformation(eventInfo: eventInfo),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6D071A),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0),
                          ),
                        ),
                        child: const Text(
                          'See More',
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TouristicPlaceCard extends StatefulWidget {
  final PlaceInfo placeInfo;

  const TouristicPlaceCard({required this.placeInfo});

  @override
  _TouristicPlaceCardState createState() => _TouristicPlaceCardState();
}

class _TouristicPlaceCardState extends State<TouristicPlaceCard> {
  void _toggleFavorite() {
    setState(() {
      widget.placeInfo.isFavorite = !widget.placeInfo.isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InformationPagess(placeInfo: widget.placeInfo),
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
                  widget.placeInfo.imageUrl,
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
                      widget.placeInfo.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Color.fromARGB(255, 198, 178, 3)),
                      const SizedBox(width: 4),
                      Text(
                        widget.placeInfo.rating.toString(),
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
                      widget.placeInfo.location, 
                      style: const TextStyle(color: Color(0xFFD79384)),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Image.asset(widget.placeInfo.categoryIcon, height: 16, width: 16), 
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      widget.placeInfo.category, 
                      style: const TextStyle(color: Color(0xFFD79384)),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      icon: Icon(
                        widget.placeInfo.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: const Color(0xFF6D071A),
                      ),
                      onPressed: _toggleFavorite,
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