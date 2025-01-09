import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../screens/event_bloc/event_information_bloc.dart';
import '../screens/event_event/event_information_event.dart';
import '../screens/event_state/event_information_state.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../screens/event_info_new.dart';
import '../api/event_api.dart';
class AdminEventInformation extends StatefulWidget {
  final EventInfo eventInfo;

  const AdminEventInformation({Key? key, required this.eventInfo}) : super(key: key);

  @override
  _AdminEventInformationState createState() => _AdminEventInformationState();
}

class _AdminEventInformationState extends State<AdminEventInformation> {
  late WebViewController _webViewController;
  bool _isWebViewInitialized = false;
  bool _isLoading = false;
  late EventInformationBloc _eventInformationBloc;
  late EventService _eventService;
  late EventInfo _currentEventInfo;
  
  // Text controllers for editable fields
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _wilayaController;
  late TextEditingController _dateController;
  late TextEditingController _locationController;

  @override
  void initState() {
    super.initState();
    _eventService = EventService();
    _currentEventInfo = widget.eventInfo;
    _eventInformationBloc = EventInformationBloc();
    _eventInformationBloc.add(LoadEventInformation(eventInfo: _currentEventInfo));
    initWebViewController();
    initControllers();
  }

  void initControllers() {
    _titleController = TextEditingController(text: _currentEventInfo.title);
    _descriptionController = TextEditingController(text: _currentEventInfo.description);
    _wilayaController = TextEditingController(text: _currentEventInfo.wilaya);
    _dateController = TextEditingController(text: _currentEventInfo.date);
    _locationController = TextEditingController(text: _currentEventInfo.location);
  }

