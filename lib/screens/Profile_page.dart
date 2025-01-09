import 'package:flutter/material.dart';
import '../database/database.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatelessWidget {
  final String userEmail;
  final DatabaseService databaseService;

  const ProfilePage({
    Key? key,
    required this.userEmail,
    required this.databaseService,
  }) : super(key: key);

  Future<Map<String, dynamic>?> _fetchUserData() async {
    return await databaseService.getUser(userEmail);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Profile Page',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Text('User not found'),
            );
          }

          final userData = snapshot.data!;
          final String profileImagePath =
              userData['profileImage'] ?? 'assets/Images/Profile/profile.png';
          final String userName =
              '${userData['firstName']} ${userData['familyName']}';
          final String userLocation = userData['wilaya'];

          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Profile Image
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF6D071A),
                      width: 3,
                    ),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      profileImagePath,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // User Name
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // Location
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Color(0xFFD79384),
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      userLocation,
                      style: const TextStyle(
                        color: Color(0xFFD79384),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Email
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.email,
                      color: Color(0xFFD79384),
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      userEmail,
                      style: const TextStyle(
                        color: Color(0xFFD79384),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                // Edit Profile Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6D071A),
                      minimumSize: const Size(double.infinity, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfilePage(
                            userEmail: userEmail,
                            databaseService: databaseService,
                            userData: userData,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'Edit Profile',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
