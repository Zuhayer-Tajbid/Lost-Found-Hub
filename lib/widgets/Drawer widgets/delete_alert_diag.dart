import 'package:flutter/material.dart';
import 'package:lost_found/constant/ui_colour.dart';
import 'package:lost_found/model/lost_found.dart';

class DeleteAlertDiag extends StatelessWidget {
  const DeleteAlertDiag({
    super.key,
    required this.deletePost,
    required this.item,
  });

  final LostFound item;
  final void Function(LostFound item) deletePost;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: mainC,
      content: Text(
        'Are you sure you want to delete this post?',
        style: TextStyle(
          fontFamily: 'font',
          fontSize: 25,
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Cancel',
            style: TextStyle(
              fontFamily: 'font',
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            deletePost(item);
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(backgroundColor: widC),
          child: Text(
            'Delete',
            style: TextStyle(
              fontFamily: 'font',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
