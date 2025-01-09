import 'package:cloud_firestore/cloud_firestore.dart';

class StatisticsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<int> fetchUserCount() async {
    QuerySnapshot snapshot = await _firestore.collection('users').get();
    return snapshot.size;
  }

  Future<int> fetchPlaceCount() async {
    QuerySnapshot snapshot = await _firestore.collection('places').get();
    return snapshot.size;
  }

  Future<int> fetchEventCount() async {
    QuerySnapshot snapshot = await _firestore.collection('events').get();
    return snapshot.size;
  }

  Future<List<Map<String, dynamic>>> fetchEventStatistics() async {
    QuerySnapshot snapshot = await _firestore.collection('events').get();
    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  Future<List<Map<String, dynamic>>> fetchUserStatistics() async {
    QuerySnapshot snapshot = await _firestore.collection('users').get();
    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }
}