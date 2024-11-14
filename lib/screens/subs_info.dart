import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trackizer/components/dark_button.dart';
import 'package:trackizer/components/sub_info_row.dart';
import 'package:trackizer/theme/color.dart';

class SubsInfo extends StatefulWidget {
  // final String image;
  final String title;
  // final String price;
  // final String description;
  // final String category;
  // final String firstPaymnet;
  // ignore: prefer_typing_uninitialized_variables
  final subscription;

  const SubsInfo({
    super.key,
    // required this.image,
    required this.title,
    // required this.price,
    // required this.description,
    // required this.category,
    // required this.firstPaymnet,
    required this.subscription,
  });

  @override
  State<SubsInfo> createState() => _SubsInfoState();
}

class _SubsInfoState extends State<SubsInfo> {
  DateTime selectedDate = DateTime.now();
  String name = '';
  String description = '';
  String? token;
  String? category;
  @override
  void initState() {
    super.initState();
    name = widget.title;
    category = widget.subscription['Category']; // Initial category

    description = widget.subscription['Description'];
    token = FirebaseAuth.instance.currentUser!.uid;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _showTextFieldDialog(
      BuildContext context, String field, String initialValue) async {
    String updatedValue = initialValue;
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return AlertDialog(
              title: Text('Edit $field'),
              content: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: constraints.maxHeight * 0.5,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        maxLines: 3,
                        minLines: 1,
                        autofocus: true,
                        controller: TextEditingController(text: initialValue),
                        onChanged: (value) {
                          updatedValue = value;
                        },
                        decoration: InputDecoration(
                          hintMaxLines: 3,
                          labelText: field,
                          labelStyle: TextStyle(color: Colour.grey30),
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child:
                      const Text('Cancel', style: TextStyle(color: Colors.red)),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (field == 'Name') {
                        name = updatedValue;
                      } else if (field == 'Description') {
                        description = updatedValue;
                      }
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showCategoryMenu() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colour.greyShade,
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection(token!).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final categories = snapshot.data?.docs ?? [];
                if (categories.isNotEmpty) {
                  return ListView(
                    shrinkWrap: true,
                    children: [
                      // Display custom categories from Firebase
                      for (var categoryDoc in categories)
                        ListTile(
                          title:
                              Text(categoryDoc['Name'] ?? 'Unknown Category'),
                          onTap: () {
                            setState(() {
                              category = categoryDoc['Name'];
                            });
                            Navigator.pop(context);
                          },
                        ),
                    ],
                  );
                } else {
                  return const Text('No Category was added yet');
                }
              }),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 23),
            ClipPath(
              clipper: BottomEdgeClipper(),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: BoxDecoration(
                  color: Colour.linear2,
                  borderRadius: const BorderRadius.horizontal(
                    right: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colour.grey30,
                            ),
                          ),
                          Text(
                            "Subscription info",
                            style: TextStyle(
                              color: Colour.grey30,
                              fontSize: 20,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection("subs")
                                  .doc(token)
                                  .collection(token!)
                                  .doc(name)
                                  .delete();
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              CupertinoIcons.delete,
                              color: Colour.grey30,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.15,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(widget.subscription['Image']))),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          color: Colour.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    Text(
                      widget.subscription['Price'],
                      style: TextStyle(
                        color: Colour.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            DottedLine(
              dashColor: Colour.linear2,
              lineThickness: 2,
              dashGapLength: 8,
              dashLength: 8,
              lineLength: MediaQuery.of(context).size.width - 80,
            ),
            Expanded(
              child: ClipPath(
                clipper: TopEdgeClipper(),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colour.greyShade,
                    borderRadius: const BorderRadius.horizontal(
                      right: Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          width: 2,
                          color: Colour.greyBorder,
                        ),
                        color: Colour.linear3,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SubInfoRow(
                            leftText: "Name",
                            rightText: name,
                            action: () =>
                                _showTextFieldDialog(context, "Name", name),
                          ),
                          SubInfoRow(
                            leftText: "Description",
                            rightText: description,
                            action: () => _showTextFieldDialog(
                                context, "Description", description),
                          ),
                          SubInfoRow(
                            leftText: "Category",
                            rightText: category!,
                            action: () => _showCategoryMenu(),
                          ),
                          SubInfoRow(
                            leftText: "First Payment",
                            rightText:
                                "${selectedDate.toLocal()}".split(' ')[0],
                            action: () {
                              _selectDate(context);
                            },
                          ),
                          SubInfoRow(
                            leftText: "Reminder",
                            rightText: "Never",
                            action: () {},
                          ),
                          SubInfoRow(
                            leftText: "Currency",
                            rightText: "USD (\$)",
                            action: () {},
                          ),
                          DarkButton(
                            ontap: () async {
                              String oldName = widget.subscription['Name'];

                              // Reference to the subscription document in Firestore
                              var subscriptionDocRef = FirebaseFirestore
                                  .instance
                                  .collection("subs")
                                  .doc(token!)
                                  .collection(token!)
                                  .doc(oldName);

                              // If the name has changed, delete the old document and create a new one
                              if (name != oldName) {
                                // Delete the old document
                                await subscriptionDocRef.delete();

                                // Create a new document with the updated name
                                await FirebaseFirestore.instance
                                    .collection("subs")
                                    .doc(token!)
                                    .collection(token!)
                                    .doc(
                                        name) // Use the updated name as the document ID
                                    .set({
                                  "Name": name,
                                  "Image": widget.subscription['Image'],
                                  "Price": widget.subscription['Price'],
                                  "Description": description,
                                  "Category": category,
                                  "First Payment":
                                      "${selectedDate.day.toString().padLeft(2, '0')}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.year}",
                                });
                              } else {
                                // If the name hasn't changed, simply update the existing document
                                await subscriptionDocRef.update({
                                  "Name": name,
                                  "Image": widget.subscription['Image'],
                                  "Price": widget.subscription['Price'],
                                  "Description": description,
                                  "Category": category,
                                  "First Payment":
                                      "${selectedDate.day.toString().padLeft(2, '0')}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.year}",
                                });
                              }

                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                duration: Duration(milliseconds: 700),
                                content: Text(
                                    "Subscription Info Updated Successfully"),
                              ));

                              Timer(const Duration(milliseconds: 200),
                                  () => Navigator.pop(context));
                            },
                            text: "Save",
                            buttonColor: Colour.greyButton,
                            borderColor: Colour.greyBorder,
                            size: 18,
                            textColor: Colour.white,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomEdgeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    double cutoutRadius = 20.0;

    path.moveTo(0, 20);
    path.arcToPoint(const Offset(20, 0), radius: const Radius.circular(20));
    path.lineTo(size.width - 20, 0);
    path.arcToPoint(Offset(size.width, 20), radius: const Radius.circular(20));
    path.lineTo(size.width, size.height - cutoutRadius);
    path.arcToPoint(
      Offset(size.width - cutoutRadius, size.height),
      radius: Radius.circular(cutoutRadius),
      clockwise: false,
    );
    path.lineTo(cutoutRadius, size.height);
    path.arcToPoint(
      Offset(0, size.height - cutoutRadius),
      radius: Radius.circular(cutoutRadius),
      clockwise: false,
    );
    path.lineTo(0, 20);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class TopEdgeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    double cornerRadius = 20.0;

    path.moveTo(0, size.height - cornerRadius);
    path.arcToPoint(
      Offset(cornerRadius, size.height),
      radius: Radius.circular(cornerRadius),
      clockwise: false,
    );
    path.lineTo(size.width - cornerRadius, size.height);
    path.arcToPoint(
      Offset(size.width, size.height - cornerRadius),
      radius: Radius.circular(cornerRadius),
      clockwise: false,
    );
    path.lineTo(size.width, cornerRadius);
    path.arcToPoint(
      Offset(size.width - cornerRadius, 0),
      radius: Radius.circular(cornerRadius),
      clockwise: true,
    );
    path.lineTo(cornerRadius, 0);
    path.arcToPoint(
      Offset(0, cornerRadius),
      radius: Radius.circular(cornerRadius),
      clockwise: true,
    );
    path.lineTo(0, size.height - cornerRadius);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