  Future<void> initWebViewController() async {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(_currentEventInfo.location));
    setState(() {
      _isWebViewInitialized = true;
    });
  }

  @override
  void dispose() {
    _eventInformationBloc.close();
    _titleController.dispose();
    _descriptionController.dispose();
    _wilayaController.dispose();
    _dateController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _showEditDialog(String title, TextEditingController controller, String field) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit $title'),
          content: TextField(
            controller: controller,
            maxLines: null,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter new $title',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: Color(0xFF6D071A))),
            ),
            ElevatedButton(
              onPressed: () async {
                await _updateField(field, controller.text);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF6D071A),
              ),
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

 Future<void> _updateField(String field, String value) async {
  setState(() => _isLoading = true);
  try {
    // Create a new map with updated field
    Map<String, dynamic> updatedData = {
      'id': _currentEventInfo.id,
      'title': field == 'title' ? value : _currentEventInfo.title,
      'description': field == 'description' ? value : _currentEventInfo.description,
      'date': field == 'date' ? value : _currentEventInfo.date,
      'wilaya': field == 'wilaya' ? value : _currentEventInfo.wilaya,
      'location': field == 'location' ? value : _currentEventInfo.location,
      'imageUrl': _currentEventInfo.imageUrl,
      'rating': _currentEventInfo.rating,
    };
    
    // Create new EventInfo instance
    EventInfo updatedEvent = EventInfo.fromMap(updatedData);
    
    // Update in Firebase
    await _eventService.updateEvent(_currentEventInfo.id, updatedEvent);
    
    // Update local state
    setState(() {
      _currentEventInfo = updatedEvent;
      // Update the corresponding controller
      switch (field) {
        case 'title':
          _titleController.text = value;
          break;
        case 'description':
          _descriptionController.text = value;
          break;
        case 'date':
          _dateController.text = value;
          break;
        case 'wilaya':
          _wilayaController.text = value;
          break;
        case 'location':
          _locationController.text = value;
          if (_isWebViewInitialized) {
            _webViewController.loadRequest(Uri.parse(value));
          }
          break;
      }
    });

    // Trigger a rebuild of the event information
    _eventInformationBloc.add(LoadEventInformation(eventInfo: _currentEventInfo));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Updated successfully')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error updating: $e')),
    );
  } finally {
    setState(() => _isLoading = false);
  }
}
  Future<void> _deleteEvent() async {
    setState(() => _isLoading = true);
    try {
      await _eventService.deleteEvent(_currentEventInfo.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Event deleted successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting event: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Admin Event Information',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<EventInformationBloc, EventInformationState>(
        bloc: _eventInformationBloc,
        builder: (context, state) {
          if (state is EventInformationLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is EventInformationLoaded) {
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTopImageSection(),
                      _buildEditableSection(
                        'Title',
                        widget.eventInfo.title,
                        Icons.title,
                        () => _showEditDialog('Title', _titleController, 'title'),
                      ),
                      _buildEditableSection(
                        'Wilaya',
                        widget.eventInfo.wilaya,
                        Icons.location_city,
                        () => _showEditDialog('Wilaya', _wilayaController, 'wilaya'),
                      ),
                      _buildEditableSection(
                        'Date',
                        widget.eventInfo.date,
                        Icons.calendar_today,
                        () => _showEditDialog('Date', _dateController, 'date'),
                      ),
                      _buildEditableSection(
                        'Description',
                        widget.eventInfo.description,
                        Icons.description,
                        () => _showEditDialog('Description', _descriptionController, 'description'),
                      ),
                      _buildLocationSection(),
                      _buildRatingSection(),
                      _buildCommentsSection(),
                      _buildAdminControls(),
                    ],
                  ),
                ),
                if (_isLoading)
                  Container(
                    color: Colors.black.withOpacity(0.5),
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6D071A)),
                      ),
                    ),
                  ),
              ],
            );
          } else if (state is EventInformationError) {
            return Center(child: Text(state.message));
          } else {
            return Center(child: Text('No event information found.'));
          }
        },
      ),
    );
  }

  Widget _buildTopImageSection() {
    return Stack(
      children: [
        widget.eventInfo.imageUrl.startsWith('http')
            ? Image.network(
                widget.eventInfo.imageUrl,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              )
            : Image.asset(
                widget.eventInfo.imageUrl,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton(
            backgroundColor: Color(0xFF6D071A),
            child: Icon(Icons.edit_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Image editing functionality to be implemented')),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEditableSection(String title, String content, IconData icon, VoidCallback onEdit) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, color: Color(0xFFD79384)),
                  SizedBox(width: 8),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6D071A),
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: Icon(Icons.edit, color: Color(0xFF6D071A)),
                onPressed: onEdit,
              ),
            ],
          ),
          Divider(color: Color(0xFF6D071A), thickness: 1.75),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              content,
              style: TextStyle(fontSize: 16, color: Colors.grey[800]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.map, color: Color(0xFFD79384)),
                  SizedBox(width: 8),
                  Text(
                    'Location',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6D071A),
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: Icon(Icons.edit, color: Color(0xFF6D071A)),
                onPressed: () => _showEditDialog('Location URL', _locationController, 'location'),
              ),
            ],
          ),
          Divider(color: Color(0xFF6D071A), thickness: 1.75),
          if (_isWebViewInitialized)
            Container(
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: WebViewWidget(controller: _webViewController),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRatingSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.star, color: Color(0xFFD79384)),
              SizedBox(width: 8),
              Text(
                'Rating',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6D071A),
                ),
              ),
            ],
          ),
          Divider(color: Color(0xFF6D071A), thickness: 1.75),
          Center(
            child: Column(
              children: [
                SizedBox(height: 10),
                Text(
                  'Current Rating: ${widget.eventInfo.rating}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                RatingBarIndicator(
                  rating: widget.eventInfo.rating,
                  itemBuilder: (context, index) => Icon(
                    Icons.star,
                    color: Color(0xFFD79384),
                  ),
                  itemCount: 5,
                  itemSize: 40.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.comment, color: Color(0xFFD79384)),
              SizedBox(width: 8),
              Text(
                'Comments',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6D071A),
                ),
              ),
            ],
          ),
          Divider(color: Color(0xFF6D071A), thickness: 1.75),
          Center(
            child: Column(
              children: [
                SizedBox(height: 10),
                Text(
                  'No comments available',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminControls() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Delete Event'),
                    content: Text('Are you sure you want to delete this event?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancel', style: TextStyle(color: Color(0xFF6D071A))),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _deleteEvent();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: Text('Delete'),
                      ),
                    ],
                  );
                },
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
            ),
            child: Text(
              'Delete Event',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}