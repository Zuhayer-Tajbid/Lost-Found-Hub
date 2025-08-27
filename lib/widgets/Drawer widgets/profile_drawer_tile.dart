import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileDrawerTile extends StatelessWidget {
  const ProfileDrawerTile({
    super.key,
    this.imageUrl,
    this.profile,
    required this.user,
  });

  final String? imageUrl;
  final User user;
  final Map<String, dynamic>? profile;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 5),
          child: CircleAvatar(
            radius: 40,
            backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
            child: imageUrl == null ? const Icon(Icons.person) : null,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoSizeText(
                profile?['name'] ?? 'No name set',
                style: TextStyle(
                  fontFamily: 'font',
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                minFontSize: 20,
                maxFontSize: 30,
                overflow: TextOverflow.ellipsis,
              ),

              Text(
                user.email ?? 'No email',
                style: TextStyle(
                  fontFamily: 'font',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                softWrap: true,
                overflow: TextOverflow.visible,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
