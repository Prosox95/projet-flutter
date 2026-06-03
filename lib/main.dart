import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:projet_flutter/screens/login_screen.dart';

Future<void> main() async {
  // Obligatoire quand on initialise des choses avant le runApp
  WidgetsFlutterBinding.ensureInitialized();

  // Connexion à ta base de données Supabase
  await Supabase.initialize(
    url: 'https://xhqmziiraznvaxnkarad.supabase.co', // Colle ton URL ici
    anonKey:
        'sb_publishable_446xsF5trf91hSA8s-MP3Q_yLIMaWm_', // Colle ta clé ici
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
