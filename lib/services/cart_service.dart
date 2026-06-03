import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartService {
  // Une clé spécifique au panier, différente des favoris
  static const String _cartKey = 'cart_product_ids';

  // Récupère la liste des IDs présents dans le panier
  Future<List<int>> getCartIds() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> stringIds = prefs.getStringList(_cartKey) ?? [];

    debugPrint("=== DEBUG PANIER: IDs récupérés : $stringIds ===");
    return stringIds.map((id) => int.parse(id)).toList();
  }

  // Ajoute un produit au panier
  Future<void> addToCart(int productId) async {
    final prefs = await SharedPreferences.getInstance();
    List<int> currentCart = await getCartIds();

    currentCart.add(productId); // On ajoute l'ID à la liste
    debugPrint("=== DEBUG PANIER: Ajout de l'ID $productId ===");

    List<String> stringsToSave = currentCart
        .map((id) => id.toString())
        .toList();
    await prefs.setStringList(_cartKey, stringsToSave);
  }

  // Retire une occurrence d'un produit du panier
  Future<void> removeFromCart(int productId) async {
    final prefs = await SharedPreferences.getInstance();
    List<int> currentCart = await getCartIds();

    // On supprime seulement la première occurrence trouvée (au cas où il y en a plusieurs)
    if (currentCart.contains(productId)) {
      currentCart.remove(productId);
      debugPrint("=== DEBUG PANIER: Retrait de l'ID $productId ===");

      List<String> stringsToSave = currentCart
          .map((id) => id.toString())
          .toList();
      await prefs.setStringList(_cartKey, stringsToSave);
    }
  }

  // Vide complètement le panier (utile pour la validation de commande)
  Future<void> clearCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cartKey);
    debugPrint("=== DEBUG PANIER: Panier vidé ===");
  }
}
