import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';

import 'package:lost_found/screens/home_page.dart';
import 'package:lost_found/screens/login_page.dart';
import 'package:lost_found/screens/reset_password.dart';
import 'package:lost_found/screens/splash_screen.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _showSplash = true;
  StreamSubscription<Uri>? _sub;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _showSplash = false;
        });
      }
    });

    final appLinks = AppLinks(); // AppLinks is singleton

    final sub = appLinks.uriLinkStream.listen((uri) {
      if (uri.host == 'reset-password') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ResetPassword()),
        );
      }
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_showSplash) {
      return const SplashScreen();
    }

    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SplashScreen();
        }
        final session = snapshot.data?.session;

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 700),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(parent: animation, curve: Curves.easeOut),
                  ),
              child: FadeTransition(opacity: animation, child: child),
            );
          },
          child: session != null
              ? const HomePage(key: ValueKey('HomePage'))
              : const LoginPage(key: ValueKey('LoginPage')),
        );
      },
    );
  }
}
