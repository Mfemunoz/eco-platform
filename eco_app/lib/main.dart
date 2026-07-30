import 'package:flutter/material.dart';
import 'services/supabase_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SupabaseService.initialize();

  runApp(const EcoApp());
}

class EcoApp extends StatelessWidget {
  const EcoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ECO Platform',
      home: Scaffold(
        appBar: AppBar(title: const Text('ECO Platform')),
        body: const Center(
          child: Text(
            'Conectado a Supabase 🚀',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
