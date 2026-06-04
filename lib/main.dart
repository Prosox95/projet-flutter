import 'package:flutter/material.dart';
import 'package:projet_flutter/supabase_keys.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:projet_flutter/screens/login_screen.dart';

Future<void> main() async {
  // Obligatoire quand on initialise des choses avant le runApp
  WidgetsFlutterBinding.ensureInitialized();

  // Connexion à ta base de données Supabase
  await Supabase.initialize(
    url: SupabaseKeys.url,
    anonKey: SupabaseKeys.anonKey,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catalogue de Produits',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginScreen(),
    );
  }
}
