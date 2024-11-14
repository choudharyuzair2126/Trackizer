// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trackizer/components/dark_button.dart';
import 'package:trackizer/components/gradient_button.dart';
import 'package:trackizer/components/my_textfield.dart';
import 'package:trackizer/components/navigation.dart';
import 'package:trackizer/components/pssword_strength.dart';
import 'package:trackizer/components/trackizer.dart';
import 'package:trackizer/screens/login_screen.dart';
import 'package:trackizer/theme/color.dart';

class EmailRegistration extends StatelessWidget {
  const EmailRegistration({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

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
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        height: keyboardHeight > 0
                            ? 70
                            : MediaQuery.of(context).size.height / 4.7),
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
                    SizedBox(
                      height: 140,
                      child: PasswordStrengthScreen(
                        controller: passwordController,
                      ),
                    ),
                    const SizedBox(height: 25),
                    GradientButton(
                      ontap: () async {
                        try {
                          // Attempt to create a new user
                          UserCredential userCredential = await FirebaseAuth
                              .instance
                              .createUserWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text,
                          );

                          // Send email verification
                          await userCredential.user?.sendEmailVerification();

                          // Show Snackbar to prompt email verification
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Verify your email to complete registration.'),
                            ),
                          );

                          // Navigate to LoginScreen after showing the Snackbar
                          await Future.delayed(const Duration(seconds: 1));
                          Navigation.push(context, const LoginScreen());
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'email-already-in-use') {
                            // Show Snackbar if email is already in use
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'This email is already registered. Please sign in.'),
                              ),
                            );
                          } else {
                            // Show Snackbar for other errors
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error: ${e.message}'),
                              ),
                            );
                          }
                        }
                      },
                      text: "Get started, it's free!",
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 7,
                    ),
                    Center(
                      child: Column(
                        children: [
                          const Text("Do you have already an account?"),
                          const SizedBox(
                            height: 10,
                          ),
                          DarkButton(
                              ontap: () =>
                                  Navigation.push(context, const LoginScreen()),
                              text: "Sign In",
                              buttonColor: Colour.greyButton,
                              borderColor: Colour.greyBorder,
                              size: 17)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
