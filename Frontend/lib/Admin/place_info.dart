import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/place_class.dart';

class AdminPlaceInformation extends StatefulWidget {
  final PlaceInfo placeInfo;

  const AdminPlaceInformation({Key? key, required this.placeInfo}) : super(key: key);

  @override
  _AdminPlaceInformationState createState() => _AdminPlaceInformationState();
}

class _AdminPlaceInformationState extends State<AdminPlaceInformation> {
  late WebViewController _webViewController;
  bool _isWebViewInitialized = false;
  bool _isLoading = false;
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _historicalController;
  late TextEditingController _locationController;
  late TextEditingController _statusController;
  late TextEditingController _mapUrlController;

  @override
  void initState() {
    super.initState();
    initWebViewController();
    initControllers();
  }

  void initControllers() {
    _nameController = TextEditingController(text: widget.placeInfo.name);
    _descriptionController = TextEditingController(text: widget.placeInfo.description);
    _historicalController = TextEditingController(text: widget.placeInfo.historicalBackground);
    _locationController = TextEditingController(text: widget.placeInfo.location);
    _statusController = TextEditingController(text: widget.placeInfo.status);
    _mapUrlController = TextEditingController(text: widget.placeInfo.mapUrl);
  }

  Future<void> initWebViewController() async {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.placeInfo.mapUrl));
    setState(() {
      _isWebViewInitialized = true;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _historicalController.dispose();
    _locationController.dispose();
    _statusController.dispose();
    _mapUrlController.dispose();
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
      await FirebaseFirestore.instance
          .collection('places')
          .doc(widget.placeInfo.id)
          .update({field: value});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Updated successfully')),
      );

      setState(() {
        switch (field) {
          case 'name':
            widget.placeInfo.name = value;
            break;
          case 'description':
            widget.placeInfo.description = value;
            break;
          case 'historicalBackground':
            widget.placeInfo.historicalBackground = value;
            break;
          case 'location':
            widget.placeInfo.location = value;
            break;
          case 'status':
            widget.placeInfo.status = value;
            break;
          case 'mapUrl':
            widget.placeInfo.mapUrl = value;
            if (_isWebViewInitialized) {
              _webViewController.loadRequest(Uri.parse(value));
            }
            break;
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deletePlace() async {
    setState(() => _isLoading = true);
    try {
      await FirebaseFirestore.instance
          .collection('places')
          .doc(widget.placeInfo.id)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Place deleted successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting place: $e')),
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
          'Admin Place Information',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopImageSection(),
                _buildEditableSection(
                  'Name',
                  widget.placeInfo.name,
                  Icons.edit,
                  () => _showEditDialog('Name', _nameController, 'name'),
                ),
                _buildEditableSection(
                  'Location',
                  widget.placeInfo.location,
                  Icons.location_on,
                  () => _showEditDialog('Location', _locationController, 'location'),
                ),
                _buildEditableSection(
                  'Status',
                  widget.placeInfo.status,
                  Icons.info,
                  () => _showEditDialog('Status', _statusController, 'status'),
                ),
                _buildEditableSection(
                  'Description',
                  widget.placeInfo.description,
                  Icons.description,
                  () => _showEditDialog('Description', _descriptionController, 'description'),
                ),
                _buildEditableSection(
                  'Historical Background',
                  widget.placeInfo.historicalBackground,
                  Icons.history,
                  () => _showEditDialog('Historical Background', _historicalController, 'historicalBackground'),
                ),
                _buildLocationSection(),
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
      ),
    );
  }

  Widget _buildTopImageSection() {
    return Stack(
      children: [
        widget.placeInfo.imageUrl.startsWith('http')
            ? Image.network(
                widget.placeInfo.imageUrl,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              )
            : Image.asset(
                widget.placeInfo.imageUrl,
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
                    'Map Location',
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
                onPressed: () => _showEditDialog('Map URL', _mapUrlController, 'mapUrl'),
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
                    title: Text('Delete Place'),
                    content: Text('Are you sure you want to delete this place?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancel', style: TextStyle(color: Color(0xFF6D071A))),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _deletePlace();
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
              'Delete Place',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}