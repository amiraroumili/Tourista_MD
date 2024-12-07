<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'GuidesInfoPage.dart';
import '/data/wilayas.dart'; 

class WilayaListPage extends StatefulWidget {
  const WilayaListPage({super.key});

  @override
  _WilayaListPageState createState() => _WilayaListPageState();
}

class _WilayaListPageState extends State<WilayaListPage> {
  late List<int> _filteredIndices;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredIndices = List.generate(wilayas.length - 1, (index) => index + 1);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Wilaya',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: _buildWilayaList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          _filterWilayas(value);
        },
        decoration: InputDecoration(
          hintText: 'Search by name or index',
          hintStyle: const TextStyle(color: Color.fromARGB(255, 183, 182, 178)),
          prefixIcon: const Padding(
            padding: EdgeInsets.only(left: 10),
            child: Icon(
              Icons.search,
              color: const Color(0xFF6D071A),
              size: 27,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(color:  const Color(0xFF6D071A), width: 1.75),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(color: const Color(0xFF6D071A), width: 1.75),
          ),
        ),
      ),
    );
  }

  Widget _buildWilayaList() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      itemCount: _filteredIndices.length,
      itemBuilder: (context, index) {
        return _buildWilayaItem(_filteredIndices[index]);
      },
    );
  }

  Widget _buildWilayaItem(int originalIndex) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFF6D071A),
            width: 1.25,
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: [
            _buildWilayaNumberContainer(originalIndex),
            Expanded(
              child: Material(
                borderRadius: BorderRadius.circular(25),
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(25),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GuidesInfoPage(),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Text(
                      wilayas[originalIndex],
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWilayaNumberContainer(int originalIndex) {
    return Container(
      width: 70,
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFF6D071A),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Center(
        child: Text(
          '${originalIndex}', 
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _filterWilayas(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredIndices = List.generate(wilayas.length - 1, (index) => index + 1); 
      } else if (int.tryParse(query) != null) {
        int index = int.parse(query);
        _filteredIndices = (index > 0 && index < wilayas.length) ? [index] : [];
      } else {
        _filteredIndices = wilayas
            .asMap()
            .entries
            .where((entry) => entry.key > 0 && entry.value.toLowerCase().contains(query.toLowerCase())) 
            .map((entry) => entry.key)
            .toList();
      }
    });
  }
}
=======
import 'package:flutter/material.dart';
import 'GuidesInfoPage.dart';
import '/data/wilayas.dart'; 
class WilayaListPage extends StatefulWidget {
  const WilayaListPage({super.key});

  @override
  _WilayaListPageState createState() => _WilayaListPageState();
}

class _WilayaListPageState extends State<WilayaListPage> {
  late List<int> _filteredIndices;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredIndices = List.generate(wilayas.length, (index) => index); 
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Wilaya',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: _buildWilayaList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          _filterWilayas(value);
        },
        decoration: InputDecoration(
          hintText: 'Search by name or index',
          hintStyle: const TextStyle(color: Color(0xFFD79384)),
          prefixIcon: const Padding(
            padding: EdgeInsets.only(left: 10),
            child: Icon(
              Icons.search,
              color: Color(0xFFD79384),
              size: 25,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
                       borderSide: const BorderSide(color:  Color(0xFFD79384), width: 1.75),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),

             borderSide: const BorderSide(color: Color(0xFFD79384), width: 1.75),
          ),
        ),
      ),
    );
  }

  Widget _buildWilayaList() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      itemCount: _filteredIndices.length,
      itemBuilder: (context, index) {
        return _buildWilayaItem(_filteredIndices[index]);
      },
    );
  }

  Widget _buildWilayaItem(int originalIndex) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFFD79384),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: [
            _buildWilayaNumberContainer(originalIndex),
            Expanded(
              child: Material(
                borderRadius: BorderRadius.circular(25),
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(25),
                 onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => GuidesInfoPage(),
    ),
  );
},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Text(
                      wilayas[originalIndex],
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWilayaNumberContainer(int originalIndex) {
    return Container(
      width: 70,
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFF800000),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Center(
        child: Text(
          '${originalIndex + 1}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _filterWilayas(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredIndices = List.generate(wilayas.length, (index) => index);
      } else if (int.tryParse(query) != null) {
        int index = int.parse(query) - 1;
        _filteredIndices = (index >= 0 && index < wilayas.length) ? [index] : [];
      } else {
        _filteredIndices = wilayas
            .asMap()
            .entries
            .where((entry) => entry.value.toLowerCase().contains(query.toLowerCase()))
            .map((entry) => entry.key)
            .toList();
      }
    });
  }
}
>>>>>>> 35e152e28003971e528d21ed6e735a51febb0204
