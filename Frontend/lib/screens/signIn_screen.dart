// sign_in_screen.dart
import 'package:flutter/material.dart';
import '../api/user_api.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInScreen extends StatefulWidget {



  SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Sign In',
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
                height: 500,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _logo(),
                  const SizedBox(height: 48.0),
                  _emailField(),
                  const SizedBox(height: 30.0),
                  _passwordField(),
                  const SizedBox(height: 24.0),
                  _forgotPassword(),
                  const SizedBox(height: 32.0),
                  _isLoading 
                    ? const Center(child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6D071A)),
                      )) 
                    : _signInButton(context),
                  const SizedBox(height: 16.0),
                  _signUpText(context),
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 8),
                    Text(_errorMessage!, 
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ],
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
    return TextField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'Email',
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
    );
  }

  Widget _passwordField() {
    return TextField(
      controller: _passwordController,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: TextStyle(color: const Color(0xFF6D071A).withOpacity(0.7)),
        prefixIcon: const Icon(Icons.lock, color: Color(0xFF6D071A)),
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
    );
  }

  Widget _forgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          Navigator.pushNamed(context, '/forgetPass');
        },
        child: const Text(
          'Forgot Password?',
          style: TextStyle(color: Color(0xFF6D071A)),
        ),
      ),
    );
  }

 Widget _signInButton(BuildContext context) {
  return ElevatedButton(
    onPressed: () async {
      if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
        setState(() {
          _errorMessage = 'Please fill in all fields';
        });
        return;
      }

      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      
      try {
        final userData = await UserApi.loginUser(
          _emailController.text,
          _passwordController.text,
        );
        
        // // Add null check here
        // if (userData == null) {
        //   throw Exception('Failed to retrieve user data');
        // }
        
        if (!mounted) return;
        
        Navigator.pushReplacementNamed(
          context,
          '/home',
          arguments: {
            'userEmail': _emailController.text,
            'userData': userData,
          },
        );
      } on FirebaseAuthException catch (e) {
        setState(() {
          // More specific error messages
          switch (e.code) {
            case 'user-not-found':
              _errorMessage = 'No user found with this email';
              break;
            case 'wrong-password':
              _errorMessage = 'Wrong password provided';
              break;
            case 'invalid-email':
              _errorMessage = 'Invalid email address';
              break;
            default:
              _errorMessage = e.message ?? 'An error occurred during sign in';
          }
        });
      } catch (e) {
        setState(() {
          _errorMessage = e.toString();
        });
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
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
        'Sign In',
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _signUpText(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account?"),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/signUp');
          },
          child: const Text(
            'Sign up here',
            style: TextStyle(color: Color(0xFF6D071A)),
          ),
        ),
      ],
    );
  }
}