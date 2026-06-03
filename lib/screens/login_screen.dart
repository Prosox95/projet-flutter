import 'package:flutter/material.dart';
import 'package:projet_flutter/services/auth_utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'main_screen.dart'; // On importe l'écran principal pour la redirection
import 'register_screen.dart'; // On importe l'écran d'inscription pour le lien "S'inscrire"

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Les controllers permettent de lire ce que l'utilisateur tape dans les champs
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Clé globale pour valider le formulaire (vérifier si les champs sont vides etc.)
  final _formKey = GlobalKey<FormState>();

  // Fonction déclenchée au clic sur "Se connecter"
  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Appel officiel à Supabase pour connecter l'utilisateur
        await Supabase.instance.client.auth.signInWithPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Si on arrive ici sans erreur, c'est que c'est bon
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainScreen()),
          );
        }
      } on AuthException catch (e) {
        // Gestion des erreurs (mauvais mot de passe, utilisateur inexistant, etc.)
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(translateAuthError(e.message)),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        // Erreur réseau ou autre
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Une erreur est survenue."),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  // C'est important de "nettoyer" les controllers quand l'écran est détruit pour libérer la mémoire
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey, // On lie la clé au formulaire
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.lock_person, size: 100, color: Colors.blue),
                const SizedBox(height: 32),
                const Text(
                  'Bienvenue',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),

                // Champ Email
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Champ Mot de passe
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Mot de passe',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true, // Cache les caractères (points noirs)
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre mot de passe';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Bouton de connexion
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _login,
                  child: const Text(
                    'Se connecter',
                    style: TextStyle(fontSize: 18),
                  ),
                ),

                // Bouton pour aller vers l'inscription
                TextButton(
                  onPressed: () {
                    // On redirige vers l'écran d'inscription
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterScreen(),
                      ),
                    );
                  },
                  child: const Text("Pas encore de compte ? S'inscrire"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
