import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:trackizer/components/box3.dart';
import 'package:trackizer/components/navigation.dart';
import 'package:trackizer/screens/settings.dart';
import 'package:trackizer/screens/subs_info.dart';
import 'package:trackizer/theme/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Calender extends StatefulWidget {
  const Calender({super.key});

  @override
  State<Calender> createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  int month = DateTime.now().month;
  ValueNotifier<String> selectedDateNotifier = ValueNotifier<String>(
      "${DateTime.now().day.toString().padLeft(2, '0')}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().year}");
  String? token;
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
        Container(
          height: MediaQuery.of(context).size.height * 0.47,
          decoration: BoxDecoration(
            color: Colour.greyButton,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Calendar",
                        style: TextStyle(color: Colour.grey30, fontSize: 16)),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.27),
                    IconButton(
                      onPressed: () =>
                          Navigation.push(context, const SettingsScreen()),
                      icon: Icon(Icons.settings_outlined,
                          color: Colour.grey30, size: 30),
                    ),
                  ],
                ),
                const SizedBox(height: 26),
                Text("Subs",
                    style: TextStyle(
                        fontSize: 33,
                        fontWeight: FontWeight.bold,
                        color: Colour.white)),
                Text("Schedule",
                    style: TextStyle(
                        fontSize: 33,
                        fontWeight: FontWeight.bold,
                        color: Colour.white)),
                const SizedBox(height: 8),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ValueListenableBuilder(
                          valueListenable: selectedDateNotifier,
                          builder: (context, selectedDate, child) {
                            return StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection("subs")
                                    .doc(token)
                                    .collection(token!)
                                    .where("First Payment",
                                        isEqualTo: selectedDate)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  return Text(snapshot.data?.docs.length == null
                                      ? "0 Subscription for today"
                                      : snapshot.data!.docs.length == 1
                                          ? "01 Subscription for today"
                                          : snapshot.data!.docs.isEmpty
                                              ? "0 Subscription for today"
                                              : snapshot.data!.docs.length < 10
                                                  ? "0${snapshot.data!.docs.length.toString()} Subscriptions for today"
                                                  : "${snapshot.data!.docs.length.toString()} Subscriptions for today");
                                });
                          }),
                      DropdownMenu(
                        onSelected: (value) {
                          month = int.parse(value.toString());

                          bool isSameMonth = DateTime.now().month == month;
                          selectedDateNotifier.value = !isSameMonth
                              ? "01-${month.toString().padLeft(2, '0')}-${DateTime.now().year}"
                              : "${DateTime.now().day.toString().padLeft(2, '0')}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().year}";
                          setState(() {});
                        },
                        initialSelection: "${DateTime.now().month}",
                        menuHeight: 250,
                        inputDecorationTheme: InputDecorationTheme(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        dropdownMenuEntries: const [
                          DropdownMenuEntry(value: "1", label: "January"),
                          DropdownMenuEntry(value: "2", label: "February"),
                          DropdownMenuEntry(value: "3", label: "March"),
                          DropdownMenuEntry(value: "4", label: "April"),
                          DropdownMenuEntry(value: "5", label: "May"),
                          DropdownMenuEntry(value: "6", label: "June"),
                          DropdownMenuEntry(value: "7", label: "July"),
                          DropdownMenuEntry(value: "8", label: "August"),
                          DropdownMenuEntry(value: "9", label: "September"),
                          DropdownMenuEntry(value: "10", label: "October"),
                          DropdownMenuEntry(value: "11", label: "November"),
                          DropdownMenuEntry(value: "12", label: "December"),
                        ],
                      ),
                    ],
                  ),
                ),
                CalendarTimeline(
                  initialDate: month == DateTime.now().month
                      ? DateTime.now()
                      : DateTime(DateTime.now().year, month, 1),
                  firstDate: DateTime(DateTime.now().year),
                  lastDate: DateTime(DateTime.now().year + 1),
                  showYears: false,
                  shrink: false,
                  onDateSelected: (date) {
                    selectedDateNotifier.value =
                        "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";
                    debugPrint(selectedDateNotifier.value);
                  },
                  leftMargin: 20,
                  monthColor: Colors.transparent,
                  dayColor: Colors.teal[200],
                  activeDayColor: Colors.white,
                  activeBackgroundDayColor: Colors.redAccent[100],
                  locale: 'en_ISO',
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20, top: 15),
          child: Column(
            children: [
              ValueListenableBuilder(
                valueListenable: selectedDateNotifier,
                builder: (context, selectedDate, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedDate,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colour.grey30),
                      ),
                      Text("in upcoming bills",
                          style: TextStyle(fontSize: 14, color: Colour.grey30)),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: selectedDateNotifier,
            builder: (context, selectedDate, child) {
              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("subs")
                    .doc(token)
                    .collection(token!)
                    .where("First Payment", isEqualTo: selectedDate)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                        child: Text("No subscriptions found for this date."));
                  }

                  var subscriptions = snapshot.data!.docs;

                  return GridView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: subscriptions.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      var data =
                          subscriptions[index].data() as Map<String, dynamic>;

                      return GestureDetector(
                        onTap: () => Navigation.push(context,
                            SubsInfo(title: data['Name'], subscription: data)),
                        child: Box3(
                          name: data['Name'],
                          price: data['Price'],
                          image: data['Image'],
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    ));
  }
}
