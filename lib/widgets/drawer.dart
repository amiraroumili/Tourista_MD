import 'package:flutter/material.dart';
import '../database/database.dart';

class CustomDrawer extends StatelessWidget {
  final String userEmail;
  final DatabaseService databaseService;

  const CustomDrawer({
    super.key,
    required this.userEmail,
    required this.databaseService,
  });

  Future<Map<String, dynamic>?> _fetchUserData() async {
    return await databaseService.getUser(userEmail);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFFFFFFF),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          FutureBuilder<Map<String, dynamic>?>( 
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
              final String profileImagePath = userData['profileImage'] ?? 'assets/Images/Profile/profile.png';
              final String userName = '${userData['firstName']} ${userData['familyName']}';
              final String userEmail = userData['email'];

              return Container(
                padding: const EdgeInsets.all(0),
                height: 180,
                decoration: const BoxDecoration(
                  color: Color(0xFFF9E8E8),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage(profileImagePath),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6D071A),
                            ),
                          ),
                          Text(
                            userEmail,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF6D071A),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          _buildMenuItem('Profile', Icons.person, context),
          _buildDivider(),
          _buildMenuItem('Events', Icons.event, context),
          _buildDivider(),
          _buildMenuItem('Favourite Places', Icons.favorite, context),
          _buildDivider(),
          _buildMenuItem('Guides Information', Icons.info, context),
          _buildDivider(),
          _buildMenuItem('Contact-us', Icons.contact_mail, context),
          _buildDivider(),
          _buildMenuItem('Suggestions & Feedback', Icons.feedback, context),
          _buildDivider(),
          ListTile(
            onTap: () async {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6D071A)),
                    ),
                  );
                },
              );
              await Future.delayed(const Duration(seconds: 2));
              Navigator.pop(context); // Close the dialog
              Navigator.popAndPushNamed(context, '/first');
            },
            leading: const Icon(
              Icons.exit_to_app,
              color: Color(0xFF6D071A),
            ),
            title: const Text(
              'Log out',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF6D071A),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildDivider(),
        ],
      ),
    );
  }
  
  Widget _buildMenuItem(String title, IconData icon, BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: Icon(icon, color: const Color(0xFF6D071A)),
      onTap: () {
        switch (title) {
          case 'Profile':
            Navigator.pushNamed(
              context,
              '/profile',
              arguments: {
                'userEmail': userEmail,
                'databaseService': databaseService,
              },
            );
            break;
          case 'Events':
            Navigator.pushNamed(context, '/ev&opp');
            break;
          case 'Favourite Places':
            Navigator.pushNamed(context, '/favorite');
            break;
          case 'Guides Information':
            Navigator.pushNamed(context, '/wilayas');
            break;
          case 'Contact-us':
            Navigator.pushNamed(context, '/contact');
            break;
          case 'Suggestions & Feedback':
            Navigator.pushNamed(context, '/feedback');
            break;
          default:
            break;
        }
      },
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      child: Divider(
        color: Color.fromARGB(154, 241, 209, 209),
        thickness: 1,
      ),
    );
  }
}