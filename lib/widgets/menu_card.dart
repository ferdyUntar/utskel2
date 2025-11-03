import 'package:flutter/material.dart';
import '../models/menu_item.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class MenuCard extends StatelessWidget {
  final MenuItem item;

  const MenuCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.asset(item.image, fit: BoxFit.cover, width: double.infinity),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text("Rp ${item.price.toStringAsFixed(0)}"),
                ElevatedButton(
                  onPressed: () {
                    cart.addToCart(item);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("${item.name} ditambahkan ke keranjang!"),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  child: const Text("Tambah"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}