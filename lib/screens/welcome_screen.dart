import 'package:flutter/material.dart';
import 'package:trackizer/components/dark_button.dart';
import 'package:trackizer/components/gradient_button.dart';
import 'package:trackizer/components/navigation.dart';
import 'package:trackizer/screens/login_screen.dart';
import 'package:trackizer/screens/register.dart';
import 'package:trackizer/theme/color.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  backgroundColor: Colors.black,
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 6, 6, 19),
        ),
        child: Stack(
          children: [
            Positioned(
              left: MediaQuery.of(context).size.width - 200,
              top: MediaQuery.of(context).size.height / 2 - 140,
              child: Container(
                width: 300,
                height: 300,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [
                    Color.fromARGB(124, 255, 120, 102),
                    Color.fromARGB(0, 253, 204, 132),
                  ], tileMode: TileMode.clamp),
                ),
              ),
            ),
            Positioned(
              left: MediaQuery.of(context).size.width - 113,
              top: MediaQuery.of(context).size.height / 2,
              child: Image.asset('assets/images/Image-2.png'),
            ),
            Column(
              children: [
                const SizedBox(
                  height: 100,
                ),
                RotatedBox(
                  quarterTurns: 4,
                  child: Image.asset(
                    "assets/images/1.png",
                    scale: 0.9,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 160,
                    ),
                    Image.asset('assets/images/icon.png'),
                    const SizedBox(
                      width: 7,
                    ),
                    const Text(
                      "TRACKIZER",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Image.asset('assets/images/Frame-1.png'),
                const Text(
                  "Welcome to the TRACKIZER to track your Expenses",
                  style: TextStyle(
                      //  color: Colors.white
                      ),
                ),
                const SizedBox(
                  height: 30,
                ),
                GradientButton(
                    ontap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterScreen()));
                    },
                    text: "Get Started"),
                const SizedBox(
                  height: 15,
                ),
                DarkButton(
                  ontap: () => Navigation.push(context, const LoginScreen()),
                  text: "I have an account",
                  buttonColor: Colour.greyBorder,
                  borderColor: Colour.greyBorder,
                  textColor: Colour.blackButton,
                  size: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
