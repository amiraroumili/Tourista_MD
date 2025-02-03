import 'package:flutter/material.dart';
import '../database/database.dart';

class SearchBar extends StatefulWidget {
  final Function(String) onWilayaSelected;

  const SearchBar({super.key, required this.onWilayaSelected});

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final DatabaseService _databaseService = DatabaseService();
  String selectedWilaya = 'Wilaya';
  List<String> wilayas = [];

  @override
  void initState() {
    super.initState();
    _loadWilayas();
  }

  Future<void> _loadWilayas() async {
    final wilayasData = await _databaseService.getAllWilayas();
    setState(() {
      wilayas = wilayasData.map((wilaya) => wilaya['name'] as String).toList();
    });
  }

  List<String> getWilayasWithNumbers() {
    List<String> wilayasWithNumbers = ['Wilaya'];
    for (int i = 0; i < wilayas.length; i++) {
      wilayasWithNumbers.add('${i + 1}. ${wilayas[i]}');
    }
    return wilayasWithNumbers;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.0),
          border: Border.all(color: const Color(0xFF6D071A)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 12.0),
              child: Icon(Icons.search, color: Color(0xFF6D071A)),
            ),
            const Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search for places...',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                ),
              ),
            ),
            Container(
              width: 167,
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 10.8),
              decoration: BoxDecoration(
                color: const Color(0xFF6D071A),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  dropdownColor: const Color(0xFF6D071A),
                  icon: const Icon(Icons.arrow_drop_down, color: Color(0xFFFFFFFF)),
                  style: const TextStyle(color: Color(0xFFFFFFFF)),
                  value: selectedWilaya,
                  items: getWilayasWithNumbers().map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedWilaya = value!;
                      widget.onWilayaSelected(selectedWilaya);
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}