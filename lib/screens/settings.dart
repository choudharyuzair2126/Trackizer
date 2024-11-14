// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:trackizer/components/dark_button.dart';
import 'package:trackizer/components/navigation.dart';
import 'package:trackizer/screens/welcome_screen.dart';
import 'package:trackizer/theme/color.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> signOutCompletely() async {
      try {
        // Sign out from Firebase
        await FirebaseAuth.instance.signOut();

        // Sign out from GoogleSignIn to clear Google session
        final googleSignIn = GoogleSignIn();
        if (await googleSignIn.isSignedIn()) {
          await googleSignIn.signOut().then(
                Navigation.replace(context, const WelcomeScreen()),
              );
          //     Navigator.pop(context);
        }

        Navigation.replace(context, const WelcomeScreen());
      } catch (e) {
        debugPrint("Error during sign-out: $e");
      }
    }

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: DarkButton(
              ontap: () {
                signOutCompletely();
              },
              text: "Sign Out",
              buttonColor: Colour.greyButton,
              borderColor: Colour.greyBorder,
              size: 20),
        ),
      ),
    );
  }
}
