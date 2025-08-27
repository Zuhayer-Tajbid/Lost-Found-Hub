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

class UpdateLostFound extends StatefulWidget {
  const UpdateLostFound({super.key, required this.item});

  final LostFound item;
  @override
  State<UpdateLostFound> createState() => _UpdateLostFoundState();
}

class _UpdateLostFoundState extends State<UpdateLostFound> {
  @override
  void dispose() {
    titleController.dispose();
    descripController.dispose();
    phoneController.dispose();
    fbController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    dateTimeStr = DateFormat(
      'dd MMM yyyy, hh:mm a',
    ).format(widget.item.dateTime);

    if (widget.item.title.isNotEmpty) {
      titleController.text = widget.item.title;
    }
    if (widget.item.description.isNotEmpty) {
      descripController.text = widget.item.description;
    }
    if (widget.item.facebook != null && widget.item.facebook!.isNotEmpty) {
      fbController.text = widget.item.facebook!;
    }
    if (widget.item.phone != null && widget.item.phone!.isNotEmpty) {
      phoneController.text = widget.item.phone!;
    }
    final imagePath =
        widget.item.photoUrl; // e.g. "upload/1755839811503044.png"

    if (imagePath != null && imagePath.isNotEmpty) {
      _existingImageUrl = Supabase.instance.client.storage
          .from('lost_found') // your bucket name
          .getPublicUrl(imagePath);
    }
  }

  TextEditingController titleController = TextEditingController();
  TextEditingController descripController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController fbController = TextEditingController();

  String? _existingImageUrl; // To store the network URL for existing image
  bool _isNewImagePicked = false;
  File? _image;
  final picker = ImagePicker();
  DateTime? pickedDateTime;
  String dateTimeStr = '';
  //datetime
  bool isPickedImage = false;

  //pick datetime
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
        _isNewImagePicked = true;
        _image = File(pickedImage.path);
        _existingImageUrl = null; // Clear existing URL when new image is picked
      });
    }
  }


//update lost found
  void updateLostFound() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      throw Exception("No user logged in!");
    }

    if (titleController.text.isEmpty || descripController.text.isEmpty) {
      showSnackBar(
        context,
        'Please fill out title,description and select time',
      );
      return;
    }

    String? photoPath = widget.item.photoUrl;
    if (_isNewImagePicked && _image != null) {
      final fileName = DateTime.now().microsecondsSinceEpoch.toString();
      photoPath = 'upload/$fileName';

      await Supabase.instance.client.storage
          .from('lost_found')
          .upload(photoPath, _image!);
    }

    final lostFound = LostFound(
      id: widget.item.id,
      userId: user.id,
      title: titleController.text.trim(),
      description: descripController.text.trim(),
      dateTime: pickedDateTime == null ? widget.item.dateTime : pickedDateTime!,
      isLost: widget.item.isLost,
      isResolved: false,
      facebook: fbController.text.isEmpty ? null : fbController.text.trim(),
      phone: phoneController.text.isEmpty ? null : phoneController.text.trim(),
      photoUrl: photoPath,
    );
    try {
      await Supabase.instance.client
          .from('lost_found')
          .update(lostFound.toMap())
          .eq('id', widget.item.id!);
      showSnackBar(context, 'Successfuly updated post');
      Navigator.pop(context);
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    String header = widget.item.isLost ? 'lost' : 'found';
    return Scaffold(
      backgroundColor: bodyC,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 40),
          child: Column(
            children: [

              //animation
              Lottie.network(
                'https://lottie.host/eb1d07b0-77e6-405a-af8d-257589fe1c28/aOsI51J2Bb.json',
                height: 200,
              ),
              const SizedBox(height: 10),

              //header text
              Text(
                'Update $header post',
                style: TextStyle(
                  fontFamily: 'font',
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),

              //name
              CreatePostField(
                controller: titleController,
                label: 'Title',
                hint: 'Found a watch/Lost an umbrella',
                icon: Icons.title,
                num: false,
                des: false,
              ),
              const SizedBox(height: 30),

              //description
              CreatePostField(
                controller: descripController,
                label: 'Description',
                hint: 'Found a watch/Lost an umbrella at room no 202',
                icon: Icons.description,
                num: false,
                des: true,
              ),
              const SizedBox(height: 40),
               
               //image
              GestureDetector(
                onTap: pickImage,
                child: _isNewImagePicked && _image != null
                    ? Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        width: 300,
                        height: 300,
                        child: Image.file(_image!, fit: BoxFit.cover),
                      )
                    : _existingImageUrl != null
                    ? Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        width: 300,
                        height: 300,
                        child: Image.network(
                          _existingImageUrl!,
                          fit: BoxFit.cover,
                        ),
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
             
             //time
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
                  IconButton(
                    onPressed: () async {
                      final result = await pickDateTime(); // call the picker
                      if (result != null) {
                        setState(() {
                          pickedDateTime = result;
                          dateTimeStr = DateFormat(
                            'dd MMM yyyy, hh:mm a',
                          ).format(result);
                        });

                        // If you want to save it as String in your LostFound class

                        debugPrint("📅 Picked DateTime: $dateTimeStr");
                      }
                    },
                    icon: Icon(Icons.watch_later_outlined, size: 50),
                  ),
                  const SizedBox(width: 10),
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

              //facebook
              CreatePostField(
                controller: fbController,
                hint: 'Enter Facebook id link',
                icon: FontAwesomeIcons.facebook,
                num: false,
                des: false,
                label: 'Facebook',
              ),
              const SizedBox(height: 30),

              //phone
              CreatePostField(
                controller: phoneController,
                hint: 'Enter phone number',
                icon: FontAwesomeIcons.phone,
                num: true,
                des: false,
                label: 'Phone Number',
              ),
              const SizedBox(height: 80),

              //update button
              ElevatedButton(
                onPressed: updateLostFound,
                style: btnstle,
                child: Text(
                  'Update Post',
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
