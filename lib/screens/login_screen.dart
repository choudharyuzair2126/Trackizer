// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trackizer/components/bottom_navigation.dart';
import 'package:trackizer/components/dark_button.dart';
import 'package:trackizer/components/gradient_button.dart';
import 'package:trackizer/components/my_textfield.dart';
import 'package:trackizer/components/navigation.dart';
import 'package:trackizer/components/trackizer.dart';
import 'package:trackizer/screens/forgot_password.dart';
import 'package:trackizer/screens/register.dart';
import 'package:trackizer/theme/color.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Trackizer(
          fontSize: 24,
          width: 15,
        ),
        backgroundColor: Colour.backgroundColor,
        automaticallyImplyLeading: false,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: keyboardHeight > 0
                        ? 70
                        : MediaQuery.of(context).size.height / 4.7,
                  ),
                  Text(
                    "E-mail address",
                    style: TextStyle(color: Colour.fieldColor),
                  ),
                  const SizedBox(height: 7),
                  MyTextfield(
                    controller: emailController,
                    isObsecure: false,
                    textInputType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 23),
                  Text(
                    "Password",
                    style: TextStyle(color: Colour.fieldColor),
                  ),
                  const SizedBox(height: 7),
                  MyTextfield(
                    controller: passwordController,
                    isObsecure: !isChecked,
                    textInputType: TextInputType.visiblePassword,
                  ),
                  const SizedBox(height: 7),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Checkbox(
                            splashRadius: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            checkColor: Colour.backgroundColor,
                            value: isChecked,
                            onChanged: (bool? newValue) {
                              setState(() {
                                isChecked = newValue ?? false;
                              });
                            },
                          ),
                          InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () {
                                setState(() {
                                  isChecked = !isChecked;
                                });
                              },
                              child: const Text(" Show Password  ")),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 7.0),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            Navigation.push(context, const ForgotPassword());
                          },
                          child: const Text("  Forgot Password  "),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  GradientButton(
                    ontap: () async {
                      try {
                        // Sign in the user
                        UserCredential userCredential = await FirebaseAuth
                            .instance
                            .signInWithEmailAndPassword(
                          email: emailController.text,
                          password: passwordController.text,
                        );

                        // Check if email is verified
                        if (userCredential.user != null &&
                            userCredential.user!.emailVerified) {
                          // Navigate to Home Screen
                          Navigator.pushAndRemoveUntil<void>(
                            context,
                            MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                    const BottomNavigationScreen()),
                            ModalRoute.withName('/'),
                          );

                          String token = FirebaseAuth.instance.currentUser!.uid;

                          await FirebaseFirestore.instance
                              .collection(token)
                              .doc("Entertainment")
                              .set({
                            "Name": "Entertainment",
                            "IconCodePoint": Icons.movie_filter_outlined
                                .codePoint, // Save icon code point
                            "Budget": "1000",
                            "Color": Colour.box1.value,
                          });
                        } else {
                          // Show Snackbar asking the user to verify email
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Please verify your email to proceed.'),
                            ),
                          );
                        }
                      } on FirebaseAuthException catch (e) {
                        // Handle FirebaseAuth errors
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error: ${e.message}'),
                          ),
                        );
                      }
                    },
                    text: "Sign In",
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 5.2,
                  ),
                  Center(
                    child: Column(
                      children: [
                        const Text("If you don't have an account yet?"),
                        const SizedBox(height: 10),
                        DarkButton(
                          ontap: () => Navigation.push(
                            context,
                            const RegisterScreen(),
                          ),
                          text: "Sign Up",
                          buttonColor: Colour.greyButton,
                          borderColor: Colour.greyBorder,
                          size: 17,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
