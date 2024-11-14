import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trackizer/components/box.dart';
import 'package:trackizer/components/dark_button.dart';
import 'package:trackizer/components/navigation.dart';
import 'package:trackizer/components/trackizer.dart';
import 'package:trackizer/components/bills_screen.dart';
import 'package:trackizer/components/subs_screen.dart';
import 'package:trackizer/screens/budget.dart';
import 'package:trackizer/screens/settings.dart';
import 'package:trackizer/theme/color.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  bool isSubscriptionsSelected = true;
  double valueNotifier = 0;
  String? token;
  int numSubscriptions = 0;
  double lowestPrice = double.infinity;
  double highestPrice = 0.0;
  double totalPrice = 0.0; // New variable to store total price
  double budget = 0.0;

  @override
  void initState() {
    super.initState();
    token = FirebaseAuth.instance.currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
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
                numSubscriptions = docs.length;

                if (numSubscriptions > 0) {
                  // Extract prices, parse them as doubles, and calculate the total
                  final prices = docs.map((doc) {
                    final priceString = (doc['Price'] as String)
                        .replaceAll(RegExp(r'[^\d.]'), '');
                    return double.tryParse(priceString) ?? 0.0;
                  }).toList();

                  lowestPrice = prices.reduce((a, b) => a < b ? a : b);
                  highestPrice = prices.reduce((a, b) => a > b ? a : b);
                  totalPrice = prices.fold(
                      0.0,
                      (priceSum, price) =>
                          priceSum + price); // Calculate total price

                  var budget1 = totalPrice < budget ? budget : totalPrice;
                  valueNotifier = (totalPrice / budget1) * 100;
                } else {
                  lowestPrice = 0.0;
                  highestPrice = 0.0;
                  totalPrice = 0.0;
                }
              } else {
                numSubscriptions = 0;
                lowestPrice = 0.0;
                highestPrice = 0.0;
                totalPrice = 0.0;
              }

              return Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height / 2.13,
                        child: Stack(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height / 2.13,
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("assets/images/circle.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Center(
                              heightFactor: 1.25,
                              child: SizedBox(
                                height: 300,
                                child: StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection("Budget")
                                        .doc(token)
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      budget = (snapshot.hasData
                                          ? double.tryParse(
                                              snapshot.data!.get("Budget"))
                                          : 0.0)!;

                                      var b1 = totalPrice < budget
                                          ? budget
                                          : totalPrice;
                                      valueNotifier = (totalPrice / b1) * 100;
                                      return DashedCircularProgressBar
                                          .aspectRatio(
                                        aspectRatio: 01,
                                        progress: valueNotifier,
                                        maxProgress: 100,
                                        startAngle: 225,
                                        sweepAngle: 270,
                                        foregroundColor: budget <= totalPrice
                                            ? Colour.red
                                            : Colour.progressColor,
                                        backgroundColor: Colour.greyButton,
                                        foregroundStrokeWidth: 15,
                                        backgroundStrokeWidth: 15,
                                        animation: true,
                                        seekSize: 4,
                                        seekColor: const Color(0xffeeeeee),
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const SizedBox(height: 50),
                                              const Trackizer(
                                                  fontSize: 18, width: 6),
                                              const SizedBox(height: 20),
                                              Text(
                                                "\$${totalPrice.toStringAsFixed(2)}",
                                                style: const TextStyle(
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Text(
                                                "Total subscriptions",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colour.textColor,
                                                ),
                                              ),
                                              const SizedBox(height: 30),
                                              SizedBox(
                                                width: 150,
                                                height: 45,
                                                child: DarkButton(
                                                  ontap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                BudgetScreen(
                                                                  total:
                                                                      totalPrice,
                                                                )));
                                                  },
                                                  text: "See your budget",
                                                  buttonColor:
                                                      Colour.greyButton,
                                                  borderColor:
                                                      Colour.greyBorder,
                                                  size: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            ),
                            Positioned(
                              top: 40,
                              right: 20,
                              child: IconButton(
                                onPressed: () {
                                  Navigation.push(
                                      context, const SettingsScreen());
                                },
                                icon: const Icon(
                                  Icons.settings,
                                  size: 29,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colour.homeBackgroundColor,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(24),
                            bottomRight: Radius.circular(24),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 14,
                    left: 0,
                    right: 0,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Box(
                          text1: "Active subs",
                          text2: numSubscriptions.toString(),
                          borderColor: Colour.box1,
                        ),
                        Box(
                          text1: "Highest subs",
                          text2: "\$${highestPrice.toStringAsFixed(2)}",
                          borderColor: Colour.box2,
                        ),
                        Box(
                          text1: "Lowest subs",
                          text2: "\$${lowestPrice.toStringAsFixed(2)}",
                          borderColor: Colour.box3,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(22.0),
            child: Container(
              height: 53,
              decoration: BoxDecoration(
                color: Colour.blackButton,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              isSubscriptionsSelected = true;
                            });
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: isSubscriptionsSelected
                                ? Colors.grey.shade800
                                : Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            "Your subscriptions",
                            style: TextStyle(
                              color: isSubscriptionsSelected
                                  ? Colors.white
                                  : Colour.grey30,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              isSubscriptionsSelected = false;
                            });
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: !isSubscriptionsSelected
                                ? Colors.grey.shade800
                                : Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            "Upcoming bills",
                            style: TextStyle(
                              color: !isSubscriptionsSelected
                                  ? Colors.white
                                  : Colour.grey30,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: isSubscriptionsSelected
                ? const SubsScreen()
                : const BillsScreen(),
          ),
        ],
      ),
    );
  }
}
