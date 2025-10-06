import 'package:flutter/material.dart';

class MenuCard extends StatelessWidget {
  final String title;
  final double price;

  const MenuCard({super.key, required this.title, required this.price});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: ListTile(
        title: Text(title),
        subtitle: Text('Rp $price'),
        trailing: const Icon(Icons.add_shopping_cart),
      ),
    );
  }
}
