// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trackizer/components/gradient_button.dart';
import 'package:trackizer/components/my_textfield.dart';
import 'package:trackizer/components/navigation.dart';

class AddNewCategories extends StatefulWidget {
  final String token;
  const AddNewCategories({super.key, required this.token});

  @override
  AddNewCategoriesState createState() => AddNewCategoriesState();
}

class AddNewCategoriesState extends State<AddNewCategories> {
  final List<IconData> icons = [
    Icons.home,
    Icons.favorite,
    Icons.star,
    Icons.person,
    Icons.settings,
    Icons.shopping_cart,
    Icons.phone,
    Icons.camera_alt,
    Icons.pets,
    Icons.free_breakfast,
    CupertinoIcons.car,
    Icons.fingerprint_outlined,
    Icons.movie_filter_outlined,
  ];

  IconData? selectedIcon;
  TextEditingController nameController = TextEditingController();
  TextEditingController budgetController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Category"),
        automaticallyImplyLeading: true,
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            MyTextfield(
              controller: nameController,
              isObsecure: false,
              textInputType: TextInputType.text,
              labelText: "Enter category name",
              hintText: "Enter name of this category",
            ),
            const SizedBox(height: 20),
            MyTextfield(
              controller: budgetController,
              isObsecure: false,
              labelText: "Enter total budget",
              textInputType: TextInputType.number,
              hintText: "Enter total budget for this category",
            ),
            const SizedBox(height: 20),
            const Text(
              "Pick an icon for this category",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.27,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  mainAxisSpacing: 16.0,
                  crossAxisSpacing: 16.0,
                ),
                itemCount: icons.length,
                itemBuilder: (context, index) {
                  final icon = icons[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIcon = icon;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: selectedIcon == icon
                            ? Colors.blue[100]
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: selectedIcon == icon
                              ? Colors.blue
                              : Colors.transparent,
                          width: 2.0,
                        ),
                      ),
                      child: Icon(
                        icon,
                        color: selectedIcon == icon
                            ? Colors.blue
                            : Colors.grey[700],
                        size: 20,
                      ),
                    ),
                  );
                },
              ),
            ),
            const Expanded(child: SizedBox()),
            GradientButton(
              ontap: () async {
                if (selectedIcon == null) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Please select an icon."),
                  ));
                  return;
                }
                int getBrightRandomColor() {
                  Random random = Random();
                  int r = random.nextInt(106) +
                      150; // Ensure red is between 100 and 255
                  int g = random.nextInt(106) +
                      150; // Ensure green is between 100 and 255
                  int b = random.nextInt(106) +
                      150; // Ensure blue is between 100 and 255
                  return Color.fromARGB(255, r, g, b).value;
                }

                String token = FirebaseAuth.instance.currentUser!.uid;

                await FirebaseFirestore.instance
                    .collection(token)
                    .doc(nameController.text)
                    .set({
                  "Name": nameController.text,
                  "IconCodePoint":
                      selectedIcon!.codePoint, // Save icon code point
                  "Budget": budgetController.text,
                  "Color": getBrightRandomColor(),
                }).then(Navigation.pop(context));
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Category Added Successfully"),
                ));
              },
              text: "Add Category",
            ),
          ],
        ),
      ),
    );
  }
}
