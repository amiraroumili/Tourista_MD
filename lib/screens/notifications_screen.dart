<<<<<<< HEAD
import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final List<Map<String, String>> notifications = [
    {
      "title": "\"Annaba's Best\" Tour by Fancyellow",
      "location": "Annaba",
      "date": "11/11/2024",
      "time": "09:32 AM"
    },
    {
      "title": "7 Days 6 Nights Private Trip in 5 Cities",
      "location": "Constantine",
      "date": "11/11/2024",
      "time": "09:32 AM"
    },
    {
      "title": "Visit to Ghardaïa 2 days",
      "location": "Batna",
      "date": "11/11/2024",
      "time": "09:32 AM"
    },
    {
      "title": "Djemila Roman Ruins in a Private Day",
      "location": "Setif",
      "date": "11/11/2024",
      "time": "09:32 AM"
    },
  ];

  List<Color> notificationColors = [
    const Color.fromARGB(255, 249, 244, 243),
    const Color.fromARGB(255, 249, 244, 243),
    const Color.fromARGB(255, 249, 244, 243),
    const Color.fromARGB(255, 249, 244, 243),
  ];

  void removeNotification(int index) {
    setState(() {
      notifications.removeAt(index);
      notificationColors.removeAt(index);
    });
  }

  void changeColor(int index) {
    setState(() {
      notificationColors[index] = Colors.white;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(1.0),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return GestureDetector(
            onTap: () {
              changeColor(index);
            },
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 0.0),
              color: notificationColors[index],
              shape: RoundedRectangleBorder(),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 14.0),
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFF800020),
                  child: Icon(Icons.notifications, color: Colors.white),
                ),
                title: Text(
                  notification["title"]!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(Icons.place,
                            size: 16, color: Color(0xFFD79384)),
                        const SizedBox(width: 5),
                        Text(
                          notification["location"]!,
                          style: const TextStyle(color: Color(0xFFD79384)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${notification["date"]}   ${notification["time"]}',
                      style: const TextStyle(color: Color(0xFFD79384)),
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.close, color: Color(0xFF6D071A)),
                  onPressed: () {
                    removeNotification(index);
                  },
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 3),
    );
  }
}
=======
import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final List<Map<String, String>> notifications = [
    {
      "title": "\"Annaba's Best\" Tour by Fancyellow",
      "location": "Annaba",
      "date": "11/11/2024",
      "time": "09:32 AM"
    },
    {
      "title": "7 Days 6 Nights Private Trip in 5 Cities",
      "location": "Constantine",
      "date": "11/11/2024",
      "time": "09:32 AM"
    },
    {
      "title": "Visit to Ghardaïa 2 days",
      "location": "Batna",
      "date": "11/11/2024",
      "time": "09:32 AM"
    },
    {
      "title": "Djemila Roman Ruins in a Private Day",
      "location": "Setif",
      "date": "11/11/2024",
      "time": "09:32 AM"
    },
  ];

  List<Color> notificationColors = [
    const Color.fromARGB(255, 249, 244, 243),
    const Color.fromARGB(255, 249, 244, 243),
    const Color.fromARGB(255, 249, 244, 243),
    const Color.fromARGB(255, 249, 244, 243),
  ];

  void removeNotification(int index) {
    setState(() {
      notifications.removeAt(index);
      notificationColors.removeAt(index);
    });
  }

  void changeColor(int index) {
    setState(() {
      notificationColors[index] = Colors.white;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: const Icon(Icons.arrow_back),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(1.0),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return GestureDetector(
            onTap: () {
              changeColor(index);
            },
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 0.0),
              color: notificationColors[index],
              shape: RoundedRectangleBorder(),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 14.0),
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFF800020),
                  child: Icon(Icons.notifications, color: Colors.white),
                ),
                title: Text(
                  notification["title"]!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(Icons.place,
                            size: 16, color: Color(0xFFD79384)),
                        const SizedBox(width: 5),
                        Text(
                          notification["location"]!,
                          style: const TextStyle(color: Color(0xFFD79384)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${notification["date"]}   ${notification["time"]}',
                      style: const TextStyle(color: Color(0xFFD79384)),
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.close, color: Color(0xFF6D071A)),
                  onPressed: () {
                    removeNotification(index);
                  },
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 3),
    );
  }
}
>>>>>>> 35e152e28003971e528d21ed6e735a51febb0204
