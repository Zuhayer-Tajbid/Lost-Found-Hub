import 'package:flutter/material.dart';
import 'package:lost_found/model/lost_found.dart';

class LostFoundPhone extends StatelessWidget {
  const LostFoundPhone({super.key, required this.item});
  final LostFound item;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: Row(
        children: [
          Text(
            'Phone',
            style: TextStyle(
              fontFamily: 'font',
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 3),
          Icon(Icons.phone),
          Text(':', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          item.phone == null
              ? Text(
                  'X',
                  style: TextStyle(
                    fontFamily: 'font',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    color: Colors.white60,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 17,
                    ),
                    child: SelectableText(
                      item.phone!,
                      style: TextStyle(
                        fontFamily: 'font',
                        fontSize: 23,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
