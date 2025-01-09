import 'package:flutter/material.dart';
import '../api/place_api.dart';

class AddPlacePage extends StatefulWidget {
  @override
  _AddPlacePageState createState() => _AddPlacePageState();
}

class _AddPlacePageState extends State<AddPlacePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _historicalBackgroundController = TextEditingController();
  final TextEditingController _mapUrlController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _locationController.dispose();
    _imageUrlController.dispose();
    _ratingController.dispose();
    _statusController.dispose();
    _historicalBackgroundController.dispose();
    _mapUrlController.dispose();
    super.dispose();
  }

  Future<void> _addPlace() async {
    if (_formKey.currentState!.validate()) {
      final place = {
        'name': _nameController.text,
        'description': _descriptionController.text,
        'category': _categoryController.text,
        'location': _locationController.text,
        'imageUrl': _imageUrlController.text,
        'rating': double.tryParse(_ratingController.text) ?? 0.0,
        'status': _statusController.text,
        'historicalBackground': _historicalBackgroundController.text,
        'mapUrl': _mapUrlController.text,
        'isFavorite': false,
      };

      try {
        await PlaceApi.addPlace(place);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Place added successfully')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add place: $e')),
        );
      }
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
          'Add Place',
          style: TextStyle(
            color: Color(0xFF6D071A),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        
        padding: const EdgeInsets.all(16.0),
        child: Card(
          color: Colors.white ,
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextField(_nameController, 'Name', Icons.place),
                  _buildTextField(_descriptionController, 'Description', Icons.description),
                  _buildTextField(_categoryController, 'Category', Icons.category),
                  _buildTextField(_locationController, 'Location', Icons.location_on),
                  _buildTextField(_ratingController, 'Rating', Icons.star, isNumber: true),
                  _buildTextField(_statusController, 'Status', Icons.info),
                  _buildTextField(_historicalBackgroundController, 'Historical Background', Icons.history),
                  _buildTextField(_mapUrlController, 'Map URL', Icons.map),
                  
                  _buildTextField(_imageUrlController, 'Image URL', Icons.image, onChanged: (_) => setState(() {})),
                  if (_imageUrlController.text.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          _imageUrlController.text,
                          height: 160,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Icon(Icons.broken_image, size: 90, color: Colors.grey),
                        ),
                      ),
                    ),
                  
                  SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _addPlace,
                    icon: Icon(Icons.add),
                    label: Text('Add Place', style: TextStyle(fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF6D071A),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool isNumber = false,
    void Function(String)? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Color(0xFF6D071A)),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        validator: (value) => (value == null || value.isEmpty) ? 'Please enter $label' : null,
        onChanged: onChanged,
      ),
    );
  }
}
