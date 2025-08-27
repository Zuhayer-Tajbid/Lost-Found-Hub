import 'package:flutter/material.dart';
import 'package:lost_found/model/lost_found.dart';

class LostFoundDesc extends StatelessWidget {
  const LostFoundDesc({super.key, required this.item});
  final LostFound item;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),

      child: Container(
        decoration: BoxDecoration(
          color: Colors.white38,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black54),
        ),

        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Text(
            item.description,
            style: TextStyle(
              fontFamily: 'font',
              fontSize: 23,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
