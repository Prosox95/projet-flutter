import 'package:flutter/material.dart';
import '../services/favorite_service.dart';

class FavoriteButton extends StatefulWidget {
  final int productId;

  const FavoriteButton({super.key, required this.productId});

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  final FavoriteService _favoriteService = FavoriteService();
  // On utilise un Future pour stocker l'état de la vérification
  late Future<bool> _isFavoriteFuture;

  @override
  void initState() {
    super.initState();
    // On lance la vérification au démarrage du widget
    _isFavoriteFuture = _favoriteService.isFavorite(widget.productId);
  }

  // Fonction appelée lors du clic sur le bouton
  Future<void> _toggleFavorite(bool currentStatus) async {
    // On inverse le statut en base
    await _favoriteService.toggleFavorite(widget.productId);

    // On met à jour l'UI en rechargeant le Future
    setState(() {
      _isFavoriteFuture = _favoriteService.isFavorite(widget.productId);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Le FutureBuilder va gérer l'attente de la réponse
    return FutureBuilder<bool>(
      future: _isFavoriteFuture,
      builder: (context, snapshot) {
        // Pendant le chargement, on peut afficher un bouton gris par défaut
        // ou un petit indicateur de chargement.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const IconButton(
            icon: Icon(Icons.favorite_border, color: Colors.grey),
            onPressed: null, // Désactivé pendant le chargement
          );
        }

        // Si on a la réponse, on affiche le bon bouton
        final isFavorite = snapshot.data ?? false;

        return IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : Colors.grey,
          ),
          onPressed: () => _toggleFavorite(isFavorite),
        );
      },
    );
  }
}
