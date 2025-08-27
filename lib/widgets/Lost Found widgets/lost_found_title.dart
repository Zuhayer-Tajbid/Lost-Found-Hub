import 'package:flutter/material.dart';
import 'package:lost_found/model/lost_found.dart';

class LostFoundTitle extends StatelessWidget {
  const LostFoundTitle({super.key, required this.item});
  final LostFound item;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Text(
        item.title,
        style: TextStyle(
          fontSize: 30,
          fontFamily: 'font',
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
