//api/user_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserApi {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
static const String baseUrl = 'http://192.168.216.10:8081/api/v1/users';

  static Future<Map<String, dynamic>> getUser(String email) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return {
          'id': querySnapshot.docs.first.id,
          ...querySnapshot.docs.first.data(),
        };
      } else {
        throw Exception('User not found');
      }
    } catch (e) {
      throw Exception('Failed to load user: $e');
    }
  }

  // Get all users
static Future<List<Map<String, dynamic>>> getAllUsers() async {
    try {
      final querySnapshot = await _firestore.collection('users').get();
      return querySnapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data()})
          .toList();
    } catch (e) {
      throw Exception('Failed to load users: $e');
    }
  }
  // Register new user
static Future<Map<String, dynamic>> registerUser(Map<String, dynamic> userData) async {
  try {
    // Create auth user
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: userData['email'],
      password: userData['password'],
    );

    // Remove password before storing in Firestore
    userData.remove('password');
    
    // Add timestamp and additional fields
    final userDataToStore = {
      ...userData,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    final userDoc = _firestore.collection('users').doc(userCredential.user!.uid);
    await userDoc.set(userDataToStore);

    return {
      'id': userCredential.user!.uid,
      ...userDataToStore,
    };
  } catch (e) {
    throw Exception('Failed to register user: $e');
  }
}

  // Login user
 static Future<Map<String, dynamic>> loginUser(String email, String password) async {
  try {
    final userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final userDoc = await _firestore
        .collection('users')
        .doc(userCredential.user!.uid)
        .get();

    // Add null check here
    if (!userDoc.exists || userDoc.data() == null) {
      throw Exception('User data not found');
    }

    return {
      'id': userCredential.user!.uid,
      ...userDoc.data()!,
    };
  } catch (e) {
    throw Exception('Failed to login: $e');
  }
}

  // Update user profile
static Future<Map<String, dynamic>> updateUser(Map<String, dynamic> userData) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No authenticated user');

      await _firestore
          .collection('users')
          .doc(user.uid)
          .update(userData);

      final updatedDoc = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();

      return {
        'id': user.uid,
        ...updatedDoc.data()!,
      };
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  // Update user password
   static Future<void> updatePassword(String email, String oldPassword, String newPassword) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No authenticated user');

      // Reauthenticate user
      final credential = EmailAuthProvider.credential(
        email: email,
        password: oldPassword,
      );
      await user.reauthenticateWithCredential(credential);
      
      // Update password
      await user.updatePassword(newPassword);
    } catch (e) {
      throw Exception('Failed to update password: $e');
    }
  }

static Future<String> uploadProfileImage(String email, File imageFile) async {
  try {
    print('Starting image upload for email: $email');
    final bytes = await imageFile.readAsBytes();
    final base64Image = base64Encode(bytes);
    
    print('Image converted to base64. Size: ${bytes.length} bytes');

    final response = await http.post(
      Uri.parse('$baseUrl/profile-image'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'image': base64Image,
      }),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['imageUrl'];
    } else {
      throw Exception('Server error: ${response.statusCode}\n${response.body}');
    }
  } catch (e) {
    print('Upload error: $e');
    throw Exception('Failed to upload image: $e');
  }
}
}