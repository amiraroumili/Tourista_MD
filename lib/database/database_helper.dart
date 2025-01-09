//database/database_helper.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
 
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'tourista_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT UNIQUE,
        password TEXT,
        firstName TEXT,
        familyName TEXT,
        wilaya TEXT
      )
    ''');
    await db.execute('''
       CREATE TABLE events (
        event_id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT,
        date TEXT, -- Format: YYYY-MM-DD
        wilaya TEXT,
        location TEXT,
        imageUrl TEXT
      )
    ''');
    // Create wilayas table
    await db.execute('''
      CREATE TABLE wilayas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT UNIQUE
      )
    ''');
    // Create guides table
    await db.execute('''
      CREATE TABLE guides (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT UNIQUE,
        phone TEXT,
        imageUrl TEXT
      )
    ''');
    // Create guide_wilayas table for many-to-many relationship
    await db.execute('''
      CREATE TABLE guide_wilayas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        guideId INTEGER,
        wilayaId INTEGER,
        FOREIGN KEY (guideId) REFERENCES guides (id),
        FOREIGN KEY (wilayaId) REFERENCES wilayas (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE places (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        imageUrl TEXT,
        location TEXT,
        rating REAL,
        status TEXT,
        description TEXT,
        historicalBackground TEXT,
        mapUrl TEXT,
        category TEXT,
        categoryIcon TEXT,
        isFavorite INTEGER DEFAULT 0
      )
    ''');
    // Insert initial data
    await _insertWilayas(db);
    await _insertGuidesAndAssociations(db);
    await _insertInitialPlaces(db);
    await _insertDummyData(db); // Insert dummy events data
  }  

   Future<void> _insertDummyData(Database db) async {
    await db.insert('events', {
      'title': 'Music Festival',
      'description': 'A vibrant festival featuring live music and performances.',
      'date': '2024-11-12',
      'wilaya': 'Oran',
      'location': 'https://maps.app.goo.gl/NpBXhiDHpKvnYKgF8',
      'imageUrl': 'assets/Images/Events/music_fest.jpg',
    });

    await db.insert('events', {
      'title': 'Art Exhibition',
      'description': 'A showcase of stunning artwork from local and international artists.',
      'date': '2024-11-25',
      'wilaya': 'Setif',
      'location': 'https://maps.app.goo.gl/29WQtxrWSqd1W3iK7',
      'imageUrl': 'assets/Images/Events/art_exh.jpg',
    });

    await db.insert('events', {
      'title': 'Food Fair',
      'description': 'An event to explore delicious cuisines and dishes from around the world.',
      'date': '2024-12-05',
      'wilaya': 'Oran',
      'location': 'https://maps.app.goo.gl/NpBXhiDHpKvnYKgF8',
      'imageUrl': 'assets/Images/Events/food_fair.jpg',
    });

    await db.insert('events', {
      'title': 'Tech Conference',
      'description': 'A gathering of tech enthusiasts and professionals discussing the latest trends.',
      'date': '2024-10-12',
      'wilaya': 'Algiers',
      'location': 'https://maps.app.goo.gl/nMoWjwLHCVYjhEe3A',
      'imageUrl': 'assets/Images/Events/tech_conf.jpg',
    });

    await db.insert('events', {
      'title': 'Book Fair',
      'description': 'An event for book lovers to explore a wide range of literature.',
      'date': '2024-01-12',
      'wilaya': 'Oran',
      'location': 'https://maps.app.goo.gl/NpBXhiDHpKvnYKgF8',
      'imageUrl': 'assets/Images/Events/book_fair.jpg',
    });

    await db.insert('events', {
      'title': 'Film Festival',
      'description': 'A celebration of cinema with screenings and discussions.',
      'date': '2024-09-09',
      'wilaya': 'Oran',
      'location': 'https://maps.app.goo.gl/NpBXhiDHpKvnYKgF8',
      'imageUrl': 'assets/Images/Events/film_fest.jpg',
    });
  }
  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE events (
          event_id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          description TEXT,
          date TEXT, -- Format: YYYY-MM-DD
          wilaya TEXT,
          location TEXT,
          imageUrl TEXT
        )
      ''');
    }
  }
  
  Future<void> _insertInitialPlaces(Database db) async {
    final places = [
{
    'name': 'Oued El Bared',
    'imageUrl': 'assets/Images/Places/Oued_bared.jpg',
    'location': 'Setif',
    'rating': 4.5,
    'status': 'Open',
    'description': 'Oued El Bared is a stunning natural site known for its crystal-clear streams, lush greenery, and serene atmosphere. It is a perfect getaway for nature enthusiasts and hikers.',
    'historicalBackground': 'Oued El Bared has a rich history, with its origins dating back to ancient times when it served as a vital water source for local communities and a site of cultural significance. Its beauty has made it a treasured destination over the centuries.',
    'mapUrl': 'https://maps.app.goo.gl/Rn4rvtanxz3eACqXA',
    'category': 'Nature',
    'categoryIcon': 'assets/Images/Icons/nature.png',
    'isFavorite': 0
  },
  {
    'name': 'Santa Cruz',
    'imageUrl': 'assets/Images/Places/Oran.jpg',
    'location': 'Oran',
    'rating': 3.5,
    'status': 'Open',
    'description': 'Santa Cruz is a historic landmark located atop Mount Murdjadjo, offering panoramic views of Oran and the Mediterranean Sea. It is known for its iconic fort and the adjacent Chapel of Santa Cruz, attracting visitors from around the world.',
    'historicalBackground': 'Santa Cruz Fort and the chapel were built during the Spanish occupation in the 16th century to protect Oran from invaders. The site also holds significant religious and cultural importance, symbolizing resilience and unity for the local population.',
    'mapUrl': 'https://maps.app.goo.gl/aCiGE4HoN5QNUqWL9',
    'category': 'Historical',
    'categoryIcon': 'assets/Images/Icons/historic.png',
    'isFavorite': 0
  },
  {
    'name': 'Tassili',
    'imageUrl': 'assets/Images/Places/Tassili.jpg',
    'location': 'Illizi',
    'rating': 4.5,
    'status': 'Open',
    'description': 'Tassili n\'Ajjer is a breathtaking desert region renowned for its dramatic rock formations, deep canyons, and prehistoric rock art. It is a UNESCO World Heritage Site and a must-visit destination for nature lovers and history enthusiasts.',
    'historicalBackground': 'Tassili n\'Ajjer holds immense historical significance, featuring over 15,000 pieces of ancient rock art that date back as far as 12,000 years. These paintings and carvings depict life in the Sahara before it became a desert, showcasing animals, human activities, and spiritual beliefs of early civilizations.',
    'mapUrl': 'https://maps.app.goo.gl/EieT3YzVZqiE3bkw9',
    'category': 'Desert',
    'categoryIcon': 'assets/Images/Icons/desert.png',
    'isFavorite': 0
  },
  {
    'name': 'Timgad',
    'imageUrl': 'assets/Images/Places/Timguad.jpg',
    'location': 'Batna',
    'rating': 4.5,
    'status': 'Open',
    'description': 'Timgad, also known as Thamugadi, is an extraordinary archaeological site featuring well-preserved Roman ruins. It is a stunning example of Roman town planning and architecture.',
    'historicalBackground': 'Founded by Emperor Trajan in AD 100, Timgad was built as a Roman colony for military veterans. The city showcases remarkable ruins, including a theater, baths, temples, and the iconic Arch of Trajan, reflecting the grandeur of Roman civilization.',
    'mapUrl': 'https://maps.app.goo.gl/4qG8jdoUer2DY9iHA',
    'category': 'Historical',
    'categoryIcon': 'assets/Images/Icons/historic.png',
    'isFavorite': 0
  },
  {
    'name': 'Timimoun',
    'imageUrl': 'assets/Images/Places/timimoun.jpg',
    'location': 'Timimoun',
    'rating': 3.5,
    'status': 'Open',
    'description': 'Timimoun, known as the \'Red Oasis,\' is a picturesque desert town characterized by its stunning red clay architecture, palm groves, and breathtaking Saharan landscapes. It is a gateway to Algeria\'s majestic desert scenery.',
    'historicalBackground': 'Timimoun has a rich history rooted in Saharan trade routes, serving as a key stop for caravans. Its unique architectural style, known as Sudanese-Sahelian, reflects centuries of cultural blending and adaptation to the harsh desert environment.',
    'mapUrl': 'https://maps.app.goo.gl/t7DR7sPRwmY5u8K47',
    'category': 'Desert',
    'categoryIcon': 'assets/Images/Icons/desert.png',
    'isFavorite': 0
  },

    ];

    for (var place in places) {
      await db.insert('places', place);
    }
  }
  
  Future<void> _insertWilayas(Database db) async {
    final wilayas = [
      "Adrar", "Chlef", "Laghouat", "OumElBouaghi", "Batna", "Bejaïa", "Biskra",
      "Bechar", "Blida", "Bouira", "Tamanrasset", "Tebessa", "Tlemcen", "Tiaret",
      "Tizi Ouzou", "Algiers", "Djelfa", "Jijel", "Setif", "Saïda", "Skikda",
      "SidiBelAbbes", "Annaba", "Guelma", "Constantine", "Medea", "Mostaganem",
      "M'Sila", "Mascara", "Ouargla", "Oran", "El Bayadh", "Illizi", "BBA",
      "Boumerdes", "El Tarf", "Tindouf", "Tissemsilt", "El Oued", "Khenchela",
      "Souk Ahras", "Tipaza", "Mila", "Aïn Defla", "Naâma", "AïnTemouchent",
      "Ghardaïa", "Relizane", "Timimoun", "BBM", "OuledDjellal", "BeniAbbes",
      "InSalah", "InGuezzam", "Touggourt", "Djanet", "El M'Ghair", "El Meniaa"
    ];

    for (String wilaya in wilayas) {
      await db.insert('wilayas', {'name': wilaya});
    }
  }

  Future<void> _insertGuidesAndAssociations(Database db) async {
    final guides = [
      {
        'name': 'Rasha Hamidi',
        'email': 'rashaham39@gmail.com',
        'phone': '+213669082129',
        'imageUrl': 'assets/Images/Guides/rasha-hamidi.jpg',
        'wilayas': [19, 5] // Setif and Batna
      },
      {
        'name': 'Rehad Benz',
        'email': 'algerianmaze@gmail.com',
        'phone': '+213782666991',
        'imageUrl': 'assets/Images/Guides/nehad-benz.jpg',
        'wilayas': [16, 31] // Algiers and Oran
      },
      {
        'name': 'Adel Moncef',
        'email': 'adel.moncef@yahoo.fr',
        'phone': '+213561684215',
        'imageUrl': 'assets/Images/Guides/adel-moncef.jpg',
        'wilayas': [25, 23] // Constantine and Annaba
      },
      {
        'name': 'Mama Taibi',
        'email': 'karry34000@gmail.com',
        'phone': '+213656078849',
        'imageUrl': 'assets/Images/Guides/mama-taibi.jpg',
        'wilayas': [7, 30] // Biskra and Ouargla
      },
      {
        'name': 'Redouane Fellah',
        'email': 'redouanefellah31@gmail.com',
        'phone': '+213794223570',
        'imageUrl': 'assets/Images/Guides/redouane-fellah.jpg',
        'wilayas': [13, 22] // Tlemcen and SidiBelAbbes
      },
      {
        'name': 'Moussa Ayoub',
        'email': 'moussadesert@gmail.com',
        'phone': '+213662082246',
        'imageUrl': 'assets/Images/Guides/moussa-ayoub.jpg',
        'wilayas': [1, 11, 33] // Adrar, Tamanrasset, and Illizi
      },
      {
        'name': 'Mustapha Tahri',
        'email': 'mustaphatahri88@gmail.com',
        'phone': '+213541365090',
        'imageUrl': 'assets/Images/Guides/mustapha-tahri.jpg',
        'wilayas': [6, 15] // Bejaïa and Tizi Ouzou
      }
    ];

    for (var guide in guides) {
      final wilayaIds = List<int>.from(guide['wilayas'] as List);
      guide.remove('wilayas');
      
      final guideId = await db.insert('guides', guide);
      
      for (var wilayaId in wilayaIds) {
        await db.insert('guide_wilayas', {
          'guideId': guideId,
          'wilayaId': wilayaId,
        });
      }
    }
  }

}