import 'package:flutter/material.dart';

import 'package:lost_found/constant/ui_colour.dart';
import 'package:lost_found/model/lost_found.dart';

import 'package:lost_found/screens/lost_found_screen.dart';
import 'package:lost_found/screens/profile_drawer.dart';
import 'package:lost_found/widgets/Home%20page%20widgets/add_alert.dart';
import 'package:lost_found/widgets/Home%20page%20widgets/create_post_button.dart';
import 'package:lost_found/widgets/Home%20page%20widgets/gnav_bottom.dart';
import 'package:lost_found/widgets/Lost%20Found%20widgets/lost_found_card.dart';
import 'package:lost_found/widgets/Home%20page%20widgets/post_profile_tile.dart';
import 'package:lost_found/widgets/Home%20page%20widgets/profile_tile.dart';
import 'package:lost_found/widgets/Home%20page%20widgets/search_field.dart';
import 'package:lost_found/widgets/Common%20widgets/circle.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchController = TextEditingController();
  int _selectedpageIndex = 0;
  List<LostFound> selectedList = [];
  List<LostFound> allItem = []; // Store all items
  List<LostFound> lostList = []; // Store lost items
  List<LostFound> foundList = [];
  List<LostFound> filteredList = [];

  String header = 'Lost & Found Post';

  void showAddDialog() {
    showDialog(context: context, builder: (context) => AddAlert());
  }

  //search filter function
  void filter(String keyWord) {
    if (keyWord.isEmpty) {
      // Reset to the original filtered list based on selected page
      setState(() {
        if (_selectedpageIndex == 0) {
          selectedList = allItem;
        } else if (_selectedpageIndex == 1) {
          selectedList = lostList;
        } else {
          selectedList = foundList;
        }
        selectedList = selectedList.reversed.toList();
      });
    } else {
      // Filter from the appropriate original list
      List<LostFound> sourceList;
      if (_selectedpageIndex == 0) {
        sourceList = allItem;
      } else if (_selectedpageIndex == 1) {
        sourceList = lostList;
      } else {
        sourceList = foundList;
      }

      filteredList = sourceList
          .where(
            (item) =>
                item.description.toLowerCase().contains(
                  keyWord.toLowerCase(),
                ) ||
                item.title.toLowerCase().contains(keyWord.toLowerCase()),
          )
          .toList()
          .reversed
          .toList();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    String header;
    if (_selectedpageIndex == 0) {
      header = 'Lost & Found Post';
    } else if (_selectedpageIndex == 1) {
      header = 'Lost Post';
    } else {
      header = 'Found Post';
    }
    return Scaffold(
      drawer: ProfileDrawer(),
      backgroundColor: bodyC,
      bottomNavigationBar: GnavBottom(
        selectedpageIndex: _selectedpageIndex,
        onTabChange: (index) {
          setState(() {
            _selectedpageIndex = index;
          });
        },
      ),

      body: SafeArea(
        child: Column(
          children: [
            //profile tile
            ProfileTile(),

            const SizedBox(height: 15),
            Row(
              children: [
                const SizedBox(width: 25),

                //search field
                SearchField(controller: searchController, filter: filter),
                const SizedBox(width: 15),

                //create post button
                CreatePostButton(showAddDialog: showAddDialog),
              ],
            ),
            const SizedBox(height: 30),

            //header text
            Text(
              header,
              style: TextStyle(
                fontFamily: 'font',
                fontWeight: FontWeight.w500,
                fontSize: 25,
              ),
            ),
            const SizedBox(height: 10),

            ///lost found item
            Expanded(
              child: StreamBuilder(
                stream: Supabase.instance.client
                    .from('lost_found')
                    .stream(primaryKey: ['id']),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Circle();
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No items found"));
                  }
                  if (searchController.text.isEmpty) {
                    allItem = snapshot.data!
                        .map((row) => LostFound.fromMap(row))
                        .toList();
                    lostList = allItem.where((item) => item.isLost).toList();
                    foundList = allItem.where((item) => !item.isLost).toList();
                    if (_selectedpageIndex == 0) {
                      selectedList = allItem;
                    } else if (_selectedpageIndex == 1) {
                      selectedList = lostList;
                    } else {
                      selectedList = foundList;
                    }
                  } else {
                    lostList = filteredList
                        .where((item) => item.isLost)
                        .toList();
                    foundList = filteredList
                        .where((item) => !item.isLost)
                        .toList();
                    if (_selectedpageIndex == 0) {
                      selectedList = filteredList;
                    } else if (_selectedpageIndex == 1) {
                      selectedList = lostList;
                    } else {
                      selectedList = foundList;
                    }
                  }

                  selectedList = selectedList.reversed.toList();
                  return ListView.builder(
                    itemCount: selectedList.length,
                    itemBuilder: (context, index) {
                      var item = selectedList[index];
                      final imagePath = item.photoUrl;

                      String? imageUrl;
                      if (imagePath != null && imagePath.isNotEmpty) {
                        imageUrl = Supabase.instance.client.storage
                            .from('lost_found')
                            .getPublicUrl(imagePath);
                      }

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          PostProfileTile(item: item, isHome: true),
                          GestureDetector(
                            onTap: () {
                              item.isResolved
                                  ? null
                                  : Navigator.push(
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
                                                        curve: Curves.easeOut,
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
                            },
                            child: LostFoundCard(
                              item: item,
                              imageUrl: imageUrl,
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
