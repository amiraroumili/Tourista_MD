import 'package:flutter/material.dart';

class GuidesInfoPage extends StatelessWidget {
  final List<Map<String, dynamic>> guides;
  final String wilayaName;

  const GuidesInfoPage({
    super.key,
    required this.guides,
    required this.wilayaName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Guides in $wilayaName',
          style: const TextStyle(
            color: Colors.black, 
            fontWeight: FontWeight.bold, 
            fontSize: 20
          ),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: guides.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.person_off,
                    size: 64,
                    color: Color(0xFF6D071A),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No guides available in $wilayaName',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6D071A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Please check other wilayas',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : Container(
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
                            child: guide['imageUrl'].startsWith('http')
                                ? Image.network(guide['imageUrl'], fit: BoxFit.cover)
                                : Image.asset(guide['imageUrl'], fit: BoxFit.cover),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                guide['name'],
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
                                    guide['email'],
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
                                    guide['phone'],
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
