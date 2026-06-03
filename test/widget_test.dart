import 'package:flutter_test/flutter_test.dart';
// Attention à bien mettre le nom de ton projet ici, normalement c'est projet_flutter
import 'package:projet_flutter/models/product.dart';

void main() {
  // On regroupe les tests liés au modèle Product
  group('Tests sur le modèle Product', () {
    // Test 1 : Vérifier la conversion du JSON vers l'objet Dart
    test(
      'fromJson doit créer un objet Product valide à partir de données JSON',
      () {
        // 1. Préparation de fausses données (ce que l'API Platzi pourrait renvoyer)
        final Map<String, dynamic> json = {
          'id': 1,
          'title': 'T-shirt de test',
          'description': 'Un beau t-shirt',
          'price': 15.5,
          'images': ['https://url-de-l-image.com/image.jpg'],
        };

        // 2. Exécution de la fonction à tester
        final product = Product.fromJson(json);

        // 3. Vérifications (expect) : On s'attend à ce que product.title soit égal à 'T-shirt de test'
        expect(product.id, 1);
        expect(product.title, 'T-shirt de test');
        expect(product.price, 15.5);
        expect(product.imageUrl, 'https://url-de-l-image.com/image.jpg');
      },
    );
  });
}
