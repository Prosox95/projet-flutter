import 'package:flutter/material.dart';
import '../services/cart_service.dart';
import '../services/product_api.dart';
import '../models/product.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartService _cartService = CartService();
  final ProductApi _productApi = ProductApi();

  bool _isLoading = true;
  List<Product> _cartItems = [];
  double _totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  // Fonction centrale : charge les IDs, télécharge les produits, et fait le rapprochement
  Future<void> _loadCart() async {
    setState(() => _isLoading = true);

    // 1. On récupère les IDs sauvegardés
    final cartIds = await _cartService.getCartIds();

    if (cartIds.isEmpty) {
      setState(() {
        _cartItems = [];
        _totalPrice = 0.0;
        _isLoading = false;
      });
      return;
    }

    // 2. On récupère le catalogue de produits depuis l'API
    final allProducts = await _productApi.fetchProducts();

    // 3. On reconstruit la liste du panier (en gardant les doublons) et on calcule le total
    List<Product> items = [];
    double total = 0.0;

    for (int id in cartIds) {
      try {
        // firstWhere trouve le produit qui correspond à l'ID
        final product = allProducts.firstWhere((p) => p.id == id);
        items.add(product);
        total += product.price; // On additionne au fur et à mesure
      } catch (e) {
        // Si le produit n'existe plus dans l'API, on l'ignore silencieusement
      }
    }

    // 4. On met à jour l'interface
    setState(() {
      _cartItems = items;
      _totalPrice = total;
      _isLoading = false;
    });
  }

  // Fonction pour retirer un produit et recharger la liste
  Future<void> _removeItem(int productId) async {
    await _cartService.removeFromCart(productId);
    _loadCart(); // On rappelle _loadCart pour recalculer le total et l'affichage
  }

  // Fonction de simulation de commande
  Future<void> _validateOrder() async {
    await _cartService.clearCart(); // On vide le panier en mémoire
    _loadCart(); // On vide l'affichage

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Commande validée avec succès ! 🎉'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mon Panier')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _cartItems.isEmpty
          ? const Center(child: Text('Votre panier est vide.'))
          : Column(
              children: [
                // Expanded permet à la liste de prendre tout l'espace disponible au dessus du total
                Expanded(
                  child: ListView.builder(
                    itemCount: _cartItems.length,
                    itemBuilder: (context, index) {
                      final product = _cartItems[index];
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
                        // Bouton rouge pour supprimer cet article
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.remove_circle_outline,
                            color: Colors.red,
                          ),
                          onPressed: () => _removeItem(product.id),
                        ),
                      );
                    },
                  ),
                ),
                // Zone fixe en bas pour le Total et le bouton Valider
                Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total: ${_totalPrice.toStringAsFixed(2)} €',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        onPressed: _validateOrder,
                        child: const Text(
                          'Valider',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
