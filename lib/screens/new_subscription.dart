// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trackizer/components/gradient_button.dart';
import 'package:trackizer/components/my_textfield.dart';
import 'package:trackizer/components/navigation.dart';
import 'package:trackizer/theme/color.dart';

class NewSubscription extends StatefulWidget {
  const NewSubscription({super.key});

  @override
  NewSubscriptionState createState() => NewSubscriptionState();
}

class NewSubscriptionState extends State<NewSubscription> {
  PageController pageController = PageController(viewportFraction: 0.5);
  String sign = r"$ ";
  int price = 500; // Default price
  String? image;
  String? text;

  // List of images and text data
  final List<String> _images = [
    "assets/images/netflix (1).png",
    "assets/images/spotify.png",
    "assets/images/office.png",
    "assets/images/youtube (1).png",
    "assets/images/hbo (1).png",
    "assets/images/video.png",
    "assets/images/apple-tv.png",
    "assets/images/office.png",
    "assets/images/youtube (1).png",
    "assets/images/hbo (1).png",
    "assets/images/netflix (1).png",
    "assets/images/spotify.png",
    "assets/images/office.png",
    "assets/images/youtube (1).png",
    "assets/images/hbo (1).png",
  ];

  final List<String> _textData = [
    "Netflix ",
    "Spotify ",
    "OneDrive ",
    "YouTube ",
    "HBO GO ",
    "Amazo Video ",
    "Apple TV ",
    "One Drive ",
    "YouTube ",
    "HBO GO ",
    "Netflix ",
    "Spotify ",
    "OneDrive ",
    "YouTube ",
    "HBO GO ",
  ];

  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  int currentIndex = 0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
    // Adding listener to PageController to get the centered page index
    pageController.addListener(() {
      currentIndex = pageController.page!.round();
      //  print('Current Index: $currentIndex');
    });

    priceController.text = sign + (price / 100).toStringAsFixed(2);
  }

  @override
  void dispose() {
    pageController.dispose(); // Dispose the controller to avoid memory leaks
    super.dispose();
  }

  void increasePrice() {
    setState(() {
      price += 50;
      priceController.text = sign + (price / 100).toStringAsFixed(2);
    });
  }

  void decreasePrice() {
    setState(() {
      if (price > 50) {
        price -= 50;
      }
      priceController.text = sign + (price / 100).toStringAsFixed(2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colour.linear2,
        leading: IconButton(
          icon: const Icon(
            CupertinoIcons.back,
            size: 30,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'New Subscription',
          style: TextStyle(fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.46,
              decoration: BoxDecoration(
                color: Colour.linear2,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    "Add New",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    "Subscription",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 37),
                  ////////////////////////Swipeable Pictures And Text ///////////////////////////
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.28,
                    child: PageView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: pageController,
                      itemCount: _images.length + 1,
                      itemBuilder: (context, index) {
                        return AnimatedBuilder(
                          animation: pageController,
                          builder: (context, child) {
                            double scale = 0.4;
                            if (pageController.position.haveDimensions) {
                              double currentPage = pageController.page ??
                                  pageController.initialPage.toDouble();
                              double distance = (currentPage - index).abs();
                              scale = (1 - (distance * 0.3)).clamp(0.4, 1.0);
                            }
                            int index1 =
                                index < _images.length ? index : index - 1;
                            image = _images[index1];
                            text = _textData[index1];
                            //   print(currentIndex);
                            return Transform.scale(
                              scale: scale,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      index > index1
                                          ? InkWell(
                                              onTap: () {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                        const SnackBar(
                                                            content:
                                                                Text("data")));
                                              },
                                              child: Container(
                                                height: Curves.easeOut
                                                        .transform(scale) *
                                                    170,
                                                width: Curves.easeOut
                                                        .transform(scale) *
                                                    170,
                                                decoration: const BoxDecoration(
                                                  image: DecorationImage(
                                                    image: AssetImage(
                                                        "assets/images/add.png"),
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Container(
                                              height: Curves.easeOut
                                                      .transform(scale) *
                                                  170,
                                              width: Curves.easeOut
                                                      .transform(scale) *
                                                  170,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: AssetImage(image!),
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                      const SizedBox(height: 15),
                                      SizedBox(
                                        width: Curves.easeOut.transform(scale) *
                                            190,
                                        child: Text(
                                          textAlign: TextAlign.center,
                                          index > index1
                                              ? "Add New Item"
                                              : text!,
                                          maxLines: 1,
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            color: Colour.white,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Description",
              style: TextStyle(
                color: Colour.gray50,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: MyTextfield(
                controller: descriptionController,
                isObsecure: false,
                textInputType: TextInputType.text,
              ),
            ),
            const SizedBox(height: 50),
            const Text("Monthly Price"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Minus Button
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colour.greyButton,
                      border: Border.all(color: Colour.greyBorder),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: IconButton(
                        onPressed: decreasePrice,
                        icon: const Icon(CupertinoIcons.minus),
                      ),
                    ),
                  ),
                  // Price TextField
                  GestureDetector(
                    onHorizontalDragUpdate: (details) {
                      setState(() {
                        if (details.delta.dx > 0) {
                          price += 100;
                        } else if (details.delta.dx < 0 && price > 1000) {
                          price -= 100;
                        }
                        priceController.text =
                            sign + (price / 100).toStringAsFixed(2);
                      });
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: TextField(
                        controller: priceController,
                        enableInteractiveSelection: false,
                        readOnly: true,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colour.greyBorder,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colour.greyBorder,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Plus Button
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colour.greyButton,
                      border: Border.all(color: Colour.greyBorder),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: IconButton(
                        onPressed: increasePrice,
                        icon: const Icon(CupertinoIcons.plus),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.06,
            ),
            GradientButton(
                ontap: () async {
                  String token = FirebaseAuth.instance.currentUser!.uid;

                  await FirebaseFirestore.instance
                      .collection(token)
                      .doc("Entertainment")
                      .set({
                    "Name": "Entertainment",
                    "IconCodePoint": Icons.error_outline_outlined
                        .codePoint, // Save icon code point
                    "Budget": "1000",
                    "Color": Colour.box1.value,
                  });

                  await FirebaseFirestore.instance
                      .collection("subs")
                      .doc(token)
                      .collection(token)
                      .doc(_textData[
                          currentIndex]) // Use the updated name as the document ID
                      .set({
                    "Name": _textData[currentIndex],
                    "Image": _images[currentIndex],
                    "Price": priceController.text,
                    "Description": descriptionController.text,
                    "Category": "Entertainment",
                    "First Payment":
                        "${DateTime.now().day.toString().padLeft(2, '0')}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().year}",
                  }).then(Navigation.pop(
                    context,
                  ));
                },
                text: "Add this platform"),
          ],
        ),
      ),
    );
  }
}
