import 'package:flutter/material.dart';
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
import 'database/database.dart';

void main() async {
  runApp(TouristaApp());
}

class TouristaApp extends StatelessWidget {
  final DatabaseService databaseService = DatabaseService();

  TouristaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tourista',
      initialRoute: '/first',
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (settings) {
        if (settings.name == '/guides') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => GuidesInfoPage(
              guides: args['guides'] as List<Map<String, dynamic>>,
              wilayaName: args['wilayaName'] as String,
            ),
          );
        }
        return MaterialPageRoute(
          builder: (context) {
            switch (settings.name) {
              case '/first':
                return const FirstScreen();
              case '/signIn':
                return SignInScreen(databaseService: databaseService);
              case '/signUp':
                return SignUpScreen(databaseService: databaseService);
              case '/home':
                final args = settings.arguments as Map<String, dynamic>?;
                return HomeScreen(
                  userEmail: args?['userEmail'] ?? '',
                );
              case '/favorite':
                return const FavoritePlacesScreen();
              case '/ev&opp':
                return const EventsAndOpportunitiesScreen();
              case '/forgetPass':
                return ForgetPassScreen();
              case '/notifications':
                return const NotificationsPage();
              case '/profile':
                final args = settings.arguments as Map<String, dynamic>?;
                if (args == null || !args.containsKey('userEmail')) {
                  return const Center(child: Text('Error: Missing user email'));
                }
                return ProfilePage(
                  userEmail: args['userEmail'] as String,
                  databaseService: databaseService,
                );
              case '/wilayas':
                return const WilayaListPage();
              case '/contact':
                return const ContactUsPage();
              case '/feedback':
                return const SuggestionsAndFeedbackPage();
              case '/placeinfo':
                final args = settings.arguments as Map<String, dynamic>;
                return InformationPagess(placeInfo: args['placeInfo']);
              case '/verification':
                return VerificationScreen();
              case '/changePass':
                return const ChangePasswordPage();
              default:
                return const FirstScreen();
            }
          },
        );
      },
    );
  }
}