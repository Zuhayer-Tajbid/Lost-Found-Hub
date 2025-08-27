import 'package:flutter/material.dart';
import 'package:lost_found/provider/provider_helper.dart';
import 'package:lost_found/screens/auth_gate.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://dufckjwwbemzgsseenju.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImR1ZmNrand3YmVtemdzc2Vlbmp1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTU3ODQyMDAsImV4cCI6MjA3MTM2MDIwMH0.vUn9DdntkLcQEQagNY4dvsQrAnZaNV8ttvMoucJ9fFw',
  );
  runApp(
    ChangeNotifierProvider(
      create: (_) => ProviderHelper(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: AuthGate());
  }
}
