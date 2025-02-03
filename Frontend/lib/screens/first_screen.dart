import 'package:flutter/material.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      backgroundColor: const Color(0xFF6D071A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Welcome to',
                style: TextStyle(
                    color: Color(0xFFF5E3DF),
                    fontWeight: FontWeight.bold,
                    fontSize: 55.0,
                    fontFamily: 'Baloo Bhai 2'),
                textAlign: TextAlign.center,
              ),
              Image.asset('assets/Images/Logo/logo_beige_down.png', height: 100),
              const SizedBox(height: 48.0),
              _carousel(),
              const SizedBox(height: 16.0),
              _dotsIndicator(),
              const SizedBox(height: 35.0),
              _button('Sign In'),
              const SizedBox(height: 8.0),
              _button('Create Account', isSecondary: true),
            ],
          ),
        ),
      ),
    );
  }

  Widget _carousel() {
  return SizedBox(
    height: 294,
    width : 339,
    child: PageView(
      controller: _pageController,
      onPageChanged: (int index) {
        setState(() {
          _currentPage = index;
        });
      },
      children: [
        _carouselItem('assets/Images/Places/Timguad.jpg'),
        _carouselItem('assets/Images/Places/Oran.jpg'),
        _carouselItem('assets/Images/Places/Bejaia.jpg'),
        _carouselItem('assets/Images/Places/Tassili.jpg'),
        _carouselItem('assets/Images/Places/timimoun.jpg'),
      ],
    ),
  );
}

Widget _carouselItem(String imagePath) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 12.0), 
    decoration: BoxDecoration(
      border: Border.all(color: const Color(0xFFF5E3DF), width: 1), 
      borderRadius: BorderRadius.circular(50), 
      boxShadow: const [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 6.0,
          offset: Offset(0, 4), 
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(50), 
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
      ),
    ),
  );
}


  Widget _dotsIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          width: _currentPage == index ? 12.0 : 8.0,
          height: _currentPage == index ? 12.0 : 8.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == index ? const Color(0xFFF9F2EC) : const Color(0xFFF9F2EC).withOpacity(0.6),
            boxShadow:  _currentPage == index ? [
            const BoxShadow(
              color: Colors.white, 
              blurRadius: 4.0, 
              offset: Offset(0, 2), 
            ),
          ] : null,
          ),
        );
      }),
    );
  }

  Widget _button(String text, {bool isSecondary = false}) {
    return ElevatedButton(
      onPressed: () {
 
        if (text == 'Sign In') {
          Navigator.pushNamed(context, '/signIn');
        }
     
        else {
          Navigator.pushNamed(context, '/signUp');
        }
        

      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSecondary ? const Color(0xFF6D071A): Colors.white,
        foregroundColor: isSecondary ? const Color(0xFFFFFFFF) : const Color(0xFF6D071A),
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
          side: isSecondary
              ? const BorderSide(color: Colors.white, width: 1.0)
              : BorderSide.none,
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
