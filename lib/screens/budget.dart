// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trackizer/components/dark_button.dart';
import 'package:trackizer/components/my_textfield.dart';
import 'package:trackizer/theme/color.dart';

class BudgetScreen extends StatefulWidget {
  final double total;
  const BudgetScreen({super.key, required this.total});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  TextEditingController budgetController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getPreviousBudget();
  }

  _getPreviousBudget() async {
    String token = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot document =
        await FirebaseFirestore.instance.collection("Budget").doc(token).get();

    if (document.exists && document.data() != null) {
      // Check if the budget field is available and update the controller
      var data = document.data() as Map<String, dynamic>;
      budgetController.text = data["Budget"];
      debugPrint(budgetController.text);
    } else {
      budgetController.text = '2000';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyTextfield(
              controller: budgetController,
              isObsecure: false,
              textInputType: TextInputType.number,
              labelText: "Enter your total budget",
            ),
            const SizedBox(
              height: 20,
            ),
            DarkButton(
              ontap: () async {
                String token = FirebaseAuth.instance.currentUser!.uid;
                await FirebaseFirestore.instance
                    .collection("Budget")
                    .doc(token)
                    .set({"Budget": budgetController.text});
                Navigator.pop(context);
              },
              text: "Save",
              buttonColor: Colour.greyButton,
              borderColor: Colour.greyBorder,
              size: 24,
            )
          ],
        ),
      ),
    );
  }
}
