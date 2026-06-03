import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = Supabase.instance.client.auth.currentUser!.id;

    return Scaffold(
      appBar: AppBar(title: const Text('Historique des commandes')),
      body: FutureBuilder(
        // On récupère les commandes de l'utilisateur avec leurs items associés
        future: Supabase.instance.client
            .from('orders')
            .select('*, order_items(*)')
            .eq('user_id', userId)
            .order('created_at', ascending: false),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());

          final orders = snapshot.data as List<dynamic>;
          if (orders.isEmpty)
            return const Center(child: Text('Aucune commande passée.'));

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final items = order['order_items'] as List<dynamic>;

              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ExpansionTile(
                  title: Text(
                    'Commande du ${DateTime.parse(order['created_at']).toLocal().toString().substring(0, 16)}',
                  ),
                  subtitle: Text('Total : ${order['total_price']} €'),
                  children: items
                      .map(
                        (item) => ListTile(
                          title: Text(item['product_title']),
                          trailing: Text('${item['price']} €'),
                        ),
                      )
                      .toList(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
