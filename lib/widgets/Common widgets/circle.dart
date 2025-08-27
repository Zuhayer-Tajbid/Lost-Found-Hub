import 'package:flutter/material.dart';
import 'package:lost_found/constant/ui_colour.dart';

class Circle extends StatelessWidget {
  const Circle({super.key});

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(color: mainC, strokeWidth: 4);
  }
}
