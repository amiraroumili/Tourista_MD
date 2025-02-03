import 'package:flutter/material.dart';

class SuggestionsAndFeedbackPage extends StatefulWidget {
  const SuggestionsAndFeedbackPage({super.key});

  @override
  _SuggestionsAndFeedbackPageState createState() =>
      _SuggestionsAndFeedbackPageState();
}

class _SuggestionsAndFeedbackPageState
    extends State<SuggestionsAndFeedbackPage> {
  String _usageFrequency = 'Everyday';
  String _motivation = '';
  String _mostUsedFeature = 'Events & Opportunities';
  bool _receivePersonalFollowup = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Suggestions & Feedback',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20.0),
              const Center(
                child: Text(
                  'Help us improve!',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 45),
              const Text(
                'How often do you use our app?',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 9.0),
              _buildFrequencyDropdown(),
              const SizedBox(height: 16.0),
              const Text(
                'What is your motivation to use our app?',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 9.0),
              _buildMotivationField(),
              const SizedBox(height: 16.0),
              const Text(
                'What\'s your most used feature?',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              _buildMostUsedFeatureRadios(),
              const SizedBox(height: 16.0),
              const Text(
                'What would you like to see improved the most?',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 9.0),
              _buildImprovementsField(),
              const SizedBox(height: 16.0),
              _buildPersonalFollowupCheckbox(),
              const SizedBox(height: 32.0),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6D071A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 100.0,
                    ),
                  ),
                  onPressed: _submitFeedback,
                  child: const Text(
                    'Submit',
                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFrequencyDropdown() {
    return DropdownButtonFormField<String>(
      value: _usageFrequency,
      onChanged: (value) {
        setState(() {
          _usageFrequency = value ?? '';
        });
      },
      items: ['Everyday', 'Weekly', 'Monthly']
          .map((freq) => DropdownMenuItem<String>(
                value: freq,
                child: Text(
                  freq,
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                ),
              ))
          .toList(),
      decoration: const InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF6D071A), width: 1.5),
        ),
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      ),
    );
  }

  Widget _buildMotivationField() {
    return TextFormField(
      maxLines: 2,
      decoration: const InputDecoration(
        hintText: 'What problem does it solve?',
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 16.0,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF6D071A), width: 1.5),
        ),
        border: OutlineInputBorder(),
      ),
      onChanged: (value) {
        setState(() {
          _motivation = value;
        });
      },
    );
  }

  Widget _buildMostUsedFeatureRadios() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RadioListTile<String>(
          value: 'Events & Opportunities',
          groupValue: _mostUsedFeature,
          activeColor: const Color(0xFF6D071A),
          onChanged: (value) {
            setState(() {
              _mostUsedFeature = value ?? '';
            });
          },
          title: const Text('Events & Opportunities'),
        ),
        RadioListTile<String>(
          value: 'Guides Information',
          groupValue: _mostUsedFeature,
          activeColor: const Color(0xFF6D071A),
          onChanged: (value) {
            setState(() {
              _mostUsedFeature = value ?? '';
            });
          },
          title: const Text('Guides Information'),
        ),
        RadioListTile<String>(
          value: 'Favourite Places',
          groupValue: _mostUsedFeature,
          activeColor: const Color(0xFF6D071A),
          onChanged: (value) {
            setState(() {
              _mostUsedFeature = value ?? '';
            });
          },
          title: const Text('Favourite Places'),
        ),
      ],
    );
  }

  Widget _buildImprovementsField() {
    return TextFormField(
      maxLines: 3,
      decoration: const InputDecoration(
        hintText: 'We would love to hear your suggestions!',
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 16.0,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF6D071A), width: 1.5),
        ),
        border: OutlineInputBorder(),
      ),
      onChanged: (value) {
       
      },
    );
  }

  Widget _buildPersonalFollowupCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 20.0,
          child: Checkbox(
            value: _receivePersonalFollowup,
            activeColor: const Color(0xFF6D071A),
            onChanged: (value) {
              setState(() {
                _receivePersonalFollowup = value ?? false;
              });
            },
          ),
        ),
        const SizedBox(width: 8.0),
        const Flexible(
          child: Text(
            'Receive personal follow-up to your feedback.',
            style: TextStyle(fontSize: 16.0),
          ),
        ),
      ],
    );
  }

  void _submitFeedback() {
    print('Usage Frequency: $_usageFrequency');
    print('Motivation: $_motivation');
    print('Most Used Feature: $_mostUsedFeature');
    print('Receive Personal Followup: $_receivePersonalFollowup');

   
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
         
            shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                        side: BorderSide(
                          color: Color(0xFF800000),
                          width: 2,
                        ),
                      ),
          
          title: const Text('Thank you!'),
          content: const Text('Thank you for your feedback.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK' , style: TextStyle( color: Color(0xFF800000) ,  fontSize: 18,
                          fontWeight: FontWeight.bold,),),
            ),
          ],
        );
      },
    );
  }
}