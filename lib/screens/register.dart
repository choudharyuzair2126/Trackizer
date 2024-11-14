// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trackizer/components/bottom_navigation.dart';
import 'package:trackizer/components/dark_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:trackizer/components/navigation.dart';
import 'package:trackizer/components/trackizer.dart';
import 'package:trackizer/screens/email_registration.dart';
import 'package:trackizer/screens/home_screen.dart';
import 'package:trackizer/theme/color.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      print("Starting Google Sign-In process...");
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        print("Google user signed in: ${googleUser.email}");

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Sign in with Firebase
        final userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        print("User signed in: ${userCredential.user?.email}");
        String token = FirebaseAuth.instance.currentUser!.uid;

        await FirebaseFirestore.instance
            .collection(token)
            .doc("Entertainment")
            .set({
          "Name": "Entertainment",
          "IconCodePoint": Icons.movie_filter_outlined.codePoint,
          "Budget": "1000",
          "Color": Colour.box1.value,
        });
        // Navigate to HomeScreen
        Navigator.pushAndRemoveUntil<void>(
          context,
          MaterialPageRoute<void>(
              builder: (BuildContext context) =>
                  const BottomNavigationScreen()),
          ModalRoute.withName('/'),
        );
        //    Navigation.push(context, const BottomNavigationScreen());
      } else {
        print("Google sign-in canceled by user.");
      }
    } catch (e) {
      print("Error during Google sign-in: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to sign in with Google: $e")),
      );
    }
  }

  Future<void> signInWithFacebook(BuildContext context) async {
    try {
      print("Starting Facebook Sign-In process...");
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        print("Facebook sign-in successful.");
        final OAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(result.accessToken!.token);

        // Sign in with Firebase
        final userCredential = await FirebaseAuth.instance
            .signInWithCredential(facebookAuthCredential);
        print("User signed in: ${userCredential.user?.email}");

        // Navigate to HomeScreen
        Navigation.push(context, const HomeScreen());
      } else {
        print("Facebook sign-in failed: ${result.status}");
      }
    } catch (e) {
      print("Error during Facebook sign-in: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to sign in with Facebook: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 70),
            const Trackizer(fontSize: 24, width: 15),
            SizedBox(height: MediaQuery.of(context).size.height / 2.6),
            DarkButton(
              ontap: () {},
              text: "Sign up with Apple",
              buttonColor: Colour.blackButton,
              borderColor: Colour.blackBorder,
              size: 15,
              icon: const Icon(Icons.apple),
            ),
            const SizedBox(height: 10),
            DarkButton(
              ontap: () => signInWithGoogle(context),
              text: "Sign up with Google",
              buttonColor: Colour.whiteButton,
              borderColor: Colour.whiteBorder,
              textColor: Colors.black,
              size: 15,
              //icon: Icon(Icons.google),
              icon: Image.asset(
                'assets/images/google (3).png',
                scale: 3,
              ),
            ),
            const SizedBox(height: 10),
            DarkButton(
              ontap: () => signInWithFacebook(context),
              text: "Sign up with Facebook",
              buttonColor: Colour.blueButton,
              borderColor: Colour.blueBorder,
              icon: const Icon(Icons.facebook),
              size: 15,
            ),
            const SizedBox(height: 25),
            const Text(
              "or",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 25),
            DarkButton(
              ontap: () => Navigation.push(context, const EmailRegistration()),
              text: "Sign up with Email",
              buttonColor: Colour.greyButton,
              borderColor: Colour.greyBorder,
              size: 15,
            ),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: () {},
              child: RichText(
                text: const TextSpan(
                  text: '''By registering, you agree to our Terms of Use. Learn 
                  how we collect, use and share your data.''',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
