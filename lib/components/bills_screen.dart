import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BillsScreen extends StatefulWidget {
  const BillsScreen({super.key});

  @override
  State<BillsScreen> createState() => _BillsScreenState();
}

class _BillsScreenState extends State<BillsScreen> {
  List<Map<String, dynamic>> upcommingBills = []; // List to store the data

  @override
  void initState() {
    super.initState();
    getSubsData(); // Fetch data when the widget initializes
  }

  Future<void> getSubsData() async {
    String token = FirebaseAuth.instance.currentUser!.uid;

    // Fetch the data from Firestore
    var data = await FirebaseFirestore.instance
        .collection(token)
        .doc("upcommingBills")
        .get();

    if (data.exists) {
      // Assuming data['items'] is a list of maps
      List<dynamic> items = data['items'] ?? [];

      // Convert to a list of maps with type safety
      upcommingBills =
          items.map((item) => item as Map<String, dynamic>).toList();

      // Update the UI
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: upcommingBills.isEmpty
          ? const Center(
              child: Text("No Upcomming Bills "),
            )
          : ListView.builder(
              itemCount: upcommingBills.length,
              itemBuilder: (context, index) {
                var item = upcommingBills[index];
                return ListTile(
                  title: Text(item['name'] ?? 'No Name'),
                  subtitle: Text(item['description'] ?? 'No Description'),
                  onTap: () {
                    // Handle tap event, navigate to another screen, etc.
                  },
                );
              },
            ),
    );
  }
}
