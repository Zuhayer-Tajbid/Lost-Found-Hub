import 'package:flutter/material.dart';
import 'package:lost_found/constant/ui_colour.dart';

class CreatePostButton extends StatelessWidget {
  const CreatePostButton({super.key, required this.showAddDialog});

  final void Function() showAddDialog;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: showAddDialog,
      style: ElevatedButton.styleFrom(
        side: BorderSide(color: Colors.black, width: 2),
        backgroundColor: mainC1,

        fixedSize: Size(75, 60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(15),
        ),
      ),
      child: Center(child: Icon(Icons.add, color: Colors.black, size: 30)),
    );
  }
}
