import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/menu_item.dart';
import '../providers/cart_provider.dart';
import '../widgets/menu_card.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<MenuItem> menu = [
      MenuItem(name: 'Mie Goreng', price: 20000, image: 'assets/mie goreng.jpeg'),
      MenuItem(name: 'Martabak Ayam', price: 18000, image: 'assets/martabak.jpeg'),
      MenuItem(name: 'Sate Taichan', price: 25000, image: 'assets/taichan.jpg'),
      MenuItem(name: 'Nasi Goreng', price: 20000, image: 'assets/nasigoreng.jpeg'),
    ];

    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Menu"),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  _showCartDialog(context, cart);
                },
              ),
              if (cart.cart.isNotEmpty)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      cart.cart.length.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: menu.length,
        itemBuilder: (context, index) {
          return MenuCard(item: menu[index]);
        },
      ),
    );
  }

  void _showCartDialog(BuildContext context, CartProvider cart) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Keranjang Belanja"),
        content: cart.cart.isEmpty
            ? const Text("Keranjang masih kosong")
            : SizedBox(
          height: 200,
          child: ListView.builder(
            itemCount: cart.cart.length,
            itemBuilder: (context, index) {
              final item = cart.cart[index];
              return ListTile(
                title: Text(item.name),
                trailing: Text("Rp ${item.price.toStringAsFixed(0)}"),
              );
            },
          ),
        ),
        actions: [
          Text("Total: Rp ${cart.totalPrice.toStringAsFixed(0)}"),
          TextButton(
            onPressed: () {
              cart.clearCart();
              Navigator.pop(context);
            },
            child: const Text("Hapus Semua"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Tutup"),
          ),
        ],
      ),
    );
  }
}
