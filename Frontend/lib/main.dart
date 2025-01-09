import 'package:flutter/material.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:tourista/config/firebase_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tourista/screens/Places_information_page.dart';
import 'screens/GuidesInfoPage.dart';
import 'screens/Profile_page.dart';
import 'screens/Verification_page.dart';
import 'screens/Wilaya_list_page.dart';
import 'screens/change_password_screen.dart';
import 'screens/contact_us_screen.dart';
import 'screens/first_screen.dart';
import 'screens/signIn_screen.dart';
import 'screens/signUp_screen.dart';
import 'screens/home_screen.dart';
import 'screens/favorite_screen.dart';
import 'screens/events&opp_screen.dart';
import 'screens/forgetPass_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/suggestions_feedback_screen.dart';
import '../Admin/add_place.dart';
import '../Admin/add_event.dart'; 
import '../Admin/statistics_page.dart'; // Ensure this import is correct
//import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print('Initializing Firebase...');

  try {
    await FirebaseConfig.initialize();
    // or await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    
    print('Firebase initialized successfully');
    print('Auth instance: ${FirebaseAuth.instance.toString()}');
    print('Firestore instance: ${FirebaseFirestore.instance.toString()}');
  } catch (e, stackTrace) {
    print('Firebase initialization failed:');
    print('Error: $e');
    print('Stack trace: $stackTrace');
  }

  runApp(TouristaApp());
}

class TouristaApp extends StatelessWidget {
  TouristaApp({super.key});

  @override
  Widget build(BuildContext context) {
     print('Building TouristaApp...');
    return MaterialApp(
      title: 'Tourista',
      initialRoute: '/first',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF6D071A),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6D071A),
        ),
      ),
      onGenerateRoute: (settings) {
        final args = settings.arguments as Map<String, dynamic>?;

        switch (settings.name) {
          case '/first':
            return MaterialPageRoute(builder: (_) => const FirstScreen());
          case '/signIn':
            return MaterialPageRoute(builder: (_) => SignInScreen());
          case '/signUp':
            return MaterialPageRoute(builder: (_) => SignUpScreen());
          case '/home':
            return MaterialPageRoute(
              builder: (_) => HomeScreen(userEmail: args?['userEmail'] ?? ''),
            );
          case '/favorite':
            return MaterialPageRoute(builder: (_) => const FavoritePlacesScreen());
          case '/ev&opp':
            return MaterialPageRoute(
              builder: (_) => EventsAndOpportunitiesScreen(userEmail: args?['userEmail'] ?? ''),
            );
          case '/forgetPass':
            return MaterialPageRoute(builder: (_) => ForgetPassScreen());
          case '/notifications':
            return MaterialPageRoute(builder: (_) => const NotificationsPage());
          case '/profile':
            return args != null && args.containsKey('userEmail')
                ? MaterialPageRoute(builder: (_) => ProfilePage(userEmail: args['userEmail']))
                : _errorPage();
          case '/wilayas':
            return MaterialPageRoute(builder: (_) => const WilayaListPage());
          case '/contact':
            return MaterialPageRoute(builder: (_) => const ContactUsPage());
          case '/feedback':
            return MaterialPageRoute(builder: (_) => const SuggestionsAndFeedbackPage());
          case '/placeinfo':
            return args != null && args.containsKey('placeInfo')
                ? MaterialPageRoute(builder: (_) => InformationPagess(placeInfo: args['placeInfo']))
                : _errorPage();
          case '/guides':
            return args != null && args.containsKey('guides') && args.containsKey('wilayaName')
                ? MaterialPageRoute(
                    builder: (_) => GuidesInfoPage(
                      guides: args['guides'],
                      wilayaName: args['wilayaName'],
                    ),
                  )
                : _errorPage();
          case '/verification':
            return MaterialPageRoute(builder: (_) => VerificationScreen());
          case '/changePass':
            return MaterialPageRoute(builder: (_) => const ChangePasswordPage());
          case '/add_place':
            return MaterialPageRoute(builder: (_) => AddPlacePage());
          case '/add_event':
            return MaterialPageRoute(builder: (_) => AddEventPage());
          case '/statistics':
            return MaterialPageRoute(builder: (_) => StatisticsScreen()); // Uncommented this line
          default:
            return _errorPage();
        }
      },
    );
  }

  /// 🔥 **Error Page for Missing Arguments**
  MaterialPageRoute _errorPage() {
    return MaterialPageRoute(
      builder: (_) => const Scaffold(
        body: Center(child: Text('Error: Missing or incorrect arguments')),
      ),
    );
  }
}