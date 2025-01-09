//import 'dart:convert';
//import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class PlaceApi {
  static const String baseUrl = 'http://192.168.216.10:8081';
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String collection = 'places';
  
  // Get all places
static Future<List<Map<String, dynamic>>> getPlaces() async {
    try {
      final QuerySnapshot snapshot = await _firestore.collection(collection).get();
      
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,
          'name': data['name'] ?? '',
          'description': data['description'] ?? '',
          'category': data['category'] ?? 'All',
          'location': data['location'] ?? '',
          'imageUrl': data['imageUrl'] ?? 'assets/Images/placeholder.png',
          'rating': (data['rating'] ?? 0.0).toDouble(),
          'status': data['status'] ?? 'Open',
          'historicalBackground': data['historicalBackground'] ?? '',
          'mapUrl': data['mapUrl'] ?? 'https://maps.google.com',
          'isFavorite': data['isFavorite'] ?? false,
          'categoryIcon': _getCategoryIcon(data['category'] ?? 'All'),
        };
      }).toList();
    } catch (e) {
      print('Error fetching places: $e');
      throw Exception('Failed to fetch places: $e');
    }
  }

  // Update a place - now handling boolean properly
static Future<void> updatePlace(String id, Map<String, dynamic> place) async {
    try {
      // Remove the categoryIcon field as it's computed
      place.remove('categoryIcon');
      
      await _firestore.collection(collection).doc(id).update(place);
    } catch (e) {
      print('Error updating place: $e');
      throw Exception('Failed to update place: $e');
    }
  }

  // Helper method to get category icon based on category
  static String _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'nature':
        return 'assets/Images/Icons/nature_red.png';
      case 'sea':
        return 'assets/Images/Icons/sea_red.png';
      case 'historical':
        return 'assets/Images/Icons/historic_red.png';
      case 'forest':
        return 'assets/Images/Icons/forest_red.png';
      case 'desert':
        return 'assets/Images/Icons/desert_red.png';
      default:
        return 'assets/Images/Icons/all_red.png';
    }
  }

  // Add a new place
static Future<void> addPlace(Map<String, dynamic> place) async {
    try {
      // Remove the categoryIcon field as it's computed
      place.remove('categoryIcon');
      
      await _firestore.collection(collection).add(place);
    } catch (e) {
      print('Error adding place: $e');
      throw Exception('Failed to add place: $e');
    }
  }


  // Delete a place
  static Future<void> deletePlace(String id) async {
    try {
      await _firestore.collection(collection).doc(id).delete();
    } catch (e) {
      print('Error deleting place: $e');
      throw Exception('Failed to delete place: $e');
    }
  }

   Future<void> toggleFavorite(String placeId, bool isFavorite) async {
    try {
      await _firestore.collection('places').doc(placeId).update({
        'isFavorite': isFavorite,
      });
    } catch (e) {
      print('Error toggling favorite: $e');
      throw e;
    }
  }

// Stream of places for real-time updates
  static Stream<List<Map<String, dynamic>>> getPlacesStream() {
    return _firestore.collection(collection).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'name': data['name'] ?? '',
          'description': data['description'] ?? '',
          'category': data['category'] ?? 'All',
          'location': data['location'] ?? '',
          'imageUrl': data['imageUrl'] ?? 'assets/Images/placeholder.png',
          'rating': (data['rating'] ?? 0.0).toDouble(),
          'status': data['status'] ?? 'Open',
          'historicalBackground': data['historicalBackground'] ?? '',
          'mapUrl': data['mapUrl'] ?? 'https://maps.google.com',
          'isFavorite': data['isFavorite'] ?? false,
          'categoryIcon': _getCategoryIcon(data['category'] ?? 'All'),
        };
      }).toList();
    });
  }
}