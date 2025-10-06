import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/menu_item.dart';
import '../providers/cart_provider.dart';
import '../widgets/menu_card.dart';
import '../screens/pembayaran_screen.dart';


class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<MenuItem> menu = [
      MenuItem(name: 'Mie Goreng', price: 20000, image: 'assets/mie goreng.jpeg'),
      MenuItem(name: 'Martabak Manis', price: 18000, image: 'assets/martabak.jpeg'),
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
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Keranjang Belanja"),
          content: SizedBox(
            width: double.maxFinite,
            child: cart.cart.isEmpty
                ? const Text("Keranjang masih kosong")
                : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: cart.cart.length,
                    itemBuilder: (context, index) {
                      final item = cart.cart[index];
                      return ListTile(
                        title: Text(item.name),
                        trailing: Text(
                          "Rp ${item.price.toStringAsFixed(0)}",
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Total: Rp ${cart.totalPrice.toStringAsFixed(0)}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                cart.clearCart();
                Navigator.pop(dialogContext);
              },
              child: const Text("Hapus Semua"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Tutup"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PembayaranScreen(
                      totalHarga: cart.totalPrice,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text("Lanjut ke Pembayaran"),
            ),
          ],
        );
      },
    );
  }



}
