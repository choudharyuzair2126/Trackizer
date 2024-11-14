// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:trackizer/theme/color.dart';
import 'package:u_credit_card/u_credit_card.dart';
import 'package:flutter/material.dart';

class AddNewCard extends StatefulWidget {
  const AddNewCard({super.key});

  @override
  AddNewCardState createState() => AddNewCardState();
}

class AddNewCardState extends State<AddNewCard> {
  final TextEditingController numberController = TextEditingController();
  final TextEditingController cardHolderController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();
  final TextEditingController validFromController = TextEditingController();
  final TextEditingController validTillController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    numberController.addListener(() => setState(() {}));
    cardHolderController.addListener(() => setState(() {}));
    cvvController.addListener(() => setState(() {}));
    validFromController.addListener(() => setState(() {}));
    validTillController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    numberController.dispose();
    cardHolderController.dispose();
    cvvController.dispose();
    validFromController.dispose();
    validTillController.dispose();
    super.dispose();
  }

  // Helper function to validate date format MM/YY
  bool isValidDateFormat(String date) {
    if (date.length != 5 || !date.contains('/')) return false;
    final parts = date.split('/');
    final month = int.tryParse(parts[0]) ?? 0;
    final year = int.tryParse(parts[1]) ?? 0;
    return month > 0 && month <= 12 && year >= 0;
  }

  // Helper function to check if "Valid From" is less than the current date
  bool isValidFromDate(String date) {
    if (!isValidDateFormat(date)) return false;
    final parts = date.split('/');
    final month = int.parse(parts[0]);
    final year = int.parse('20${parts[1]}'); // Assuming it's a 2-digit year
    final validFromDate = DateTime(year, month);
    return validFromDate.isBefore(DateTime.now());
  }

  // Helper function to check if "Valid Till" is after the current date
  bool isValidTillDate(String date) {
    if (!isValidDateFormat(date)) return false;
    final now = DateTime.now();
    final parts = date.split('/');
    final month = int.parse(parts[0]);
    final year = int.parse('20${parts[1]}'); // Assuming it's a 2-digit year
    final validTillDate = DateTime(year, month);
    return validTillDate.isAfter(now);
  }

  // Date input formatter for MM/YY format
  final DateInputFormatter _dateInputFormatter = DateInputFormatter();

  CardType cardType = CardType.other;

  String? selectedType;

  String? cardProvider;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 15),

                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(CupertinoIcons.back),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.25,
                    ),
                    const Text(
                      "Add new card",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    )
                  ],
                ),

                // Credit Card UI updates as you type in the fields
                CreditCardUi(
                  disableHapticFeedBack: false,
                  cardHolderFullName: cardHolderController.text.isEmpty
                      ? 'Card Holder Name'
                      : cardHolderController.text,
                  cardNumber: numberController.text.isEmpty
                      ? 'XXXX XXXX XXXX XXXX'
                      : numberController.text,
                  validFrom: validFromController.text.isEmpty
                      ? 'MM/YY'
                      : validFromController.text,
                  validThru: validTillController.text.isEmpty
                      ? 'MM/YY'
                      : validTillController.text,
                  topLeftColor: Colors.blue,
                  doesSupportNfc: true,
                  placeNfcIconAtTheEnd: true,
                  cardType: cardType,
                  creditCardType: CreditCardType.visa,
                  // cardProviderLogo: Image(
                  //   image: AssetImage(cardProvider == null
                  //       ? "assets/images/bg.png"
                  //       : cardProvider == "visa"
                  //           ? "assets/images/visa.png"
                  //           : "assets/images/mcard.png"),
                  // ),
                  // cardProviderLogoPosition: CardProviderLogoPosition.right,
                  showBalance: false,

                  balance: 128.32434343,
                  autoHideBalance: true,

                  enableFlipping: true,
                  cvvNumber: cvvController.text.isEmpty
                      ? '***'
                      : cvvController.text.length == 1
                          ? '*'
                          : cvvController.text.length == 2
                              ? '**'
                              : '***',
                ),
                const SizedBox(height: 20),

                // Card Holder Name
                TextFormField(
                  controller: cardHolderController,
                  decoration: InputDecoration(
                    labelText: 'Cardholder Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter cardholder name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                // Card Number
                TextFormField(
                  controller: numberController,
                  keyboardType: TextInputType.number,
                  obscureText: true, // Set to false to show the card number
                  decoration: InputDecoration(
                    labelText: 'Card Number',
                    hintText: "XXXX XXXX XXXX XXXX",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(
                        16), // Limit input to 16 digits
                  ],
                  validator: (value) {
                    if (value == null || value.length != 16) {
                      return 'Please enter exactly 16 digits';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                // CVV
                TextFormField(
                  controller: cvvController,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'CVV',
                    hintText: "***",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(
                        3), // Limit input to 3 digits
                  ],
                  validator: (value) {
                    if (value == null || value.length != 3) {
                      return 'Please enter exactly 3 digits for CVV';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                // Valid From and Valid Till in a Row
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: validFromController,
                        keyboardType: TextInputType.datetime,
                        decoration: InputDecoration(
                          labelText: 'Valid From',
                          hintText: "MM/YY",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        inputFormatters: [
                          _dateInputFormatter
                        ], // MM/YY formatter
                        validator: (value) {
                          if (value == null ||
                              !isValidDateFormat(value) ||
                              !isValidFromDate(value)) {
                            return 'Enter valid past date in MM/YY format';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: validTillController,
                        keyboardType: TextInputType.datetime,
                        decoration: InputDecoration(
                          labelText: 'Valid Till',
                          hintText: "MM/YY",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        inputFormatters: [
                          _dateInputFormatter
                        ], // MM/YY formatter
                        validator: (value) {
                          if (value == null || !isValidTillDate(value)) {
                            return 'Enter valid future date in MM/YY format';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                ////////////////CardTypes/////////////////
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DropdownMenu(
                      width: MediaQuery.of(context).size.width * 0.914,
                      label: const Text("Select Card Type"),
                      onSelected: (value) {
                        selectedType = value;
                        value == "debit"
                            ? cardType = CardType.debit
                            : value == "credit"
                                ? cardType = CardType.credit
                                : value == "prepaid"
                                    ? cardType = CardType.prepaid
                                    : cardType = CardType.giftCard;
                        setState(() {});
                      },
                      dropdownMenuEntries: const [
                        DropdownMenuEntry(value: "debit", label: "Debit Card"),
                        DropdownMenuEntry(
                            value: "credit", label: "Credit Card"),
                        DropdownMenuEntry(
                            value: "prepaid", label: "Prepaid Card"),
                        DropdownMenuEntry(value: "gift", label: "Gift Card"),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                // Submit Button
                SizedBox(
                  width: MediaQuery.of(context).size.width - 32,
                  height: 50,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStatePropertyAll(Colour.orangeColor),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (selectedType == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Please select a card type ')),
                          );
                          return;
                        }
                        String token = FirebaseAuth.instance.currentUser!.uid;
                        await FirebaseFirestore.instance
                            .collection("Cards")
                            .doc(token)
                            .collection(token)
                            .doc("${cardHolderController.text}$selectedType")
                            .set({
                          "Name": cardHolderController.text.toString(),
                          "Card Number": numberController.text.toString(),
                          "CVV": cvvController.text.toString(),
                          "Valid From": validFromController.text,
                          "Valid Till": validTillController.text,
                          "Card Type": selectedType,
                        });
                        // Form is valid
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              duration: Duration(seconds: 2),
                              content: Text('Card submitted successfully!')),
                        );
                        Future.delayed(const Duration(milliseconds: 2500), () {
                          Navigator.pop(context);
                        });
                      } else {
                        // Form is invalid
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Please correct the errors')),
                        );
                      }
                    },
                    child: const Text(
                      'Submit',
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Custom input formatter for MM/YY format
class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text =
        newValue.text.replaceAll('/', ''); // Remove any existing slashes

    // Ensure the input is a valid length
    if (text.length > 4) {
      text = text.substring(0, 4); // Limit to 4 digits
    }

    if (text.length > 2) {
      final monthPart = int.tryParse(text.substring(0, 2)) ?? 0;
      final yearPart = text.length > 2 ? text.substring(2) : '';

      // If month is greater than 12, adjust it
      if (monthPart > 12) {
        text =
            '0${monthPart % 10}$yearPart'; // Set month to 01 and move the second digit to the year
      } else {
        // Reconstruct text with a '/' after the first two digits
        text = '${text.substring(0, 2)}/$yearPart';
      }
    } else {
      text = text; // For single or two-digit months, keep the input as is
    }

    return newValue.copyWith(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
