import 'package:flutter/material.dart';
import 'package:lost_found/model/lost_found.dart';
import 'package:lost_found/screens/update_lost_found.dart';

class EditPostButton extends StatelessWidget {
  const EditPostButton({super.key, required this.item});

  final LostFound item;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 8,
      right: 12,
      child: GestureDetector(
        onTap: item.isResolved
            ? null
            : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateLostFound(item: item),
                  ),
                );
              },
        child: Opacity(
          opacity: item.isResolved ? 0.4 : 1.0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white54,
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.edit),
            ),
          ),
        ),
      ),
    );
  }
}
