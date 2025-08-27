import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:lost_found/constant/ui_colour.dart';

class GnavBottom extends StatefulWidget {
  const GnavBottom({
    super.key,
    required this.selectedpageIndex,
    required this.onTabChange,
  });
  final int selectedpageIndex;
  final Function(int) onTabChange;
  @override
  State<GnavBottom> createState() => _GnavBottomState();
}

class _GnavBottomState extends State<GnavBottom> {
  late int _currentIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widC,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 50, left: 20, right: 20, top: 5),
        child: GNav(
          gap: 12,
          textStyle: TextStyle(
            fontFamily: 'font',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          backgroundColor: widC,
          color: Colors.black54,
          tabBackgroundColor: mainC1,
          selectedIndex: widget.selectedpageIndex,
          iconSize: 25,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          onTabChange: widget.onTabChange,
          tabs: [
            GButton(icon: Icons.all_inclusive, text: 'All'),

            GButton(icon: Icons.search_off, text: 'Lost'),
            GButton(icon: Icons.check_circle_outline, text: 'Found'),
          ],
        ),
      ),
    );
  }
}
