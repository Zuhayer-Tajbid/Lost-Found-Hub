import 'package:flutter/material.dart';

import 'package:lost_found/constant/ui_colour.dart';
import 'package:lost_found/model/lost_found.dart';
import 'package:lost_found/provider/provider_helper.dart';
import 'package:lost_found/screens/login_page.dart';
import 'package:lost_found/screens/lost_found_screen.dart';

import 'package:lost_found/widgets/Drawer%20widgets/delete_alert_diag.dart';
import 'package:lost_found/widgets/Drawer%20widgets/delete_post_button.dart';
import 'package:lost_found/widgets/Drawer%20widgets/drawer_header_stream.dart';
import 'package:lost_found/widgets/Drawer%20widgets/edit_post_button.dart';

import 'package:lost_found/widgets/Drawer%20widgets/resolve_toggle.dart';
import 'package:lost_found/widgets/Auth%20widgets/sign_out_button.dart';
import 'package:lost_found/widgets/Common%20widgets/circle.dart';
import 'package:lost_found/widgets/Common%20widgets/snack.dart';

import 'package:lost_found/widgets/Drawer%20widgets/user_post_card.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileDrawer extends StatefulWidget {
  const ProfileDrawer({super.key});

  @override
  State<ProfileDrawer> createState() => _ProfileDrawerState();
}

class _ProfileDrawerState extends State<ProfileDrawer> {
  //signout
  void signOut() async {
    await Supabase.instance.client.auth.signOut().then((val) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });
  }

Future<void> deleteImage(String path) async {
  try {
    await Supabase.instance.client.storage
        .from('lost_found') // your bucket name
        .remove([path]); // accepts a list of paths to delete
    
    print('Image deleted successfully: $path');
  } catch (e) {
    print('Error deleting image: $e');
    throw Exception('Failed to delete image: $e');
  }
}

  //delete post
  Future<void> deletePost(LostFound item) async {
    try {
      await context.read<ProviderHelper>().deletePost(item.id!);
      if(item.photoUrl!=null){
        await deleteImage(item.photoUrl!);
      }
      setState(() {});
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        showSnackBar(context, 'Successfully deleted');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();

        showSnackBar(context, e.toString());
      }
    }
  }

  //delete dialogue box
  void showDeletediag(LostFound item) {
    showDialog(
      context: context,
      builder: (context) => DeleteAlertDiag(deletePost: deletePost, item: item),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        width: double.infinity,
        color: mainC,
        child: Stack(
          children: [
            ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(color: widC),
                  child: DrawerHeaderStream(),
                ),

                // header text
                Center(
                  child: Text(
                    'Your post',
                    style: TextStyle(
                      fontFamily: 'font',
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    'Mark as resolved',
                    style: TextStyle(
                      fontFamily: 'font',
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),

                //user post list
                Padding(
                  padding: const EdgeInsets.only(bottom: 80),
                  child: StreamBuilder(
                    stream: Supabase.instance.client
                        .from('lost_found')
                        .stream(primaryKey: ['id'])
                        .eq(
                          'user_id',
                          Supabase.instance.client.auth.currentUser!.id,
                        ),
                    builder: (context, snapshot) {
                      print(Supabase.instance.client.auth.currentUser!.id);
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Circle();
                      }
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            const SizedBox(height: 40),
                            Center(
                              child: Text(
                                "No items found",
                                style: TextStyle(
                                  fontFamily: 'font',
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        );
                      }

                      List<LostFound> allItem = snapshot.data!
                          .map((row) => LostFound.fromMap(row))
                          .toList();
                      allItem = allItem.reversed.toList();

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: allItem.length,
                        itemBuilder: (context, index) {
                          var item = allItem[index];
                          return Row(
                            children: [
                              GestureDetector(
                                onTap: !item.isResolved
                                    ? () {
                                        final imagePath = item.photoUrl;

                                        String? imageUrl;
                                        if (imagePath != null &&
                                            imagePath.isNotEmpty) {
                                          imageUrl = Supabase
                                              .instance
                                              .client
                                              .storage
                                              .from(
                                                'lost_found',
                                              ) // your bucket name
                                              .getPublicUrl(imagePath);
                                        }
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder:
                                                (
                                                  context,
                                                  animation,
                                                  secondaryAnimation,
                                                ) => LostFoundScreen(
                                                  item: item,
                                                  imageUrl: imageUrl,
                                                ),
                                            transitionsBuilder:
                                                (
                                                  context,
                                                  animation,
                                                  secondaryAnimation,
                                                  child,
                                                ) {
                                                  return ScaleTransition(
                                                    scale:
                                                        Tween<double>(
                                                          begin: 0.0,
                                                          end: 1.0,
                                                        ).animate(
                                                          CurvedAnimation(
                                                            parent: animation,
                                                            curve:
                                                                Curves.easeOut,
                                                          ),
                                                        ),
                                                    child: child,
                                                  );
                                                },
                                            transitionDuration: const Duration(
                                              milliseconds: 500,
                                            ),
                                          ),
                                        );
                                      }
                                    : null,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 15,
                                    left: 10,
                                  ),
                                  child: Stack(
                                    children: [
                                      //user post card
                                      UserPostCard(item: item),
                                      //edit button
                                      EditPostButton(item: item),

                                      //delete post button
                                      DeletePostButton(
                                        showDeletediag: showDeletediag,
                                        item: item,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 13),

                              //resolve toggle button
                              ResolveToggle(item: item),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),

            //signout button
            SignOutButton(signOut: signOut),
          ],
        ),
      ),
    );
  }
}
