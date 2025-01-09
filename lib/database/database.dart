import 'package:sqflite/sqflite.dart';
import 'database_helper.dart';

class DatabaseService {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<void> insertUser(Map<String, dynamic> user) async {
    final db = await _databaseHelper.database;
    
    // Check if user already exists
    final existing = await getUser(user['email']);
    if (existing != null) {
      throw Exception('User already exists with this email');
    }
    
    try {
      await db.insert(
        'users',
        user,
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
      print('User inserted successfully: ${user['email']}');
    } catch (e) {
      print('Error inserting user: $e');
      throw Exception('Failed to create account: $e');
    }
  }

  Future<Map<String, dynamic>?> getUser(String email) async {
    try {
      final db = await _databaseHelper.database;
      print('Searching for user with email: $email');
      
      final results = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [email],
      );
      
      print('Query results: $results');
      
      if (results.isNotEmpty) {
        return results.first;
      }
      print('No user found with email: $email');
      return null;
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  // Verify database connection is working
  Future<bool> isDatabaseWorking() async {
    try {
      final db = await _databaseHelper.database;
      await db.query('users', limit: 1);
      return true;
    } catch (e) {
      print('Database connection error: $e');
      return false;
    }
  }

  // Debug method to list all users
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await _databaseHelper.database;
    final users = await db.query('users');
    print('All users in database: $users');
    return users;
  }

  // events
  Future<void> insertEvent(Map<String, dynamic> event) async {
    final db = await _databaseHelper.database;

    // Check if the event already exists based on title and date
    List<Map<String, dynamic>> existingEvent = await db.query(
      'events',
      where: 'title = ? AND date = ?',
      whereArgs: [event['title'], event['date']],
    );

    if (existingEvent.isNotEmpty) {
      print('Event already exists. Skipping insertion.');
      return;
    }

    // Insert the event if it doesn't exist
    await db.insert('events', event);
    print('Inserted event: ${event['title']}');
  }

  Future<List<Map<String, dynamic>>> getAllEvents() async {
    final db = await _databaseHelper.database;
    final events = await db.query('events');
    print('DatabaseService: Fetched ${events.length} events from database'); // Debugging: Print fetched events count
    print('Events data: $events'); // Debugging: Print fetched events data
    return events;
  }


  Future<List<Map<String, dynamic>>> filterEvents(String year, String month, String day) async {
    final db = await _databaseHelper.database;
    String whereClause = '';
    List<String> whereArgs = [];

    if (year != 'Y') {
      whereClause += 'strftime("%Y", date) = ?';
      whereArgs.add(year);
    }
    if (month != 'M') {
      if (whereClause.isNotEmpty) whereClause += ' AND ';
      whereClause += 'strftime("%m", date) = ?';
      whereArgs.add(month);
    }
    if (day != 'D') {
      if (whereClause.isNotEmpty) whereClause += ' AND ';
      whereClause += 'strftime("%d", date) = ?';
      whereArgs.add(day);
    }

    if (whereClause.isEmpty) {
      // No filters applied, return all events
      return await db.query('events');
    } else {
      // Apply filters
      return await db.query(
        'events',
        where: whereClause,
        whereArgs: whereArgs.isEmpty ? null : whereArgs,
      );
    }
  }

  Future<void> updatePassword(String email, String newPassword) async {
    final db = await _databaseHelper.database;
    await db.update(
      'users',
      {'password': newPassword},
      where: 'email = ?',
      whereArgs: [email],
    );
  }

  Future<void> updateUser(Map<String, dynamic> user) async {
    final db = await _databaseHelper.database;
    await db.update(
      'users',
      {
        'firstName': user['firstName'],
        'familyName': user['familyName'],
        'wilaya': user['wilaya'],
        'profileImage': user['profileImage'],
      },
      where: 'email = ?',
      whereArgs: [user['email']],
    );
  }

  // Wilaya and Guide methods
  Future<List<Map<String, dynamic>>> getAllWilayas() async {
    final db = await _databaseHelper.database;
    return await db.query('wilayas', orderBy: 'id');
  }

  Future<List<Map<String, dynamic>>> getGuidesByWilaya(int wilayaId) async {
    final db = await _databaseHelper.database;
    return await db.rawQuery('''
      SELECT DISTINCT g.*
      FROM guides g
      INNER JOIN guide_wilayas gw ON g.id = gw.guideId
      WHERE gw.wilayaId = ?
    ''', [wilayaId]);
  }

  Future<List<Map<String, dynamic>>> getWilayasByGuide(int guideId) async {
    final db = await _databaseHelper.database;
    return await db.rawQuery('''
      SELECT w.*
      FROM wilayas w
      INNER JOIN guide_wilayas gw ON w.id = gw.wilayaId
      WHERE gw.guideId = ?
    ''', [guideId]);
  }

  // places
  Future<List<Map<String, dynamic>>> getAllPlaces() async {
    final db = await _databaseHelper.database;
    return await db.query('places');
  }

  Future<Map<String, dynamic>?> getPlaceById(int id) async {
    final db = await _databaseHelper.database;
    final results = await db.query(
      'places',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (results.isNotEmpty) {
      return results.first;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getPlacesByCategory(String category) async {
    final db = await _databaseHelper.database;
    return await db.query(
      'places',
      where: 'category = ?',
      whereArgs: [category],
    );
  }

  Future<void> updatePlaceFavoriteStatus(int id, bool isFavorite) async {
    final db = await _databaseHelper.database;
    await db.update(
      'places',
      {'isFavorite': isFavorite ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updatePlaceRating(int id, double rating) async {
    final db = await _databaseHelper.database;
    await db.update(
      'places',
      {'rating': rating},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}