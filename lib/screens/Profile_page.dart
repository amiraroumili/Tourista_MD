<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'Edit_profile_page.dart';


class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back, 
            color: Color.fromARGB(255, 0, 0, 0),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(' Profile Page', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
       
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
        
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Column(
                children: [
                  
                  Container(
                    height: 200,
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
               
                  Container(
                    height: 80,
                    color: Colors.white,
                  ),
                ],
              ),
           
              Positioned(
                bottom: 30,
                child: Column(
                  children: [
               
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Color(0xFF6D071A), 
                          width: 3,
                        ),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/Images/Profile/Profile.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    
                 
                    const Text(
                      'Roumili Amira',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                   
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on, 
                          size: 19, 
                          color: Color(0xFFD79384),
                        ),
                        Text(
                          'Setif',
                          style: TextStyle(color: Colors.grey),
                        ),



                      ],

                    ),
                  Row(
                    children: [
                      Icon(
                              Icons.email, 
                              size: 19, 
                              color: Color(0xFFD79384),
                            ),
                            Text(
                              'amira.roumili@ensia.edu.dz',
                              style: TextStyle(color: Colors.grey),
                            ),
                    ],
                  ),  
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6D071A),
              minimumSize: const Size(220, 46),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditProfilePage(),
                ),
              );
            },
            child: const Text(
              'Edit Profile',
              style: TextStyle(color: Colors.white),
            ),
          ),
          
          const Spacer(),
        ],
      ),
    );
  }
}
=======
import 'package:flutter/material.dart';
import 'Edit_profile_page.dart';
import '../widgets/bottom_nav_bar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF800000),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back, 
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
        
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Column(
                children: [
                  
                  Container(
                    height: 150,
                    color: const Color(0xFF800000),
                  ),
               
                  Container(
                    height: 80,
                    color: Colors.white,
                  ),
                ],
              ),
           
              Positioned(
                bottom: 30,
                child: Column(
                  children: [
               
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white, 
                          width: 3,
                        ),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/Images/Profile/Profile.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    
                 
                    const Text(
                      'Rahil Ghanem',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                   
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on, 
                          size: 19, 
                          color: Color(0xFFD79384),
                        ),
                        Text(
                          'Batna, Algeria',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF800000),
              minimumSize: const Size(220, 46),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditProfilePage(),
                ),
              );
            },
            child: const Text(
              'Edit Profile',
              style: TextStyle(color: Colors.white),
            ),
          ),
          
          const Spacer(),
        ],
      ),
    );
  }
}
>>>>>>> 35e152e28003971e528d21ed6e735a51febb0204
