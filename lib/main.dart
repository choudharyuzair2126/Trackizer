import 'package:flutter/material.dart';
import 'package:trackizer/components/bottom_navigation.dart';
import 'package:trackizer/screens/welcome_screen.dart';
import 'package:trackizer/theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

// double value = 40;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          if (snapshot.hasData && snapshot.data != null) {
            // User is logged in
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Trackizer',
              theme: MyTheme.darkTheme,
              home: const BottomNavigationScreen(),
            );
          } else {
            // User is not logged in
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Trackizer',
              theme: MyTheme.darkTheme,
              home: const WelcomeScreen(), // Replace with your login screen
            );
          }
        }
      },
    );
  }
}
