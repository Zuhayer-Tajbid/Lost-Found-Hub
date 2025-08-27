import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lost_found/constant/style.dart';
import 'package:lost_found/constant/ui_colour.dart';
import 'package:lost_found/provider/provider_helper.dart';
import 'package:lost_found/screens/login_page.dart';
import 'package:lost_found/widgets/Auth%20widgets/email_field.dart';
import 'package:lost_found/widgets/Auth%20widgets/namefield.dart';
import 'package:lost_found/widgets/Auth%20widgets/pass_field.dart';
import 'package:lost_found/widgets/Common%20widgets/snack.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  var isPressed = false;

  File? _image;
  final picker = ImagePicker();

  //pickimage
  Future<void> pickImage() async {
    var pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  //signup
  Future<void> createAccount() async {
    // simple field validation before calling provider
    if (nameController.text.trim().isEmpty) {
      showSnackBar(context, "Name field cannot be empty");
      return;
    }

    try {
      await context.read<ProviderHelper>().signUp(
        emailController.text.trim(),
        passController.text.trim(),
      );

      final user = context.read<ProviderHelper>().user;

      var path = '';
      if (_image != null) {
        final fileName = DateTime.now().microsecondsSinceEpoch.toString();
        path = 'upload/$fileName';

        await Supabase.instance.client.storage
            .from('profile_pic')
            .upload(path, _image!);
      }

      await Supabase.instance.client.from('profiles').insert({
        'id': user!.id,
        'name': nameController.text.trim(),
        'photo_url': path,
      });

      showSnackBar(context, "Account created successfully!");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (e) {
      // Catch any error thrown from provider or insert
      showSnackBar(context, e.toString());
    }
  }

//password field toggle
  void onIspressed() {
    if (isPressed) {
      isPressed = false;
    } else {
      isPressed = true;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyC,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 40),
          child: Center(
            child: Column(
              children: [
                //animation
                Lottie.network(
                  'https://lottie.host/f16c8778-c5af-4c28-84e0-45e19a3a2b25/Ka5oKtH8y4.json',
                  height: 250,
                ),

                //signup text
                Text(
                  'Create your account',
                  style: TextStyle(
                    fontFamily: 'font',
                    color: Colors.black,
                    fontSize: 25,
                  ),
                ),

                const SizedBox(height: 20),
                //email field
                EmailField(emailController: emailController),
                const SizedBox(height: 20),

                //password field
                PassField(
                  hint: 'Enter your password',
                  passController: passController,
                  onIspressed: onIspressed,
                  isPressed: isPressed,
                ),
                const SizedBox(height: 20),

                //namefield
                Namefield(nameController: nameController),
                const SizedBox(height: 40),

                //picture text
                Row(
                  children: [
                    const SizedBox(width: 35),
                    Text(
                      'Select profile picture',
                      style: TextStyle(fontFamily: 'font', fontSize: 22),
                    ),
                  ],
                ),
                const SizedBox(height: 15),

                //photo
                GestureDetector(
                  onTap: pickImage,
                  child: CircleAvatar(
                    backgroundColor: mainC,
                    radius: 100,
                    child: _image != null
                        ? ClipOval(
                            child: Image.file(
                              _image!,
                              width: 200, // must match diameter
                              height: 200,
                              fit: BoxFit.cover, // makes it fill properly
                            ),
                          )
                        : FaIcon(
                            FontAwesomeIcons.cameraRetro,
                            size: 40,
                            color: Colors.black,
                          ),
                  ),
                ),
                const SizedBox(height: 30),

                //signup button
                ElevatedButton(
                  onPressed: createAccount,
                  style: btnstle,
                  child: Text(
                    'Sign Up',
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
      ),
    );
  }
}
