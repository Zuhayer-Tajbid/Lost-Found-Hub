import 'package:flutter/material.dart';
import 'package:lost_found/model/lost_found.dart';

class LostFoundPhoto extends StatelessWidget {
  const LostFoundPhoto({super.key, required this.item, this.imageUrl});

  final LostFound item;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      child: Container(
        width: 300,
        height: 300,
        color: Colors.white54,
        child: item.photoUrl == null && imageUrl == null
            ? Icon(
                item.isLost ? Icons.search_off : Icons.check_circle_outline,
                color: Colors.black,
                size: 70,
              )
            : Image.network(imageUrl!, fit: BoxFit.cover),
      ),
    );
  }
}
