import 'package:flutter/material.dart';

class CreatePostField extends StatelessWidget {
  const CreatePostField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    required this.num,
    required this.des,
    required this.label,
  });

  final String hint;
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final bool num;
  final bool des;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: TextField(
        controller: controller,
        keyboardType: num ? TextInputType.number : null,

        minLines: des ? 7 : null,
        maxLines: des ? null : 1,
        decoration: InputDecoration(
          labelStyle: TextStyle(color: Colors.black),
          labelText: label,
          filled: true,
          fillColor: Colors.white54,
          hintText: hint,
          prefixIcon: Icon(icon),
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
