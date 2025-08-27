import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lost_found/constant/ui_colour.dart';
import 'package:lost_found/widgets/Common%20widgets/circle.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileTile extends StatefulWidget {
  const ProfileTile({super.key});

  @override
  State<ProfileTile> createState() => _ProfileTileState();
}

class _ProfileTileState extends State<ProfileTile> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final user = snapshot.data?.session?.user;
        if (user == null) {
          return Text('No user');
        } else {
          return StreamBuilder(
            stream: Supabase.instance.client
                .from('profiles')
                .stream(primaryKey: ['id'])
                .eq('id', user.id),
            builder: (context, profilesnap) {
              if (profilesnap.connectionState == ConnectionState.waiting) {
                return Circle();
              }
              if (profilesnap.hasError) {
                return Text('Error: ${profilesnap.error}');
              }
              final profile = profilesnap.data!.isNotEmpty == true
                  ? profilesnap.data!.first
                  : null;

              print('Photo URL: ${profile?['photo_url']}');

              final imagePath =
                  profile?['photo_url']; // e.g. "upload/1755839811503044.png"

              String? imageUrl;
              if (imagePath != null && imagePath.isNotEmpty) {
                imageUrl = Supabase.instance.client.storage
                    .from('profile_pic') // your bucket name
                    .getPublicUrl(imagePath);
              }

              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 20,
                ),
                child: GestureDetector(
                  onTap: () {
                    Scaffold.of(context).openDrawer();
                  },
                  child: Card(
                    color: mainC,
                    elevation: 4,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 15,
                          ),
                          child: CircleAvatar(
                            radius: 40,
                            backgroundImage: imageUrl != null
                                ? NetworkImage(imageUrl)
                                : null,
                            child: imageUrl == null
                                ? const Icon(Icons.person)
                                : null,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AutoSizeText(
                              profile?['name'] ?? 'No name set',
                              style: TextStyle(
                                fontFamily: 'font',
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              minFontSize: 23,
                              maxFontSize: 40,
                              overflow: TextOverflow.ellipsis,
                            ),

                            const SizedBox(height: 5),
                            Text(
                              user.email ?? 'No email',
                              style: TextStyle(
                                fontFamily: 'font',
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
