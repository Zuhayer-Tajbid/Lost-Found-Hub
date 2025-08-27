import 'package:flutter/material.dart';
import 'package:lost_found/widgets/Drawer%20widgets/profile_drawer_tile.dart';
import 'package:lost_found/widgets/Drawer%20widgets/update_info_button.dart';
import 'package:lost_found/widgets/Common%20widgets/circle.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DrawerHeaderStream extends StatelessWidget {
  const DrawerHeaderStream({super.key});

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

              final imagePath = profile?['photo_url'];

              String? imageUrl;
              if (imagePath != null && imagePath.isNotEmpty) {
                imageUrl = Supabase.instance.client.storage
                    .from('profile_pic')
                    .getPublicUrl(imagePath);
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.start,

                children: [
                  //profile info
                  ProfileDrawerTile(
                    user: user,
                    imageUrl: imageUrl,
                    profile: profile,
                  ),
                  const SizedBox(height: 4),

                  //update info button
                  UpdateInfoButton(),
                ],
              );
            },
          );
        }
      },
    );
  }
}
