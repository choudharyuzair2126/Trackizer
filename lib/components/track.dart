import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geekyants_flutter_gauges/geekyants_flutter_gauges.dart';
import 'package:trackizer/theme/color.dart';

class Track extends StatefulWidget {
  const Track({super.key});

  @override
  State<Track> createState() => _TrackState();
}

class _TrackState extends State<Track> {
  List<RadialValueBar> track = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? token;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    // Retrieve token first and then fetch budget data
    setState(() {
      token = FirebaseAuth.instance.currentUser?.uid;
    });
    if (token != null) {
      await _fetchBudgetData();
    }
  }

  Future<void> _fetchBudgetData() async {
    try {
      // Fetch all categories to get total budget for each
      QuerySnapshot categorySnapshot =
          await _firestore.collection(token!).get();
      List<RadialValueBar> newTrack = [];

      for (var categoryDoc in categorySnapshot.docs) {
        String name = categoryDoc['Name'];
        String budgetStr = categoryDoc['Budget'];
        int color = categoryDoc['Color'];

        double totalBudget = double.tryParse(budgetStr) ?? 0.0;

        QuerySnapshot subsSnapshot = await _firestore
            .collection('subs')
            .doc(token)
            .collection(token!)
            .where('Category', isEqualTo: name)
            .get();

        double spentBudget = subsSnapshot.docs.fold(
          0.0,
          // ignore: avoid_types_as_parameter_names
          (sum, doc) {
            // Clean up the price string
            String priceStr = doc['Price'] ?? '0';
            priceStr = priceStr.replaceAll(
                RegExp(r'[^0-9.]'), ''); // Remove non-numeric characters
            return sum + (double.tryParse(priceStr) ?? 0.0);
          },
        );

        // Calculate the spending percentage
        double value =
            (totalBudget > 0) ? (spentBudget / totalBudget) * 100 : 0;

        // Create a RadialValueBar for this category with a bright random color
        newTrack.add(
          RadialValueBar(
            value: value >= 100
                ? 100
                : value == 0
                    ? 0.5
                    : value,
            color: Color(color), // Assign a bright random color
            radialOffset: newTrack.length < 2
                ? 10 - newTrack.length * 10
                : newTrack.length * 10,
            valueBarThickness: 5,
          ),
        );
      }

      setState(() {
        track = newTrack;
      });
    } catch (e) {
      debugPrint("Error fetching data: $e");
    }
  }

  // Function to generate a bright random color

  @override
  Widget build(BuildContext context) {
    return RadialGauge(
      valueBar: track,
      radiusFactor: 0.9,
      track: RadialTrack(
        start: 0,
        end: 100,
        thickness: 7,
        hideLabels: true,
        color: Colors.transparent,
        steps: 100,
        trackStyle: TrackStyle(
          primaryRulersHeight: 0,
          secondaryRulersHeight: 0,
          primaryRulerColor: Colour.backgroundColor,
          secondaryRulerColor: Colour.backgroundColor,
          showLabel: false,
        ),
      ),
    );
  }
}
