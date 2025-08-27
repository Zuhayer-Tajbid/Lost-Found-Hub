import 'package:flutter/material.dart';
import 'package:lost_found/model/lost_found.dart';

class UserPostCard extends StatelessWidget {
  const UserPostCard({super.key, required this.item});

  final LostFound item;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Opacity(
        opacity: item.isResolved ? 0.5 : 1.0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            color: item.isResolved
                ? Colors.grey.shade500
                : item.isLost
                ? Colors.red.shade200
                : Colors.amber.shade300,
            width: 200,
            height: 125,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  item.title,
                  style: TextStyle(
                    fontFamily: 'font',
                    fontSize: 23,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
