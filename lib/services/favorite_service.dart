import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteService {
  // Clé utilisée pour stocker les données dans les SharedPreferences
  static const String _favoritesKey = 'favorite_product_ids';

  // Récupère la liste des IDs favoris depuis le stockage local
  Future<List<int>> getFavoriteIds() async {
    final prefs = await SharedPreferences.getInstance();

    // Les SharedPreferences stockent des listes de String.
    // On récupère la liste, ou une liste vide si rien n'est sauvegardé.
    final List<String> stringIds = prefs.getStringList(_favoritesKey) ?? [];

    debugPrint("=== DEBUG: IDs récupérés depuis la mémoire : $stringIds ===");

    // On convertit les String en int car nos IDs de produits sont des entiers
    return stringIds.map((id) => int.parse(id)).toList();
  }

  // Ajoute ou supprime un ID de la liste des favoris
  Future<void> toggleFavorite(int productId) async {
    final prefs = await SharedPreferences.getInstance();

    // On récupère l'état actuel
    List<int> currentFavorites = await getFavoriteIds();

    // Logique de bascule (toggle)
    if (currentFavorites.contains(productId)) {
      currentFavorites.remove(productId);
      debugPrint("=== DEBUG: Retrait de l'ID $productId ===");
    } else {
      currentFavorites.add(productId);
      debugPrint("=== DEBUG: Ajout de l'ID $productId ===");
    }

    // On reconvertit en String pour la sauvegarde
    List<String> stringsToSave = currentFavorites
        .map((id) => id.toString())
        .toList();
    await prefs.setStringList(_favoritesKey, stringsToSave);

    debugPrint("=== DEBUG: Nouvelle liste sauvegardée : $stringsToSave ===");
  }

  // Vérifie si un produit spécifique est en favori
  Future<bool> isFavorite(int productId) async {
    final currentFavorites = await getFavoriteIds();
    return currentFavorites.contains(productId);
  }
}
