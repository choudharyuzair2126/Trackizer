import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:trackizer/components/cards.dart';
import 'package:trackizer/components/container.dart';
import 'package:trackizer/components/navigation.dart';
import 'package:trackizer/screens/add_card.dart';
import 'package:trackizer/screens/settings.dart';
import 'package:trackizer/theme/color.dart';

class CreditCards extends StatefulWidget {
  const CreditCards({super.key});

  @override
  State<CreditCards> createState() => _CreditCardsState();
}

class _CreditCardsState extends State<CreditCards> {
  String? token;

  @override
  void initState() {
    super.initState();
    token = FirebaseAuth.instance.currentUser?.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.755,
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("Cards")
                  .doc(token)
                  .collection(token!)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text("Something went wrong"));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("No Card Added Yet. Add a Card to start"),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text("Credit Cards"),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.28),
                        IconButton(
                          onPressed: () {
                            Navigation.push(context, const SettingsScreen());
                          },
                          icon: const Icon(Icons.settings_outlined),
                        ),
                      ],
                    ),
                    Center(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.47,
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: CardSwiper(
                          numberOfCardsDisplayed: snapshot.data!.docs.length > 4
                              ? 4
                              : snapshot.data!.docs.length,
                          backCardOffset: const Offset(30, 1),
                          cardsCount: snapshot.data!.docs.length,
                          cardBuilder: (context, index, _, __) {
                            var card = snapshot.data!.docs[index];
                            return Cards(cards: card);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      "Subscriptions",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ImageContainer(image: "assets/images/netflix (1).png"),
                        ImageContainer(image: "assets/images/spotify.png"),
                        ImageContainer(image: "assets/images/youtube (1).png"),
                        ImageContainer(image: "assets/images/hbo (1).png"),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                );
              },
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 30,
                bottom: MediaQuery.of(context).size.height * 0.08,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colour.linear2,
                    Colour.backgroundColor,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddNewCard()),
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
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Add new card ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17),
                        ),
                        Icon(
                          Icons.add_circle_outline_outlined,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
