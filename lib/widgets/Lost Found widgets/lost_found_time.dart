import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lost_found/model/lost_found.dart';

class LostFoundTime extends StatelessWidget {
  const LostFoundTime({super.key, required this.item});
  final LostFound item;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const SizedBox(width: 30),
          Text(
            item.isLost ? 'Lost Time: ' : 'Found Time :',
            style: TextStyle(
              fontFamily: 'font',
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
          const SizedBox(width: 7),
          Text(
            DateFormat('dd MMM yyyy, hh:mm a').format(item.dateTime),
            maxLines: 2,
            softWrap: true,
            style: TextStyle(
              fontFamily: 'font',
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
