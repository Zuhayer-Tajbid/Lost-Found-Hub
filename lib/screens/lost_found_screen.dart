import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lost_found/constant/ui_colour.dart';
import 'package:lost_found/model/comment.dart';
import 'package:lost_found/model/lost_found.dart';
import 'package:lost_found/widgets/Lost%20Found%20widgets/comment_name_date.dart';
import 'package:lost_found/widgets/Lost%20Found%20widgets/lost_found_desc.dart';
import 'package:lost_found/widgets/Lost%20Found%20widgets/lost_found_fb.dart';
import 'package:lost_found/widgets/Lost%20Found%20widgets/lost_found_phone.dart';
import 'package:lost_found/widgets/Lost%20Found%20widgets/lost_found_photo.dart';
import 'package:lost_found/widgets/Lost%20Found%20widgets/lost_found_time.dart';
import 'package:lost_found/widgets/Lost%20Found%20widgets/lost_found_title.dart';
import 'package:lost_found/widgets/Home%20page%20widgets/post_profile_tile.dart';
import 'package:lost_found/widgets/Lost%20Found%20widgets/reply_comment_header.dart';
import 'package:lost_found/widgets/Common%20widgets/circle.dart';
import 'package:lost_found/widgets/Common%20widgets/snack.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LostFoundScreen extends StatefulWidget {
  const LostFoundScreen({super.key, required this.item, this.imageUrl});

  final String? imageUrl;
  final LostFound item;

  @override
  State<LostFoundScreen> createState() => _LostFoundScreenState();
}

class _LostFoundScreenState extends State<LostFoundScreen> {
  final TextEditingController _commentController = TextEditingController();
  String? _replyingToCommentId;
  String? _replyingToUserName;

  /// Stream of comments for this post
  Stream<List<Map<String, dynamic>>> commentStream(String postId) {
    return Supabase.instance.client
        .from('comments')
        .stream(primaryKey: ['id'])
        .eq('post_id', postId)
        .order('created_at', ascending: true);
  }

  /// Add a new comment
  Future<void> addComment({
    required String postId,
    required String text,
    String? parentId,
  }) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    await Supabase.instance.client.from('comments').insert({
      'post_id': postId,
      'user_id': user.id,
      'text': text,
      'parent_comment_id': parentId,
    });

    // Reset reply state after posting
    setState(() {
      _replyingToCommentId = null;
      _replyingToUserName = null;
    });
  }

  //delete comment function
  Future<void> _deleteComment(String commentId) async {
    try {
      await Supabase.instance.client
          .from('comments')
          .delete()
          .eq('id', commentId);
      setState(() {});
      showSnackBar(context, 'Comment deleted');
    } catch (e) {
      showSnackBar(context, 'Error deleting comment: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var item = widget.item;

    return Scaffold(
      backgroundColor: bodyC,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    //profile tile
                    PostProfileTile(item: item, isHome: false),

                    //title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [LostFoundTitle(item: item)],
                    ),

                    //photo
                    LostFoundPhoto(item: item, imageUrl: widget.imageUrl),
                    const SizedBox(height: 20),

                    //time
                    LostFoundTime(item: item),

                    //descrption
                    LostFoundDesc(item: item),
                    const SizedBox(height: 10),

                    //facebook id
                    LostFoundFb(item: item),

                    //phone number
                    LostFoundPhone(item: item),

                    // ---- COMMENT SECTION ----
                    const Divider(),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Comments",
                          style: TextStyle(
                            fontFamily: 'font',
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    // Real-time comments
                    StreamBuilder<List<Map<String, dynamic>>>(
                      stream: commentStream(item.id!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Circle();
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Text("No comments yet.");
                        }
                        final comments = snapshot.data!;
                        // Separate top-level comments from replies
                        final topLevelComments = comments
                            .where((c) => c['parent_comment_id'] == null)
                            .toList();
                        final replies = comments
                            .where((c) => c['parent_comment_id'] != null)
                            .toList();

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: topLevelComments.length,
                          itemBuilder: (context, index) {
                            final comment = topLevelComments[index];
                            final commentReplies = replies
                                .where(
                                  (r) =>
                                      r['parent_comment_id'] == comment['id'],
                                )
                                .toList();

                            return Column(
                              children: [
                                // Main comment
                                Padding(
                                  padding: const EdgeInsets.only(top: 30.0),
                                  child: _buildCommentTile(comment),
                                ),

                                // Replies with indentation
                                ...commentReplies
                                    .map(
                                      (reply) => Padding(
                                        padding: const EdgeInsets.only(
                                          left: 30.0,
                                        ), // Indent replies
                                        child: _buildCommentTile(reply),
                                      ),
                                    )
                                    .toList(),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // ---- COMMENT INPUT FIELD ----
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              color: Colors.grey[200],
              child: Column(
                children: [
                  // Show who you're replying to
                  if (_replyingToCommentId != null)
                    ReplyCommentHeader(
                      onClose: () {
                        setState(() {
                          _replyingToCommentId = null;
                          _replyingToUserName = null;
                        });
                      },
                    ),

                  //comment field
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _commentController,
                          decoration: const InputDecoration(
                            hintText: "Add a comment...",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () async {
                          if (_commentController.text.trim().isEmpty) return;
                          await addComment(
                            postId: item.id!,
                            text: _commentController.text.trim(),
                            parentId:
                                _replyingToCommentId, // Pass the parent ID
                          );
                          _commentController.clear();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentTile(Map<String, dynamic> comment) {
    return StreamBuilder(
      stream: Supabase.instance.client
          .from('profiles')
          .stream(primaryKey: ['id'])
          .eq('id', comment['user_id']),
      builder: (context, profilesnap) {
        // ... your existing comment tile code ...
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
        DateTime createdAt = DateTime.parse(comment['created_at']).toLocal();
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                CircleAvatar(
                  radius: 20,
                  backgroundImage: imageUrl != null
                      ? NetworkImage(imageUrl)
                      : null,
                  child: imageUrl == null ? const Icon(Icons.person) : null,
                ),

                const SizedBox(width: 12), // Space between avatar and content
                // Comment content with flexible width
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white54,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name and time in a row
                          CommentNameDate(
                            createdAt: createdAt,
                            profile: profile,
                          ),

                          const SizedBox(height: 4),

                          // Comment text
                          Text(
                            comment['text'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),

                          // Reply button
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              TextButton.icon(
                                icon: Icon(Icons.reply, size: 16),
                                label: Text(
                                  'Reply',
                                  style: TextStyle(fontFamily: 'font'),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _replyingToCommentId = comment['id'];
                                    _replyingToUserName =
                                        profile?['name'] ?? "Unknown";
                                  });
                                },
                              ),

                              // Delete button (only for owner)
                              if (comment['user_id'] ==
                                  Supabase.instance.client.auth.currentUser?.id)
                                TextButton.icon(
                                  icon: Icon(
                                    Icons.delete,
                                    size: 16,
                                    color: Colors.red,
                                  ),
                                  label: Text(
                                    'Delete',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontFamily: 'font',
                                    ),
                                  ),
                                  onPressed: () =>
                                      _deleteComment(comment['id']),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
