import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/product.dart';
import '../widgets/favorite_button.dart';
import '../services/cart_service.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails du produit'),
        actions: [
          // Réutilisation du composant FavoriteButton : aucune logique métier à réécrire ici
          FavoriteButton(productId: product.id),
        ],
      ),
      // SingleChildScrollView permet de scroller si le contenu dépasse la taille de l'écran
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Affichage de l'image
            // Affichage d'une icône générique à la place de l'image
            const Center(
              child: Icon(
                Icons.shopping_bag,
                size: 150,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 24),
            const SizedBox(height: 24),

            // Titre
            Text(
              product.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Prix
            Text(
              '${product.price.toStringAsFixed(2)} €',
              style: const TextStyle(
                fontSize: 22,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            // Description (l'API Platzi fournit un champ description)
            const Text(
              'Description',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              // On met une valeur par défaut au cas où la description serait null
              product.description ??
                  'Aucune description disponible pour cet article.',
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 40),

            // Call To Action : Ajout au panier
            SizedBox(
              width: double.infinity, // Le bouton prend toute la largeur
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text(
                  'Ajouter au panier',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                onPressed: () async {
                  // Appel direct au service du panier
                  await CartService().addToCart(product.id);

                  // Feedback visuel pour l'utilisateur
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${product.title} ajouté au panier'),
                        duration: const Duration(seconds: 2),
                        action: SnackBarAction(
                          label: 'VOIR',
                          textColor: Colors.white,
                          onPressed: () {
                            // Optionnel : on pourrait naviguer vers le panier ici,
                            // mais on va laisser l'utilisateur utiliser la BottomNavigationBar
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
