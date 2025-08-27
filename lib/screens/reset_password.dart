import 'package:flutter/material.dart';
import 'package:lost_found/constant/ui_colour.dart';
import 'package:lost_found/provider/provider_helper.dart';
import 'package:lost_found/screens/login_page.dart';
import 'package:lost_found/widgets/Auth%20widgets/pass_field.dart';
import 'package:lost_found/widgets/Common%20widgets/snack.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  @override
  void dispose() {
    confirmController.dispose();
    passController.dispose();
    super.dispose();
  }

  TextEditingController passController = TextEditingController();
  TextEditingController confirmController = TextEditingController();

  var isPressed = false;

  void onIspressed() {
    if (isPressed) {
      isPressed = false;
    } else {
      isPressed = true;
    }
    setState(() {});
  }

  //reset function
  void reset() async {
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
      showSnackBar(context, 'Password has been reset successfully');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyC,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              //animation
              Lottie.network(
                'https://lottie.host/6a0da49d-6aa3-4fe4-babb-c5cc28573771/sTJgTxmjXR.json',
                height: 250,
              ),
              const SizedBox(height: 30),

              //header text
              Text(
                'Reset Password',
                style: TextStyle(
                  fontFamily: 'font',
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              //password field
              const SizedBox(height: 40),
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

              //reset button
              ElevatedButton(
                onPressed: reset,
                style: ElevatedButton.styleFrom(
                  side: BorderSide(color: Colors.black, width: 2),
                  backgroundColor: mainC1,

                  fixedSize: Size(200, 65),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(15),
                  ),
                ),
                child: Text(
                  'Reset',
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
