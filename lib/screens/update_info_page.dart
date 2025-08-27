import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lost_found/constant/style.dart';
import 'package:lost_found/constant/ui_colour.dart';
import 'package:lost_found/provider/provider_helper.dart';
import 'package:lost_found/widgets/Auth%20widgets/namefield.dart';
import 'package:lost_found/widgets/Auth%20widgets/pass_field.dart';
import 'package:lost_found/widgets/Common%20widgets/circle.dart';
import 'package:lost_found/widgets/Common%20widgets/snack.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UpdateInfoPage extends StatefulWidget {
  const UpdateInfoPage({super.key});

  @override
  State<UpdateInfoPage> createState() => _UpdateInfoPageState();
}

class _UpdateInfoPageState extends State<UpdateInfoPage> {
  @override
  void dispose() {
    nameController.dispose();
    passController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmController = TextEditingController();
  var isPressed = false;

  File? _image;
  final picker = ImagePicker();

  void onIspressed() {
    if (isPressed) {
      isPressed = false;
    } else {
      isPressed = true;
    }
    setState(() {});
  }

  //reset password function
  Future<void> reset() async {
    if (passController.text != confirmController.text) {
      showSnackBar(
        context,
        'Passwords do not match. Please make sure both fields are identical',
      );
      return;
    }

    try {
      await context.read<ProviderHelper>().resetPass(
        passController.text.trim(),
      );
    } catch (e) {
      showSnackBar(context, 'reset${e.toString()}');
    }
  }

  //update info fucntion
  Future<void> updateInfo(String preImgpath, User user) async {
    // simple field validation before calling provider
    if (nameController.text.trim().isEmpty) {
      showSnackBar(context, "Name field cannot be empty");
      return;
    }

    try {
      var path = '';
      if (_image != null) {
        final fileName = DateTime.now().microsecondsSinceEpoch.toString();
        path = 'upload/$fileName';

        await Supabase.instance.client.storage
            .from('profile_pic')
            .upload(path, _image!);
      } else {
        path = preImgpath;
        print('previous url');
      }
      if (user == null) {
        showSnackBar(context, "User not found. Please log in again.");
        return; // Exit the function early
      }
      await Supabase.instance.client
          .from('profiles')
          .update({
            'id': user.id,
            'name': nameController.text.trim(),
            'photo_url': path,
          })
          .eq('id', user.id);

      if (confirmController.text.isNotEmpty && passController.text.isNotEmpty) {
        await reset();
        print('reseted');
      }

      Navigator.pop(context);

      showSnackBar(context, "Info Updated successfully!");
    } catch (e) {
      // Catch any error thrown from provider or insert
      showSnackBar(context, 'main${e.toString()}');
    }
  }

  //pickimage
  Future<void> pickImage() async {
    var pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyC,
      body: StreamBuilder<AuthState>(
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

                nameController.text = profile?['name'];

                return SafeArea(
                  child: SingleChildScrollView(
                    child: Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 30),

                          //header text
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Update Info',
                                style: TextStyle(
                                  fontFamily: 'font',
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Icon(
                                Icons.edit_document,
                                color: Colors.black,
                                size: 40,
                              ),
                            ],
                          ),
                          const SizedBox(height: 50),

                          //namefield
                          Namefield(nameController: nameController),
                          const SizedBox(height: 30),

                          //pick image
                          GestureDetector(
                            onTap: pickImage,
                            child: CircleAvatar(
                              radius: 100,
                              child: _image != null
                                  ? ClipOval(
                                      child: Image.file(
                                        _image!,
                                        width: 200,
                                        height: 200,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : FaIcon(
                                      FontAwesomeIcons.cameraRetro,
                                      size: 40,
                                    ),
                            ),
                          ),
                          const SizedBox(height: 30),

                          //password field
                          PassField(
                            passController: passController,
                            onIspressed: onIspressed,
                            isPressed: isPressed,
                            hint: 'Enter your password',
                          ),
                          const SizedBox(height: 20),

                          //confirm password field
                          PassField(
                            passController: confirmController,
                            onIspressed: onIspressed,
                            isPressed: isPressed,
                            hint: 'Confirm password',
                          ),
                          const SizedBox(height: 80),

                          //update button
                          ElevatedButton(
                            onPressed: () {
                              updateInfo(imagePath, user);
                            },
                            style: btnstle,
                            child: Text(
                              'update',
                              style: TextStyle(
                                fontFamily: 'font',
                                color: Colors.black,
                                fontSize: 25,
                              ),
                            ),
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
      ),
    );
  }
}
