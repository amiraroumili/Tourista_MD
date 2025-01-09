import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourista/screens/Eventinformation.dart';
import '../widgets/bottom_nav_bar.dart';
import '../database/database.dart';
import 'event_info_new.dart';
import 'event_bloc/events_bloc.dart';
import 'event_event/events_event.dart';
import 'event_state/events_state.dart';

class EventsAndOpportunitiesScreen extends StatefulWidget {
  const EventsAndOpportunitiesScreen({super.key});

  @override
  EventsAndOpportunitiesScreenState createState() =>
      EventsAndOpportunitiesScreenState();
}

class EventsAndOpportunitiesScreenState
    extends State<EventsAndOpportunitiesScreen> {
  late EventsBloc _eventsBloc;

  String selectedYear = 'Y';
  String selectedMonth = 'M';
  String selectedDay = 'D';

  @override
  void initState() {
    super.initState();
    _eventsBloc = EventsBloc(dbService: DatabaseService());
    _eventsBloc.add(LoadEvents());
  }

  @override
  void dispose() {
    _eventsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events & Opportunities'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25.0),
                        border: Border.all(color: const Color(0xFF6D071A)),
                      ),
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedYear,
                            dropdownColor: Colors.white,
                            icon: const Icon(Icons.arrow_drop_down,
                                color: Color(0xFF6D071A)),
                            style: const TextStyle(color: Color(0xFF6D071A)),
                            items: ['Y', '2021', '2022', '2023', '2024', '2025']
                                .map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedYear = value!;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25.0),
                        border: Border.all(color: const Color(0xFF6D071A)),
                      ),
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedMonth,
                            dropdownColor: Colors.white,
                            icon: const Icon(Icons.arrow_drop_down,
                                color: Color(0xFF6D071A)),
                            style: const TextStyle(color: Color(0xFF6D071A)),
                            items: [
                              'M',
                              '01',
                              '02',
                              '03',
                              '04',
                              '05',
                              '06',
                              '07',
                              '08',
                              '09',
                              '10',
                              '11',
                              '12'
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedMonth = value!;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25.0),
                        border: Border.all(color: const Color(0xFF6D071A)),
                      ),
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedDay,
                            dropdownColor: Colors.white,
                            icon: const Icon(Icons.arrow_drop_down,
                                color: Color(0xFF6D071A)),
                            style: const TextStyle(color: Color(0xFF6D071A)),
                            items: [
                              'D',
                              ...List.generate(
                                  31,
                                  (index) =>
                                      (index + 1).toString().padLeft(2, '0'))
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedDay = value!;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6D071A),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      _eventsBloc.add(FilterEvents(
                          year: selectedYear,
                          month: selectedMonth,
                          day: selectedDay));
                    },
                    child: const Text('Search'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<EventsBloc, EventsState>(
                bloc: _eventsBloc,
                builder: (context, state) {
                  if (state is EventsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is EventsLoaded) {
                    print('Loaded events: ${state.events}'); // Debugging: Print loaded events
                    return ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: state.events.length,
                      itemBuilder: (context, index) {
                        final event = state.events[index];
                        return _eventCard(context, event);
                      },
                    );
                  } else if (state is EventsError) {
                    return Center(child: Text(state.message));
                  } else {
                    return const Center(child: Text('No events found.'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 0),
    );
  }

  Widget _eventCard(BuildContext context, EventInfo eventInfo) {
    return Card(
      color: const Color.fromARGB(255, 251, 248, 245),
      margin: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 0.2,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Image.asset(
                  eventInfo.imageUrl,
                  height: 100,
                  width: 150,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          eventInfo.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.star,
                        color: Color.fromARGB(255, 198, 178, 3),
                        size: 15,
                      ),
                      // Text(eventInfo.rating.toString()),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Color(0xFFD79384),
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          eventInfo.wilaya,
                          style: const TextStyle(color: Color(0xFFD79384)),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.date_range,
                        color: Color(0xFFD79384),
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          eventInfo.date,
                          style: const TextStyle(color: Color(0xFFD79384)),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    height: 23,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Eventinformation(eventInfo: eventInfo),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6D071A),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0),
                        ),
                      ),
                      child: const Text(
                        'See More',
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}