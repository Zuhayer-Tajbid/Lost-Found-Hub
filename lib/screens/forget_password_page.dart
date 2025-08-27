import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lost_found/constant/ui_colour.dart';
import 'package:lost_found/provider/provider_helper.dart';
import 'package:lost_found/widgets/Auth%20widgets/email_field.dart';
import 'package:lost_found/widgets/Common%20widgets/snack.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  @override
  void dispose() {
    emailController.dispose();

    super.dispose();
  }

  TextEditingController emailController = TextEditingController();

  //send reset link gmail
  void sendMail() async {
    if (emailController.text.isEmpty) {
      showSnackBar(context, 'Please fill up the email-field');
      return;
    }

    try {
      await context.read<ProviderHelper>().resetMail(
        emailController.text.trim(),
      );
      showSnackBar(context, 'Reset link has been sent');
      Navigator.pop(context);
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyC,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //animation
                Lottie.network(
                  'https://lottie.host/42d7487a-7b45-4b85-9755-967e6769bd7f/cTOPsFP3Xw.json',
                  height: 200,
                ),
                const SizedBox(height: 30),

                //header text
                Text(
                  'Forgot Password',
                  style: TextStyle(
                    fontFamily: 'font',
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Enter your email to reset password',
                  style: TextStyle(
                    fontFamily: 'font',
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 20),

                //email field
                EmailField(emailController: emailController),
                const SizedBox(height: 25),

                //instruction text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: Row(
                    children: [
                      FaIcon(FontAwesomeIcons.featherPointed),
                      const SizedBox(width: 7),
                      Expanded(
                        child: Text(
                          'An email will be sent with password reset link',
                          style: TextStyle(
                            fontFamily: 'font',
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 7),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: Row(
                    children: [
                      FaIcon(FontAwesomeIcons.featherPointed),
                      const SizedBox(width: 7),
                      Expanded(
                        child: Text(
                          'Open that link to reset password in app',
                          style: TextStyle(
                            fontFamily: 'font',
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 70),

                //send mail button
                ElevatedButton(
                  onPressed: sendMail,
                  style: ElevatedButton.styleFrom(
                    side: BorderSide(color: Colors.black, width: 2),
                    backgroundColor: mainC1,

                    fixedSize: Size(200, 65),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(15),
                    ),
                  ),
                  child: Text(
                    'Continue',
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
