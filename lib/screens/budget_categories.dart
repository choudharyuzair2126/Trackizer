import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trackizer/components/box2.dart';
import 'package:trackizer/components/navigation.dart';
import 'package:trackizer/screens/add_new_category.dart';
import 'package:trackizer/screens/edit_category.dart';
import 'package:trackizer/theme/color.dart';

class BudgetCategories extends StatelessWidget {
  const BudgetCategories({super.key});

  @override
  Widget build(BuildContext context) {
    final String token = FirebaseAuth.instance.currentUser?.uid ?? '';

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection(token).snapshots(),
      builder: (context, categorySnapshot) {
        if (categorySnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Handle case when category data is null or empty
        if (categorySnapshot.hasError) {
          return Center(child: Text("Error: ${categorySnapshot.error}"));
        }
        if (categorySnapshot.data == null ||
            categorySnapshot.data!.docs.isEmpty) {
          return Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("No categories available. Please add some."),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Navigation.push(
                    context,
                    AddNewCategories(token: token),
                  );
                },
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  color: Colour.greyBorder,
                  radius: const Radius.circular(20),
                  strokeWidth: 2,
                  dashPattern: const [4, 4],
                  child: const SizedBox(
                    width: double.infinity,
                    height: 70,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Add new category "),
                        Icon(
                          Icons.add_circle_outline_outlined,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
            ],
          ));
        }

        final categoryDocs = categorySnapshot.data!.docs;
        final categoryNames =
            categoryDocs.map((doc) => doc['Name'] as String).toList();

        // Limit to the first 10 categories
        final limitedCategoryNames = categoryNames.length > 10
            ? categoryNames.sublist(0, 10)
            : categoryNames;

        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("subs")
              .doc(token)
              .collection(token)
              .where('Category',
                  whereNotIn: limitedCategoryNames.isNotEmpty
                      ? limitedCategoryNames
                      : ['dummy']) // Workaround for Firestore whereNotIn
              .snapshots(),
          builder: (context, uncategorizedSnapshot) {
            if (uncategorizedSnapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            // Handle case when uncategorized data is null or empty
            if (uncategorizedSnapshot.hasError) {
              return Center(
                  child: Text("Error: ${uncategorizedSnapshot.error}"));
            }

            return ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.only(bottom: 20),
              children: [
                for (var categoryDoc in categoryDocs)
                  FutureBuilder<double>(
                    future: _calculateCategorySpend(token, categoryDoc['Name']),
                    builder: (context, spendSnapshot) {
                      final spend = spendSnapshot.data ?? 0.0;
                      final budget =
                          double.tryParse(categoryDoc['Budget'] ?? '0') ?? 0.0;
                      final iconCodePoint =
                          categoryDoc['IconCodePoint'] as int?;
                      int color = categoryDoc['Color'];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditCategory(
                                token: token,
                                name: categoryDoc['Name'],
                                budget: budget,
                                icon: IconData(
                                  iconCodePoint!,
                                  fontFamily: 'MaterialIcons',
                                ),
                                docName: categoryDoc.id,
                              ),
                            ),
                          ),
                          child: Box2(
                            text1: categoryDoc['Name'] as String,
                            text2:
                                "\$${(budget - spend).toStringAsFixed(2)} left to spend",
                            borderColor: Color(color),
                            icon: iconCodePoint != null
                                ? IconData(iconCodePoint,
                                    fontFamily: 'MaterialIcons')
                                : Icons.category,
                            total: "of \$${budget.toStringAsFixed(2)}",
                            spend: "\$${spend.toStringAsFixed(2)}",
                            value: budget > 0
                                ? (spend / budget)
                                : 0.0, // Prevent division by zero
                          ),
                        ),
                      );
                    },
                  ),
                if (categoryDocs.length < 10)
                  GestureDetector(
                    onTap: () {
                      Navigation.push(
                        context,
                        AddNewCategories(token: token),
                      );
                    },
                    child: DottedBorder(
                      borderType: BorderType.RRect,
                      color: Colour.greyBorder,
                      radius: const Radius.circular(20),
                      strokeWidth: 2,
                      dashPattern: const [4, 4],
                      child: const SizedBox(
                        width: double.infinity,
                        height: 70,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Add new category "),
                            Icon(
                              Icons.add_circle_outline_outlined,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 5),
              ],
            );
          },
        );
      },
    );
  }

  Future<double> _calculateCategorySpend(
      String token, String categoryName) async {
    final subsSnapshot = await FirebaseFirestore.instance
        .collection("subs")
        .doc(token)
        .collection(token)
        .where('Category', isEqualTo: categoryName)
        .get();

    double totalSpend = 0.0;

    for (var doc in subsSnapshot.docs) {
      final priceString =
          (doc['Price'] ?? '').toString().replaceAll(RegExp(r'[^\d.]'), '');
      totalSpend += double.tryParse(priceString) ?? 0.0;
    }

    return totalSpend;
  }
}
