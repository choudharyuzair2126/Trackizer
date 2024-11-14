import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trackizer/components/navigation.dart';
import 'package:trackizer/screens/subs_info.dart';

class SubsScreen extends StatefulWidget {
  const SubsScreen({super.key});

  @override
  SubsScreenState createState() => SubsScreenState();
}

class SubsScreenState extends State<SubsScreen> {
  String? token;

  @override
  void initState() {
    super.initState();
    token = FirebaseAuth.instance.currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("subs")
            .doc(token!)
            .collection(token!)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return snapshot.data!.docs.isEmpty
              ? const Center(
                  child: Text("No Subscriptions"),
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 8),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var subscription = snapshot.data!.docs[index];
                    String id = subscription.id;

                    // Using containsKey to check for fields
                    String name = subscription.data().containsKey('Name')
                        ? subscription['Name']
                        : 'No Name';
                    String image = subscription.data().containsKey('Image')
                        ? subscription['Image']
                        : 'assets/images/default.png';
                    String price = subscription.data().containsKey('Price')
                        ? subscription['Price']
                        : 'No Price';
                    String category =
                        subscription.data().containsKey('Category')
                            ? subscription['Category']
                            : 'Uncategorized';

                    return Dismissible(
                      key: Key(id),
                      direction: DismissDirection.horizontal,
                      background: Container(
                        color: Colors.blue,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 20),
                        child: const Icon(Icons.edit, color: Colors.white),
                      ),
                      secondaryBackground: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      confirmDismiss: (direction) async {
                        if (direction == DismissDirection.startToEnd) {
                          // Swipe right: Navigate to edit without dismissing
                          Navigation.push(
                            context,
                            SubsInfo(
                              title: name,
                              subscription: subscription,
                            ),
                          );
                          return false; // Prevent dismissal
                        } else if (direction == DismissDirection.endToStart) {
                          // Swipe left: Confirm deletion
                          final confirmDelete = await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Delete $name?'),
                              content: const Text(
                                  'Are you sure you want to delete this subscription?'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );
                          return confirmDelete == true;
                        }
                        return false;
                      },
                      onDismissed: (direction) {
                        if (direction == DismissDirection.endToStart) {
                          // Delete item from Firestore
                          FirebaseFirestore.instance
                              .collection("subs")
                              .doc(token!)
                              .collection(token!)
                              .doc(id)
                              .delete();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('$name deleted')),
                          );
                        }
                      },
                      child: ListTile(
                        title: Text(
                          name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        leading: Image.asset(
                          image,
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                        ),
                        trailing: Text(
                          price,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        subtitle: Text(
                          category,
                          style: const TextStyle(fontSize: 14),
                        ),
                        onTap: () {
                          Navigation.push(
                            context,
                            SubsInfo(
                              title: name,
                              subscription: subscription,
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
