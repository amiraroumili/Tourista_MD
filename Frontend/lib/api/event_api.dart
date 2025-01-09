// lib/services/event_service.dart
import '../screens/event_info_new.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventService {
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collection = 'events';

 // Get all events
  Future<List<EventInfo>> getEvents() async {
    try {
      final QuerySnapshot snapshot = await _firestore.collection(collection).get();
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Add document ID to the data
        return EventInfo.fromMap(data);
      }).toList();
    } catch (e) {
      throw Exception('Failed to load events: $e');
    }
  }

  // Add new event
  Future<EventInfo> addEvent(EventInfo event) async {
    try {
      final docRef = await _firestore.collection(collection).add(event.toJson());
      final doc = await docRef.get();
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return EventInfo.fromMap(data);
    } catch (e) {
      throw Exception('Failed to add event: $e');
    }
  }

  // Get single event
  Future<EventInfo> getEvent(String id) async {
    try {
      final doc = await _firestore.collection(collection).doc(id).get();
      if (!doc.exists) {
        throw Exception('Event not found');
      }
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return EventInfo.fromMap(data);
    } catch (e) {
      throw Exception('Failed to load event: $e');
    }
  }

  // Update event
 Future<EventInfo> updateEvent(String id, EventInfo event) async {
    try {
      // First check if the document exists
      final docSnapshot = await _firestore.collection(collection).doc(id).get();
      if (!docSnapshot.exists) {
        throw Exception('Event not found');
      }

      // Perform the update
      await _firestore.collection(collection).doc(id).update(event.toJson());
      
      // Fetch the updated document
      final updatedDoc = await _firestore.collection(collection).doc(id).get();
      Map<String, dynamic> data = updatedDoc.data() as Map<String, dynamic>;
      data['id'] = updatedDoc.id;
      return EventInfo.fromMap(data);
    } catch (e) {
      throw Exception('Failed to update event: $e');
    }
  }

 // Delete event
  Future<void> deleteEvent(String id) async {
    try {
      await _firestore.collection(collection).doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete event: $e');
    }
  }

// Filter events
  Future<List<EventInfo>> filterEvents(String year, String month, String day) async {
    try {
      QuerySnapshot snapshot = await _firestore.collection(collection).get();
      List<EventInfo> events = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return EventInfo.fromMap(data);
      }).toList();

      return events.where((event) {
        if (year == 'Y' && month == 'M' && day == 'D') {
          return true;
        }

        final eventDate = DateTime.parse(event.date);
        
        bool matchesYear = year == 'Y' || eventDate.year.toString() == year;
        bool matchesMonth = month == 'M' || 
            eventDate.month.toString().padLeft(2, '0') == month;
        bool matchesDay = day == 'D' || 
            eventDate.day.toString().padLeft(2, '0') == day;

        return matchesYear && matchesMonth && matchesDay;
      }).toList();
    } catch (e) {
      throw Exception('Failed to filter events: $e');
    }
  }

    // Add a method to listen to real-time updates
  Stream<EventInfo> getEventStream(String id) {
    return _firestore
        .collection(collection)
        .doc(id)
        .snapshots()
        .map((snapshot) {
          if (!snapshot.exists) {
            throw Exception('Event not found');
          }
          Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
          data['id'] = snapshot.id;
          return EventInfo.fromMap(data);
        });
  }
}
