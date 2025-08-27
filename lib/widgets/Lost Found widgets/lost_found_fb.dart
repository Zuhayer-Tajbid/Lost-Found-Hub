import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lost_found/model/lost_found.dart';
import 'package:url_launcher/link.dart';

class LostFoundFb extends StatelessWidget {
  const LostFoundFb({super.key, required this.item});
  final LostFound item;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: Row(
        children: [
          Text(
            'Facebook:',
            style: TextStyle(
              fontFamily: 'font',
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          item.facebook == null
              ? Text(
                  'X',
                  style: TextStyle(
                    fontFamily: 'font',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                )
              : Link(
                  uri: Uri.parse(item.facebook!),
                  builder: (context, followLink) => IconButton(
                    onPressed: followLink,
                    icon: FaIcon(
                      FontAwesomeIcons.facebook,
                      size: 40,
                      color: const Color.fromARGB(255, 9, 121, 213),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
