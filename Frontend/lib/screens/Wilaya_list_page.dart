// wilaya_list_page.dart
import 'package:flutter/material.dart';
import '../database/database.dart';

class WilayaListPage extends StatefulWidget {
  const WilayaListPage({super.key});

  @override
  _WilayaListPageState createState() => _WilayaListPageState();
}

class _WilayaListPageState extends State<WilayaListPage> {
  final DatabaseService _databaseService = DatabaseService();
  List<Map<String, dynamic>> _wilayas = [];
  List<Map<String, dynamic>> _filteredWilayas = [];
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadWilayas();
  }

  Future<void> _loadWilayas() async {
    final wilayas = await _databaseService.getAllWilayas();
    setState(() {
      _wilayas = wilayas;
      _filteredWilayas = wilayas;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterWilayas(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredWilayas = _wilayas;
      } else {
        _filteredWilayas = _wilayas.where((wilaya) {
          final id = wilaya['id'].toString();
          final name = wilaya['name'].toString().toLowerCase();
          final searchLower = query.toLowerCase();
          return id == query || name.contains(searchLower);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
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
        onChanged: _filterWilayas,
        decoration: InputDecoration(
          hintText: 'Search by name or index',
          hintStyle: const TextStyle(color: Color.fromARGB(255, 183, 182, 178)),
          prefixIcon: const Padding(
            padding: EdgeInsets.only(left: 10),
            child: Icon(Icons.search, color: Color(0xFF6D071A), size: 27),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(color: Color(0xFF6D071A), width: 1.75),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(color: Color(0xFF6D071A), width: 1.75),
          ),
        ),
      ),
    );
  }

  Widget _buildWilayaList() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      itemCount: _filteredWilayas.length,
      itemBuilder: (context, index) {
        final wilaya = _filteredWilayas[index];
        return _buildWilayaItem(wilaya);
      },
    );
  }

  Widget _buildWilayaItem(Map<String, dynamic> wilaya) {
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
            _buildWilayaNumberContainer(wilaya['id']),
            Expanded(
              child: Material(
                borderRadius: BorderRadius.circular(25),
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(25),
                  onTap: () async {
                    final guides = await _databaseService.getGuidesByWilaya(wilaya['id']);
                    if (!context.mounted) return;
                    Navigator.pushNamed(
                      context,
                      '/guides',
                      arguments: {
                        'guides': guides,
                        'wilayaName': wilaya['name'],
                      },
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Text(
                      wilaya['name'],
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

  Widget _buildWilayaNumberContainer(int id) {
    return Container(
      width: 70,
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFF6D071A),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Center(
        child: Text(
          '$id',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}