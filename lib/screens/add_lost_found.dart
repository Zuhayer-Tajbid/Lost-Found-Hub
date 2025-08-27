import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lost_found/constant/style.dart';
import 'package:lost_found/constant/ui_colour.dart';
import 'package:lost_found/model/lost_found.dart';
import 'package:lost_found/widgets/Create%20post%20page%20widgets/create_post_field.dart';
import 'package:lost_found/widgets/Common%20widgets/snack.dart';
import 'package:lottie/lottie.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddLostFound extends StatefulWidget {
  const AddLostFound({super.key, required this.isLost});

  final bool isLost;

  @override
  State<AddLostFound> createState() => _AddLostFoundState();
}

class _AddLostFoundState extends State<AddLostFound> {
  @override
  void dispose() {
    titleController.dispose();
    descripController.dispose();
    phoneController.dispose();
    fbController.dispose();
    super.dispose();
  }

  TextEditingController titleController = TextEditingController();
  TextEditingController descripController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController fbController = TextEditingController();

  File? _image;
  final picker = ImagePicker();
  DateTime? pickedDateTime;
  String dateTimeStr = '';

  //datetime picker function
  Future<DateTime?> pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime.now(),
      initialDate: DateTime.now(),
    );

    if (date == null) return null;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time == null) return DateTime(date.year, date.month, date.day);

    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
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

  //add lost found
  void addLostFound() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      throw Exception("No user logged in!");
    }

    if (titleController.text.isEmpty ||
        descripController.text.isEmpty ||
        pickedDateTime == null) {
      showSnackBar(
        context,
        'Please fill out title,description and select time',
      );
      return;
    }

    var path = '';
    if (_image != null) {
      final fileName = DateTime.now().microsecondsSinceEpoch.toString();
      path = 'upload/$fileName';

      await Supabase.instance.client.storage
          .from('lost_found')
          .upload(path, _image!);
    }

    final lostFound = LostFound(
      userId: user.id,
      title: titleController.text.trim(),
      description: descripController.text.trim(),
      dateTime: pickedDateTime!,
      isLost: widget.isLost,
      isResolved: false,
      facebook: fbController.text.isEmpty ? null : fbController.text.trim(),
      phone: phoneController.text.isEmpty ? null : phoneController.text.trim(),
      photoUrl: path.isEmpty ? null : path,
    );
    try {
      await Supabase.instance.client
          .from('lost_found')
          .insert(lostFound.toMap());
      showSnackBar(context, 'Successfuly created post');
      Navigator.pop(context);
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isLost = widget.isLost;
    String header = isLost ? 'lost' : 'found';

    return Scaffold(
      backgroundColor: bodyC,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 40),
          child: Column(
            children: [
              //animation
              Lottie.network(
                'https://lottie.host/e182a480-1f98-45e8-924d-33e6990c5f0c/uNmeNYXzcr.json',
                height: 200,
              ),
              const SizedBox(height: 10),

              //header text
              Text(
                'Create $header post',
                style: TextStyle(
                  fontFamily: 'font',
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),

              //title field
              CreatePostField(
                controller: titleController,
                label: 'Title',
                hint: 'Found a watch/Lost an umbrella',
                icon: Icons.title,
                num: false,
                des: false,
              ),
              const SizedBox(height: 30),

              //description field
              CreatePostField(
                controller: descripController,
                label: 'Description',
                hint: 'Found a watch/Lost an umbrella at room no 202',
                icon: Icons.description,
                num: false,
                des: true,
              ),
              const SizedBox(height: 40),

              //pick image
              GestureDetector(
                onTap: pickImage,
                child: _image != null
                    ? Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        width: 300,
                        height: 300,
                        child: Image.file(_image!, fit: BoxFit.cover),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black, width: 2),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(30),
                          child: Icon(Icons.image, size: 100),
                        ),
                      ),
              ),

              const SizedBox(height: 60),

              Row(
                children: [
                  const SizedBox(width: 40),
                  Text(
                    'Pick Time:',
                    style: TextStyle(
                      fontFamily: 'font',
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 10),

                  //datetime picker
                  IconButton(
                    onPressed: () async {
                      final result = await pickDateTime();
                      if (result != null) {
                        setState(() {
                          pickedDateTime = result;
                          dateTimeStr = DateFormat(
                            'dd MMM yyyy, hh:mm a',
                          ).format(result);
                        });
                        debugPrint("📅 Picked DateTime: $dateTimeStr");
                      }
                    },
                    icon: Icon(Icons.watch_later_outlined, size: 50),
                  ),

                  const SizedBox(width: 10),

                  //picked date time text
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Text(
                        dateTimeStr,
                        style: TextStyle(
                          fontFamily: 'font',
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                        softWrap: true,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 5,
                ),
                child: Row(
                  children: [
                    Text(
                      '(Optional)',
                      style: TextStyle(fontFamily: 'font', fontSize: 16),
                    ),
                  ],
                ),
              ),
              //facebook field
              CreatePostField(
                controller: fbController,
                hint: 'Enter Facebook id link',
                icon: FontAwesomeIcons.facebook,
                num: false,
                des: false,
                label: 'Facebook',
              ),
              const SizedBox(height: 30),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 5,
                ),
                child: Row(
                  children: [
                    Text(
                      '(Optional)',
                      style: TextStyle(fontFamily: 'font', fontSize: 16),
                    ),
                  ],
                ),
              ),
              //phone number field
              CreatePostField(
                controller: phoneController,
                hint: 'Enter phone number',
                icon: FontAwesomeIcons.phone,
                num: true,
                des: false,
                label: 'Phone Number',
              ),
              const SizedBox(height: 80),

              //create post button
              ElevatedButton(
                onPressed: addLostFound,
                style: btnstle,
                child: Text(
                  'Create Post',
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
  }
}
