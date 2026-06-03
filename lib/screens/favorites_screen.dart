import 'package:flutter/material.dart';
import '../services/favorite_service.dart';
import '../services/product_api.dart';
import '../models/product.dart';
import '../widgets/favorite_button.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final FavoriteService _favoriteService = FavoriteService();
  final ProductApi _productApi = ProductApi();

  late Future<List<Product>> _favoriteProductsFuture;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() {
    _favoriteProductsFuture = _getFavoriteProducts();
  }

  Future<List<Product>> _getFavoriteProducts() async {
    // 1. On récupère les IDs stockés en local
    final favoriteIds = await _favoriteService.getFavoriteIds();

    if (favoriteIds.isEmpty) return [];

    // 2. On récupère tout le catalogue de l'API
    final allProducts = await _productApi.fetchProducts();

    // 3. On filtre pour ne garder que les produits dont l'ID est dans nos favoris
    return allProducts
        .where((product) => favoriteIds.contains(product.id))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mes Favoris')),
      body: FutureBuilder<List<Product>>(
        future: _favoriteProductsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          }

          final favoriteProducts = snapshot.data ?? [];

          // Si aucun ID n'est sauvegardé
          if (favoriteProducts.isEmpty) {
            return const Center(
              child: Text("Vous n'avez pas encore d'articles en favoris."),
            );
          }

          return ListView.builder(
            itemCount: favoriteProducts.length,
            itemBuilder: (context, index) {
              final product = favoriteProducts[index];
              return ListTile(
                leading: product.imageUrl.isNotEmpty
                    ? Image.network(
                        product.imageUrl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      )
                    : const Icon(Icons.image_not_supported),
                title: Text(product.title),
                subtitle: Text('${product.price.toStringAsFixed(2)} €'),
                // Notre bouton intelligent gère son propre état
                trailing: FavoriteButton(productId: product.id),
              );
            },
          );
        },
      ),
    );
  }
}
