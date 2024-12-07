<<<<<<< HEAD
import 'package:flutter/material.dart';

class GuideInfo {
  final String name;
  final String email;
  final String phone;
  final String imageUrl;

  GuideInfo({
    required this.name,
    required this.email,
    required this.phone,
    required this.imageUrl,
  });
}

class GuidesInfoPage extends StatelessWidget {
  GuidesInfoPage({super.key});

  final List<GuideInfo> guides = [
    GuideInfo(
      name: 'Rasha Hamidi',
      email: 'rashaham39@gmail.com',
      phone: '+213669082129',
      imageUrl: 'assets/Images/Guides/rasha-hamidi.jpg',
    ),
      GuideInfo(
      name: 'Rehad Benz',
      email: 'algerianmaze@gmail.com',
      phone: '+213782666991',
      imageUrl:'assets/Images/Guides/nehad-benz.jpg',
    ),
      GuideInfo(
      name: 'Adel Moncef',
      email: 'adel.moncef@yahoo.fr',
      phone: '+213561684215',
      imageUrl: 'assets/Images/Guides/adel-moncef.jpg',
    ),
      GuideInfo(
      name: 'Mama Taibi',
      email: 'karry34000@gmail.com',
      phone: '+213656078849',
      imageUrl: 'assets/Images/Guides/mama-taibi.jpg',
    ),
      GuideInfo(
      name: 'Redouane Fellah',
      email: 'redouanefellah31@gmail.com',
      phone: '+213794223570',
      imageUrl: 'assets/Images/Guides/redouane-fellah.jpg',
    ), 
    GuideInfo(
      name: 'Moussa Ayoub',
      email: 'moussadesert@gmail.com',
      phone: '+213662082246',
      imageUrl: 'assets/Images/Guides/moussa-ayoub.jpg',
    ), 
      GuideInfo(
      name: 'Mustapha Tahri',
      email: 'mustaphatahri88@gmail.com',
      phone: '+213541365090',
      imageUrl: 'assets/Images/Guides/mustapha-tahri.jpg',
    ), 
     
   
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        backgroundColor:Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Guides Information',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
       
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white, 
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: guides.length,
          itemBuilder: (context, index) {
            final guide = guides[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color.fromARGB(46, 215, 147, 132),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        width: 2,
                      ),
                    ),
                    child: ClipOval(
                      child: guide.imageUrl.startsWith('http')
                          ? Image.network(guide.imageUrl, fit: BoxFit.cover)
                          : Image.asset(guide.imageUrl, fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          guide.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.email,
                              size: 16,
                              color: Color(0xFF6D071A),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              guide.email,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.phone,
                              size: 16,
                              color: Color(0xFF6D071A),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              guide.phone,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
=======
import 'package:flutter/material.dart';

class GuideInfo {
  final String name;
  final String email;
  final String phone;
  final String imageUrl;

  GuideInfo({
    required this.name,
    required this.email,
    required this.phone,
    required this.imageUrl,
  });
}

class GuidesInfoPage extends StatelessWidget {
  GuidesInfoPage({super.key});

  final List<GuideInfo> guides = [
    GuideInfo(
      name: 'Rasha Hamidi',
      email: 'rashaham39@gmail.com',
      phone: '+213669082129',
      imageUrl: 'assets/Images/Guides/rasha-hamidi.jpg',
    ),
      GuideInfo(
      name: 'Rehad Benz',
      email: 'algerianmaze@gmail.com',
      phone: '+213782666991',
      imageUrl:'assets/Images/Guides/nehad-benz.jpg',
    ),
      GuideInfo(
      name: 'Adel Moncef',
      email: 'adel.moncef@yahoo.fr',
      phone: '+213561684215',
      imageUrl: 'assets/Images/Guides/adel-moncef.jpg',
    ),
      GuideInfo(
      name: 'Mama Taibi',
      email: 'karry34000@gmail.com',
      phone: '+213656078849',
      imageUrl: 'assets/Images/Guides/mama-taibi.jpg',
    ),
      GuideInfo(
      name: 'Redouane Fellah',
      email: 'redouanefellah31@gmail.com',
      phone: '+213794223570',
      imageUrl: 'assets/Images/Guides/redouane-fellah.jpg',
    ), 
    GuideInfo(
      name: 'Moussa Ayoub',
      email: 'moussadesert@gmail.com',
      phone: '+213662082246',
      imageUrl: 'assets/Images/Guides/moussa-ayoub.jpg',
    ), 
      GuideInfo(
      name: 'Mustapha Tahri',
      email: 'mustaphatahri88@gmail.com',
      phone: '+213541365090',
      imageUrl: 'assets/Images/Guides/mustapha-tahri.jpg',
    ), 
     
   
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        backgroundColor:Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Guides Information',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
       
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white, 
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: guides.length,
          itemBuilder: (context, index) {
            final guide = guides[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color.fromARGB(46, 215, 147, 132),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        width: 2,
                      ),
                    ),
                    child: ClipOval(
                      child: guide.imageUrl.startsWith('http')
                          ? Image.network(guide.imageUrl, fit: BoxFit.cover)
                          : Image.asset(guide.imageUrl, fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          guide.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.email,
                              size: 16,
                              color: Color(0xFF800000),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              guide.email,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.phone,
                              size: 16,
                              color: Color(0xFF800000),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              guide.phone,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
>>>>>>> 35e152e28003971e528d21ed6e735a51febb0204
