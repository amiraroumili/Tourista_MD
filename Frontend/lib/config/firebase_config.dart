// lib/config/firebase_config.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseConfig {
  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        projectId: 'tourista-backend',
        authDomain: 'tourista-backend.firebaseapp.com',
        apiKey: 'AIzaSyDEHX8BNFg9H3kTVZEOY-tQwl9S6QiO_Qk',
        storageBucket: 'tourista-backend.appspot.com',
        messagingSenderId: '107972881592', // Should be ~12 digits
        appId: '1:107972881592:web:xxxxxxxxxxxx' // Need the complete app ID
      ),
    );
  }
  
  static FirebaseFirestore get firestore => FirebaseFirestore.instance;
}