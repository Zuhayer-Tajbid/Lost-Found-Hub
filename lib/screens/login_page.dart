import 'package:flutter/material.dart';
import 'package:lost_found/constant/style.dart';
import 'package:lost_found/constant/ui_colour.dart';
import 'package:lost_found/provider/provider_helper.dart';

import 'package:lost_found/screens/home_page.dart';

import 'package:lost_found/widgets/Auth%20widgets/email_field.dart';
import 'package:lost_found/widgets/Auth%20widgets/forgot_password_text.dart';
import 'package:lost_found/widgets/Auth%20widgets/pass_field.dart';
import 'package:lost_found/widgets/Auth%20widgets/sign_up_button.dart';
import 'package:lost_found/widgets/Common%20widgets/snack.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  var isPressed = false;

  //for password field
  void onIspressed() {
    if (isPressed) {
      isPressed = false;
    } else {
      isPressed = true;
    }
    setState(() {});
  }

  //signin function
  Future<void> signIn() async {
    try {
      await context.read<ProviderHelper>().login(
        emailController.text.trim(),
        passController.text.trim(),
      );

      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const HomePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 1000),
        ),
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
            children: [
              //animation
              Lottie.network(
                'https://lottie.host/f8088506-0e95-4043-9fe9-63ff69602397/mSagMfkhzt.json',
                height: 270,
              ),

              //welcome text
              Text(
                'Welcome to Lost & Found Hub',
                style: TextStyle(
                  fontFamily: 'font',
                  fontWeight: FontWeight.w500,
                  fontSize: 26,
                ),
              ),
              const SizedBox(height: 40),

              //email field
              EmailField(emailController: emailController),
              const SizedBox(height: 20),

              //password field
              PassField(
                passController: passController,
                onIspressed: onIspressed,
                isPressed: isPressed,
                hint: 'Enter your password',
              ),

              //forgot password
              ForgotPasswordText(),

              const SizedBox(height: 60),

              //login button
              ElevatedButton(
                onPressed: signIn,
                style: btnstle,
                child: Text(
                  'Login',
                  style: TextStyle(
                    fontFamily: 'font',
                    color: Colors.black,
                    fontSize: 25,
                  ),
                ),
              ),
              const SizedBox(height: 15),

              //signup text
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don\'t have an account?',
                    style: TextStyle(
                      fontFamily: 'font',
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(width: 7),

                  //signup button
                  SignUpButton(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
