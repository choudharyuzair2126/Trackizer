import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trackizer/screens/budget_categories.dart';
import 'package:trackizer/components/navigation.dart';
import 'package:trackizer/components/track.dart';
import 'package:trackizer/screens/settings.dart';
import 'package:trackizer/theme/color.dart';

class SpendingsAndBudgets extends StatefulWidget {
  const SpendingsAndBudgets({super.key});

  @override
  State<SpendingsAndBudgets> createState() => _SpendingsAndBudgetsState();
}

class _SpendingsAndBudgetsState extends State<SpendingsAndBudgets> {
  String? token;

  @override
  void initState() {
    super.initState();
    token = FirebaseAuth.instance.currentUser!.uid;
    getBudget();
  }

  var budget;
  getBudget() async {
    budget =
        await FirebaseFirestore.instance.collection("Budget").doc(token).get();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    double totalPrice = 0.0; // New variable to store total price

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("subs")
              .doc(token!)
              .collection(token!)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasData) {
              final docs = snapshot.data!.docs;

              // Extract prices, parse them as doubles, and calculate the total
              final prices = docs.map((doc) {
                final priceString =
                    (doc['Price'] as String).replaceAll(RegExp(r'[^\d.]'), '');
                return double.tryParse(priceString) ?? 0.0;
              }).toList();

              totalPrice = prices.fold(
                  0.0,
                  (priceSum, price) =>
                      priceSum + price); // Calculate total price
            }

            return Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.43,
                  child: Stack(
                    children: [
                      const Positioned(
                        top: 20,
                        left: 0,
                        right: 0,
                        child: Track(),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Spending & Budgets",
                            style: TextStyle(
                                fontSize:
                                    screenWidth * 0.04, // Responsive font size
                                fontWeight: FontWeight.w400,
                                color: Colour.grey30),
                          ),
                          SizedBox(
                            width: screenWidth * 0.2,
                          ),
                          IconButton(
                            icon: const Icon(Icons.settings),
                            onPressed: () {
                              Navigation.push(context, const SettingsScreen());
                            },
                          ),
                          const SizedBox(
                            width: 4,
                          )
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              "\$ $totalPrice",
                              style: TextStyle(
                                fontSize:
                                    screenWidth * 0.07, // Responsive font size
                                fontWeight: FontWeight.bold,
                                color: Colour.whiteButton,
                              ),
                            ),
                          ),
                          StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection("Budget")
                                  .doc(token)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                return Text(
                                  snapshot.hasData
                                      ? "of \$${snapshot.data!.get('Budget')} budget"
                                      : "of \$2000 budget",
                                  style: TextStyle(
                                    fontSize: screenWidth *
                                        0.04, // Responsive font size
                                    fontWeight: FontWeight.bold,
                                    color: Colour.whiteButton,
                                  ),
                                );
                              }),
                        ],
                      ),
                      Positioned(
                        bottom: 1,
                        top: screenHeight * 0.35,
                        left: 18,
                        right: 18,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.20,
                            vertical: screenHeight * 0.025,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colour.greyBorder),
                          ),
                          child: const Text("Your budgets are on track 👍"),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Expanded(
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 18),
                        child: BudgetCategories())),
              ],
            );
          }),
    );
  }
}
