import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/menu_item.dart';
import '../providers/cart_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/menu_card.dart';
import 'login.dart';
import 'pembayaran_screen.dart';

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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Daftar Menu", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Toggle theme',
            icon: Icon(isDark ? Icons.wb_sunny : Icons.nights_stay),
            onPressed: () => themeProvider.toggleTheme(),
          ),
          Stack(
            children: [
              IconButton(
                tooltip: 'Keranjang',
                icon: const Icon(Icons.shopping_cart),
                onPressed: () => _showCartDialog(context, cart),
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
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout),
            onPressed: () {
              Provider.of<UserProvider>(context, listen: false).logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [Colors.black, Colors.indigo.shade900]
                : [Colors.purple.shade300, Colors.blue.shade200],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = constraints.maxWidth > 900
                  ? 4
                  : constraints.maxWidth > 600
                  ? 3
                  : 2;

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.builder(
                  itemCount: menu.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.8,
                  ),
                  itemBuilder: (context, index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                      child: MenuCard(item: menu[index]),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showCartDialog(BuildContext context, CartProvider cart) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
          title: const Text("🛒 Keranjang Belanja"),
          content: SizedBox(
            width: double.maxFinite,
            child: cart.cart.isEmpty
                ? const Center(child: Text("Keranjang masih kosong"))
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
                        leading: CircleAvatar(
                          backgroundImage: AssetImage(item.image),
                          radius: 20,
                        ),
                        title: Text(item.name),
                        trailing: Text(
                          "Rp ${item.price.toStringAsFixed(0)}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                  ),
                ),
                const Divider(),
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
              child: const Text("🗑 Hapus Semua"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Tutup"),
            ),
            ElevatedButton.icon(
              onPressed: cart.cart.isEmpty
                  ? null
                  : () {
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
              icon: const Icon(Icons.payment),
              label: const Text("Bayar Sekarang"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
            ),
          ],
        );
      },
    );
  }
}
