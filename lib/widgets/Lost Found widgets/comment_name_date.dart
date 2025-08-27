import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommentNameDate extends StatelessWidget {
  const CommentNameDate({super.key, this.profile, required this.createdAt});

  final DateTime createdAt;

  final Map<String, dynamic>? profile;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          profile?['name'] ?? "Unknown",
          style: TextStyle(
            fontFamily: 'font',
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          DateFormat.jm().format(createdAt),
          style: TextStyle(
            fontFamily: 'font',
            fontSize: 12,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
