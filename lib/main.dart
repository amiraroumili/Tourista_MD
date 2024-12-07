import 'package:flutter/material.dart';
import 'package:tourista/screens/Places_information_page.dart';
import 'auth/auth_dummy.dart';
import 'screens/Edit_profile_page.dart';
import 'screens/Eventinformation.dart';
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
<<<<<<< HEAD
import 'data/Placesdata.dart';
import 'data/Eventdata.dart';
import 'screens/suggestions_feedback_screen.dart';

=======
>>>>>>> 35e152e28003971e528d21ed6e735a51febb0204


void main() {
  runApp(TouristaApp());
}

class TouristaApp extends StatelessWidget {
  final DummyAuthService authService = DummyAuthService();

  TouristaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tourista',
      initialRoute: '/first',
      debugShowCheckedModeBanner: false,
      routes: {
        '/first': (context) => FirstScreen(), 
        '/signIn': (context) => SignInScreen(authService: authService), 
        '/signUp': (context) => SignUpScreen(authService: authService), 
        '/home': (context) => HomeScreen(), 
        '/favorite': (context) => FavoritePlacesScreen(), 
        '/ev&opp': (context) => EventsAndOpportunitiesScreen(), 
        '/forgetPass': (context) => ForgetPassScreen(),
        '/notifications': (context) => NotificationsPage(),
<<<<<<< HEAD
        '/edirprofile': (context) => EditProfilePage(),
        '/profile': (context) => ProfilePage(),
        '/guides': (context) => GuidesInfoPage(),
        '/wilayas': (context) => WilayaListPage(),
        '/contact': (context) => ContactUsPage(),
        '/feedback': (context) => SuggestionsAndFeedbackPage(),
        '/placeinfo': (context) => InformationPagess( placeInfo : timgad ),
        '/Eventinfo': (context) => Eventinformation( eventInfo : techConference ),
        '/verification': (context) => VerificationScreen(),
        '/changePass': (context) =>ChangePasswordPage(),
        
=======
>>>>>>> 35e152e28003971e528d21ed6e735a51febb0204
      },
    );
  }
}
