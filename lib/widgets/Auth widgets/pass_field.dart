import 'package:flutter/material.dart';

class PassField extends StatelessWidget {
  const PassField({
    super.key,
    required this.passController,
    required this.onIspressed,
    required this.isPressed,
    required this.hint,
  });
  final String hint;
  final bool isPressed;

  final void Function() onIspressed;
  final TextEditingController passController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: TextField(
        controller: passController,
        obscureText: isPressed ? false : true,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white54,
          hintText: hint,
          prefixIcon: Icon(Icons.password),
          suffixIcon: IconButton(
            onPressed: onIspressed,
            icon: Icon(
              isPressed ? Icons.remove_red_eye : Icons.remove_red_eye_outlined,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.black, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
