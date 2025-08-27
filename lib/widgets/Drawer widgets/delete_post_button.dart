import 'package:flutter/material.dart';
import 'package:lost_found/model/lost_found.dart';

class DeletePostButton extends StatefulWidget {
  const DeletePostButton({
    super.key,
    required this.showDeletediag,
    required this.item,
  });

  final void Function(LostFound item) showDeletediag;
  final LostFound item;

  @override
  State<DeletePostButton> createState() => _DeletePostButtonState();
}

class _DeletePostButtonState extends State<DeletePostButton> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 8,
      right: 12,
      child: GestureDetector(
        onTap: () {
          widget.showDeletediag(widget.item);
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white54,
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.delete),
          ),
        ),
      ),
    );
  }
}
