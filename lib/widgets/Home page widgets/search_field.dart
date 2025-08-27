import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    required this.controller,
    required this.filter,
  });

  final void Function(String keyword) filter;

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: TextField(
        onChanged: (value) => filter(value),
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Search',
          fillColor: Colors.white54,
          //contentPadding: EdgeInsets.symmetric(horizontal: 10),
          filled: true,
          prefixIcon: Icon(Icons.search),
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
