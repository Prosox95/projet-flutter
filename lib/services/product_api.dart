import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product.dart';

class ProductApi {
  // On récupère l'instance de Supabase initialisée dans main.dart
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Product>> fetchProducts() async {
    try {
      // On requête la table 'products'
      final response = await _supabase.from('products').select();

      // Supabase renvoie une liste de Map (JSON)
      final List<dynamic> data = response as List<dynamic>;

      // On convertit cette liste en objets Product
      return data.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      print("Erreur lors de la récupération des produits : $e");
      return [];
    }
  }
}
