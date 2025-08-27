import 'package:flutter/material.dart';
import 'package:lost_found/constant/ui_colour.dart';
import 'package:lost_found/screens/update_info_page.dart';

class UpdateInfoButton extends StatelessWidget {
  const UpdateInfoButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const UpdateInfoPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
            transitionDuration: const Duration(milliseconds: 1000),
          ),
        );
      },
      style: ElevatedButton.styleFrom(backgroundColor: mainC),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Update Info',
            style: TextStyle(
              fontFamily: 'font',
              color: Colors.black,
              fontSize: 17,
            ),
          ),
          const SizedBox(width: 3),
          Icon(Icons.edit, color: Colors.black),
        ],
      ),
    );
  }
}
