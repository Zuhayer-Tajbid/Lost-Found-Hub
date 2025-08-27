import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lost_found/constant/ui_colour.dart';
import 'package:lost_found/model/lost_found.dart';
import 'package:lost_found/widgets/Common%20widgets/circle.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PostProfileTile extends StatefulWidget {
  const PostProfileTile({super.key, required this.item, required this.isHome});

  final LostFound item;
  final bool isHome;
  @override
  State<PostProfileTile> createState() => _PostProfileTileState();
}

class _PostProfileTileState extends State<PostProfileTile> {
  @override
  Widget build(BuildContext context) {
    var item = widget.item;
    return StreamBuilder(
      stream: Supabase.instance.client
          .from('profiles')
          .stream(primaryKey: ['id'])
          .eq('id', item.userId),
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
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: widget.isHome
                ? 0
                : 15, // Only add bottom padding when NOT home
            top: 0, // Always 0 for home
          ),
          child: Card(
            color: mainC,
            elevation: 4,

            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: widget.isHome ? 4 : 10,
                    horizontal: widget.isHome ? 8 : 15,
                  ),
                  child: CircleAvatar(
                    radius: widget.isHome ? 20 : 40,
                    backgroundImage: imageUrl != null
                        ? NetworkImage(imageUrl)
                        : null,
                    child: imageUrl == null ? const Icon(Icons.person) : null,
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
                      minFontSize: widget.isHome ? 18 : 23,
                      maxFontSize: widget.isHome ? 30 : 40,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
