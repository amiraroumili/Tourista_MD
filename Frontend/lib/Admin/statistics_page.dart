import 'package:flutter/material.dart';
import '../api/statistic_api.dart';

class StatisticsScreen extends StatefulWidget {
  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final StatisticsService _statisticsService = StatisticsService();
  bool _isLoading = true;
  int _userCount = 0;
  int _placeCount = 0;
  int _eventCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchStatistics();
  }

  Future<void> _fetchStatistics() async {
    try {
      int userCount = await _statisticsService.fetchUserCount();
      int placeCount = await _statisticsService.fetchPlaceCount();
      int eventCount = await _statisticsService.fetchEventCount();

      setState(() {
        _userCount = userCount;
        _placeCount = placeCount;
        _eventCount = eventCount;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching statistics: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF6D071A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Statistics',
          style: TextStyle(
            color: Color(0xFF6D071A),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            'Total Statistics',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text('Total Users: $_userCount'),
                          Text('Total Places: $_placeCount'),
                          Text('Total Events: $_eventCount'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}