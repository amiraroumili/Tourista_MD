import 'package:flutter/material.dart';

class ForgetPassScreen extends StatelessWidget {
 // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ForgetPassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Forgot Password',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Baloo Bhai 2',
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Color(0xFF6D071A)),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Tree vector image
            Positioned(
              bottom: -30,
              left: -20,
              child: Image.asset(
                'assets/Images/Icons/tree_vector.png',
                height: 500,
              ),
            ),
            // Main content (Forgot Password form)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _logo(),
                  const SizedBox(height: 48.0),
                  _emailField(),
                  const SizedBox(height: 32.0),
                  _sendButton(context),
                  const SizedBox(height: 16.0),
                  _signInText(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _logo() {
    return Center(
      child: Image.asset(
        'assets/Images/Logo/logo_red_up.png',
        height: 100,
      ),
    );
  }

  Widget _emailField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Enter Email Address',
        labelStyle: TextStyle(color: const Color(0xFF6D071A).withOpacity(0.7)),
        prefixIcon: const Icon(Icons.email, color: Color(0xFF6D071A)),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
          borderSide: const BorderSide(color: Color(0xFF6D071A)),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email address';
        }
        return null;
      },
    );
  }

  Widget _sendButton(BuildContext context) {
return ElevatedButton(
  onPressed: () {
   
   

    
      Navigator.pushReplacementNamed(
        context,
        '/verification', 
      );
   
  },
  style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF6D071A),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
      ),
      child: const Text(
        'Send',
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _signInText(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Back to'),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signIn');
                },
                child: const Text(
                  'Sign in',
                  style: TextStyle(color: Color(0xFF6D071A)),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Don't have an account?"),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signUp');
                },
                child: const Text(
                  'Sign up ',
                  style: TextStyle(color: Color(0xFF6D071A)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}