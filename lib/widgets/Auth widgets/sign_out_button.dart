import 'package:flutter/material.dart';
import 'package:lost_found/constant/ui_colour.dart';

class SignOutButton extends StatelessWidget {
  const SignOutButton({super.key, required this.signOut});

  final void Function() signOut;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 60,
      right: 10,
      child: GestureDetector(
        onTap: signOut,
        child: Card(
          color: mainC1,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Text(
                  'Sign Out',
                  style: TextStyle(
                    fontFamily: 'font',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(width: 4),
                Icon(Icons.logout_rounded),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
