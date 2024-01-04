import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

/* Switch bar custom Widget */
class MySwitchBar extends StatelessWidget {
  final void Function(int)? onTabChange;
  final int selectedIndex;
  
  const MySwitchBar(
      {super.key, required this.onTabChange, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      height: 55,
      child: GNav(
          selectedIndex: selectedIndex,
          onTabChange: (value) => onTabChange!(value),
          color: Colors.grey.shade400,
          mainAxisAlignment: MainAxisAlignment.center,
          activeColor: Colors.grey[700],
          tabBackgroundColor: Colors.grey.shade300,
          tabActiveBorder: Border.all(color: Colors.white),
          tabBorderRadius: 24,
          padding: const EdgeInsets.all(15),
          tabs: const [
            GButton(
              icon: Icons.restaurant,
              text: 'Eat In',
            ),
            GButton(
              icon: Icons.park,
              text: 'Eat Out',
            )
          ]),
    );
  }
}
