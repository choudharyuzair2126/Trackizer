import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:trackizer/components/navigation.dart';
import 'package:trackizer/screens/calender.dart';
import 'package:trackizer/screens/credit_cards.dart';
import 'package:trackizer/screens/home_screen.dart';
import 'package:trackizer/screens/new_subscription.dart';
import 'package:trackizer/screens/spendings_budgets.dart';
import 'package:trackizer/theme/color.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({super.key});

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  final List<Widget> _pages = [
    const HomeScreen(),
    const SpendingsAndBudgets(),
    const Calender(),
    const CreditCards()
  ];
  int _bottomNavIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_bottomNavIndex],
      floatingActionButton: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colour.orangeColor,
              blurRadius: 6,
              spreadRadius: 0.3,
              offset: const Offset(0, 1.4),
            ),
          ],
          shape: BoxShape.circle,
        ),
        child: FloatingActionButton(
          backgroundColor: Colour.orangeColor,
          foregroundColor: Colour.whiteButton,
          shape: CircleBorder(
            side: BorderSide(
              color: Colour.orangeColor1,
              width: 1.4,
            ),
          ),

          onPressed: () {
            Navigation.push(context, const NewSubscription());
          },
          child: const Icon(Icons.add),
          //params
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
          icons: const [
            Icons.home_outlined,
            Icons.grid_view_outlined,
            Icons.calendar_month_outlined,
            Icons.credit_card_rounded,
          ],
          borderColor: Colour.unSelectedTab,
          borderWidth: 3,
          activeIndex: _bottomNavIndex,
          activeColor: Colour.whiteButton,
          inactiveColor: Colour.unSelectedTab,
          backgroundColor: Colour.bottomBarColor,
          gapLocation: GapLocation.center,
          notchSmoothness: NotchSmoothness.defaultEdge,
          onTap: (index) {
            setState(() {
              _bottomNavIndex = index;
            });
          }),
    );
  }
}
