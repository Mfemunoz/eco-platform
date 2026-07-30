import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screens/login/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://pwexbwinxvpvfwhcrpbi.supabase.co',

    anonKey: 'sb_publishable_F3-C5kTxfD8Vy0FoQTNkTQ_WulJ8wlt',
  );

  runApp(const EcoApp());
}

class EcoApp extends StatelessWidget {
  const EcoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ECO Platform',

      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),

        useMaterial3: true,
      ),

      home: const LoginPage(),
    );
  }
}
