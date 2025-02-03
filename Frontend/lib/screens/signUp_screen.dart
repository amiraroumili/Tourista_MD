// filepath: /c:/Users/AMIRA/Desktop/Tourista/NEEEW/lib/screens/signUp_screen.dart
import 'package:flutter/material.dart';
import '../database/database.dart';
import 'dart:async'; // For Timer

class SignUpScreen extends StatefulWidget {
  final DatabaseService databaseService;

  const SignUpScreen({super.key, required this.databaseService});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _familyNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _wilayaController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Create an account',
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
            Positioned(
              bottom: -30,
              left: -20,
              child: Image.asset(
                'assets/Images/Icons/tree_vector.png',
                height: deviceHeight * 0.5,
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.06),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: deviceHeight * 0.03),
                      _firstNameField(),
                      SizedBox(height: deviceHeight * 0.02),
                      _familyNameField(),
                      SizedBox(height: deviceHeight * 0.02),
                      _emailField(),
                      SizedBox(height: deviceHeight * 0.02),
                      _wilayaField(),
                      SizedBox(height: deviceHeight * 0.02),
                      _passwordField(),
                      SizedBox(height: deviceHeight * 0.02),
                      _confirmPasswordField(),
                      SizedBox(height: deviceHeight * 0.04),
                      _signUpButton(),
                      SizedBox(height: deviceHeight * 0.02),
                      _signInText(context),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _firstNameField() {
    return TextFormField(
      controller: _firstNameController,
      decoration: InputDecoration(
        labelText: 'First name',
        labelStyle: TextStyle(color: const Color(0xFF6D071A).withOpacity(0.7)),
        prefixIcon: const Icon(Icons.person, color: Color(0xFF6D071A)),
        suffixIcon: _firstNameController.text.isNotEmpty && _firstNameController.text.length >= 2 ? const Icon(Icons.check_circle, color: Colors.green): null,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
          borderSide: const BorderSide(color: Color(0xFF6D071A)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
          borderSide: const BorderSide(color: Color(0xFF6D071A)),
        ),
      ),
      onChanged: (value) {
        setState(() {});
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'First name is required';
        }
        return null;
      },
    );
  }

  Widget _familyNameField() {
    return TextFormField(
      controller: _familyNameController,
      decoration: InputDecoration(
        labelText: 'Family name',
        labelStyle: TextStyle(color: const Color(0xFF6D071A).withOpacity(0.7)),
        prefixIcon: const Icon(Icons.person, color: Color(0xFF6D071A)),
        suffixIcon: _familyNameController.text.isNotEmpty && _familyNameController.text.length >= 2 ? const Icon(Icons.check_circle, color: Colors.green): null,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
          borderSide: const BorderSide(color: Color(0xFF6D071A)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
          borderSide: const BorderSide(color: Color(0xFF6D071A)),
        ),
      ),
      onChanged: (value) {
        setState(() {});
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Family name is required';
        }
        return null;
      },
    );
  }

  Widget _emailField() {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'Email',
        labelStyle: TextStyle(color: const Color(0xFF6D071A).withOpacity(0.7)),
        prefixIcon: const Icon(Icons.email, color: Color(0xFF6D071A)),
        suffixIcon: _emailController.text.isNotEmpty &&
              RegExp(r'\S+@\S+\.\S+').hasMatch(_emailController.text)
          ? const Icon(Icons.check_circle, color: Colors.green)
          : null,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
          borderSide: const BorderSide(color: Color(0xFF6D071A)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
          borderSide: const BorderSide(color: Color(0xFF6D071A)),
        ),
      ),
      onChanged: (value) {
        setState(() {});
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Email is required';
        } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
          return 'Enter a valid email';
        }
        return null;
      },
    );
  }

  Widget _wilayaField() {
    return TextFormField(
      controller: _wilayaController,
      decoration: InputDecoration(
        labelText: 'Wilaya',
        labelStyle: TextStyle(color: const Color(0xFF6D071A).withOpacity(0.7)),
        prefixIcon: const Icon(Icons.location_city, color: Color(0xFF6D071A)),
        suffixIcon: _wilayaController.text.isNotEmpty && _wilayaController.text.length >= 4
          ? const Icon(Icons.check_circle, color: Colors.green)
          : null,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
          borderSide: const BorderSide(color: Color(0xFF6D071A)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
          borderSide: const BorderSide(color: Color(0xFF6D071A)),
        ),
      ),
      onChanged: (value) {
        setState(() {});
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Wilaya is required';
        }
        return null;
      },
    );
  }

  Widget _passwordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: TextStyle(color: const Color(0xFF6D071A).withOpacity(0.7)),
        prefixIcon: const Icon(Icons.lock, color: Color(0xFF6D071A)),
        suffixIcon: _passwordController.text.length >= 6
          ? const Icon(Icons.check_circle, color: Colors.green)
          : null,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
          borderSide: const BorderSide(color: Color(0xFF6D071A)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
          borderSide: const BorderSide(color: Color(0xFF6D071A)),
        ),
      ),
      onChanged: (value) {
        setState(() {});
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password is required';
        } else if (value.length < 6) {
          return 'Password should be at least 6 characters';
        }
        return null;
      },
    );
  }

  Widget _confirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Confirm Password',
        labelStyle: TextStyle(color: const Color(0xFF6D071A).withOpacity(0.7)),
        prefixIcon: const Icon(Icons.lock, color: Color(0xFF6D071A)),
        suffixIcon: _confirmPasswordController.text == _passwordController.text &&
              _confirmPasswordController.text.isNotEmpty
          ? const Icon(Icons.check_circle, color: Colors.green)
          : null,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
          borderSide: const BorderSide(color: Color(0xFF6D071A)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
          borderSide: const BorderSide(color: Color(0xFF6D071A)),
        ),
      ),
      onChanged: (value) {
        setState(() {});
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Confirm password is required';
        } else if (value != _passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }

  Widget _signUpButton() {
    return ElevatedButton(
onPressed: () async {
  if (_formKey.currentState?.validate() ?? false) {
    try {
      // Add debug print before insertion
      print('Attempting to insert user: ${_emailController.text}');
      
      await widget.databaseService.insertUser({
        'email': _emailController.text,
        'password': _passwordController.text,
        'firstName': _firstNameController.text,
        'familyName': _familyNameController.text,
        'wilaya': _wilayaController.text,
      });
      
      // Add debug print after insertion
      print('User inserted successfully');
      
      // Verify the user was saved
      final savedUser = await widget.databaseService.getUser(_emailController.text);
      print('Saved user data: $savedUser');

            // Show the success dialog
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Center(
                    child: Text(
                      'Success',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  alignment: Alignment.center,
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Account created successfully!',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16.0),
                      ),
                      const SizedBox(height: 16.0),
                      Icon(
                        Icons.check,
                        color: const Color(0xFF6D071A).withOpacity(0.7),
                        size: 48.0,
                      ),
                    ],
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0),
                    side: const BorderSide(color: Color(0xFF6D071A), width: 2),
                  ),
                );
              },
            );

            // Navigate to Sign In screen after 2 seconds
            Timer(const Duration(seconds: 2), () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/signIn');
            });
          } catch (e) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                    side: const BorderSide(
                      color: Color(0xFF6D071A),
                      width: 2,
                    ),
                  ),
                  title: const Text('Error'),
                  content: Text(e.toString()),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('OK', style: TextStyle(color: Color(0xFF6D071A))),
                    ),
                  ],
                );
              },
            );
          }
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF6D071A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
      ),
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'Sign Up',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }

  Widget _signInText(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Already have an account? "),
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
    );
  }
}