import 'package:flutter/material.dart';
import '../screens/Edit_profile_page.dart';
import '../api/user_api.dart';

class ProfilePage extends StatefulWidget {
  final String userEmail;

  const ProfilePage({
    Key? key,
    required this.userEmail,
  }) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<Map<String, dynamic>?> _userDataFuture;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _fetchUserData() {
    setState(() {
      _userDataFuture = UserApi.getUser(widget.userEmail);
    });
  }

  Future<void> _navigateToEditProfile(Map<String, dynamic> userData) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilePage(
          userEmail: widget.userEmail,
          userData: userData,
        ),
      ),
    );
    if (result != null) {
      _fetchUserData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF6D071A)));
          }

          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Text(
                'User not found',
                style: TextStyle(
                  color: Color(0xFF6D071A),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          final userData = snapshot.data!;
          final String userName = '${userData['firstName']} ${userData['familyName']}';
          final String userLocation = userData['wilaya'];

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 250,
                floating: false,
                pinned: true,
                backgroundColor: Color(0xFF6D071A),
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(
                    userName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      userData['profileImage'] != null && userData['profileImage'].isNotEmpty
                          ? Image.network(
                              userData['profileImage'].startsWith('http') 
                                ? userData['profileImage'] 
                                : 'http://192.168.216.10:8081${userData['profileImage']}',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[200],
                                  child: Icon(
                                    Icons.person,
                                    size: 100,
                                    color: Colors.grey[400],
                                  ),
                                );
                              },
                            )
                          : Container(
                              color: Colors.grey[200],
                              child: Icon(
                                Icons.person,
                                size: 100,
                                color: Colors.grey[400],
                              ),
                            ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoCard(
                          icon: Icons.person,
                          title: 'First Name',
                          subtitle: userData['firstName'],
                        ),
                        SizedBox(height: 16),
                        _buildInfoCard(
                          icon: Icons.family_restroom,
                          title: 'Family Name',
                          subtitle: userData['familyName'],
                        ),
                        SizedBox(height: 16),
                        _buildInfoCard(
                          icon: Icons.location_on,
                          title: 'Location',
                          subtitle: userLocation,
                        ),
                        SizedBox(height: 16),
                        _buildInfoCard(
                          icon: Icons.email,
                          title: 'Email',
                          subtitle: widget.userEmail,
                        ),
                        SizedBox(height: 24),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF6D071A),
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          onPressed: () => _navigateToEditProfile(userData),
                          child: Text(
                            'Edit Profile',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Color(0xFF6D071A),
            size: 30,
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}