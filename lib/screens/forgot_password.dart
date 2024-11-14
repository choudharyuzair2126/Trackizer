import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trackizer/components/gradient_button.dart';
import 'package:trackizer/components/my_textfield.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MyTextfield(
            controller: emailController,
            isObsecure: false,
            textInputType: TextInputType.emailAddress,
            hintText: "Enter Your Email",
          ),
          GradientButton(
              ontap: () async {
                await FirebaseAuth.instance
                    .sendPasswordResetEmail(email: emailController.text);
              },
              text: "Forgot Password")
        ],
      ),
    );
  }
}
