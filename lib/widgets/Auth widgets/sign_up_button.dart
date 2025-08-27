import 'package:flutter/material.dart';
import 'package:lost_found/screens/signup_page.dart';

class SignUpButton extends StatelessWidget {
  const SignUpButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                SignupPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return ScaleTransition(
                    scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(parent: animation, curve: Curves.easeOut),
                    ),
                    child: child,
                  );
                },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      },
      child: Text(
        'Sign Up',
        style: TextStyle(fontFamily: 'font', color: Colors.blue, fontSize: 20),
      ),
    );
  }
}
