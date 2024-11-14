import 'package:flutter/material.dart';
import 'package:trackizer/theme/color.dart';

class PasswordStrengthScreen extends StatefulWidget {
  final TextEditingController controller;
  const PasswordStrengthScreen({super.key, required this.controller});

  @override
  PasswordStrengthScreenState createState() => PasswordStrengthScreenState();
}

class PasswordStrengthScreenState extends State<PasswordStrengthScreen> {
  String password = '';
  double _strength = 0;
  Color _strengthColor = Colors.grey;

  // Function to calculate password strength
  void _checkPasswordStrength(String password) {
    setState(() {
      password = password;
      _strength = _calculateStrength(password);
      _strengthColor = _getStrengthColor(_strength);
    });
  }

  // Function to calculate the strength of the password
  double _calculateStrength(String password) {
    if (password.isEmpty) {
      return 0;
    } else if (password.length < 8) {
      return 0.25; // weak
    } else if (password.length < 11) {
      return 0.5; // moderate
    } else if (password.length >= 13 && _containsAllCriteria(password)) {
      return 1; // strong
    } else {
      return 0.75; // good
    }
  }

  // Check if password contains letters, numbers, and symbols
  bool _containsAllCriteria(String password) {
    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    bool hasDigits = password.contains(RegExp(r'[0-9]'));
    bool hasSpecialCharacters =
        password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    return hasUppercase && hasLowercase && hasDigits && hasSpecialCharacters;
  }

  // Function to change color based on password strength
  Color _getStrengthColor(double strength) {
    if (strength <= 0.25) {
      return Colors.red; // weak
    } else if (strength <= 0.5) {
      return Colors.orange; // moderate
    } else if (strength <= 0.75) {
      return Colors.yellow; // good
    } else {
      return Colors.green; // strong
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(
            controller: widget.controller,
            onChanged: _checkPasswordStrength,
            obscureText: true,
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colour.greyBorder,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colour.greyBorder,
                  ),
                  borderRadius: BorderRadius.circular(20),
                )),
          ),
          const SizedBox(height: 20),
          LinearProgressIndicator(
            borderRadius: BorderRadius.circular(20),
            value: _strength,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(_strengthColor),
            minHeight: 5,
          ),
          const SizedBox(height: 10),
          const Text(
            'Use 8 or more characters with a mix of letters, numbers & symbols.',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
