import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/product.dart';
import '../services/product_api.dart';
import 'product_detail_screen.dart';
import '../widgets/favorite_button.dart';
import '../services/cart_service.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ProductApi _productApi = ProductApi();
  late Future<List<Product>> _futureProducts;

  @override
  void initState() {
    super.initState();
    _futureProducts = _productApi.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Liste des produits')),
      body: FutureBuilder<List<Product>>(
        future: _futureProducts,
        builder: (context, snapshot) {
          // Chargement
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Erreur
          if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          }

          final products = snapshot.data ?? [];

          // Liste vide
          if (products.isEmpty) {
            return const Center(child: Text('Aucun produit disponible'));
          }

          // Liste OK
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];

              return ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: Icon(Icons.shopping_bag, color: Colors.white),
                ),
                title: Text(product.title),
                subtitle: Text('${product.price.toStringAsFixed(2)} €'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailScreen(product: product),
                    ),
                  );
                },
                trailing: Row(
                  mainAxisSize: MainAxisSize
                      .min, // Crucial pour ne pas faire exploser le design
                  children: [
                    FavoriteButton(productId: product.id),
                    IconButton(
                      icon: const Icon(Icons.add_shopping_cart),
                      onPressed: () async {
                        // 1. On ajoute au panier en base locale
                        await CartService().addToCart(product.id);

                        // 2. On affiche un petit message temporaire en bas de l'écran (SnackBar)
                        // Le if (context.mounted) est une sécurité en Flutter asynchrone
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${product.title} ajouté au panier',
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
