import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';
import '../models/order.dart';
import 'menu_screen.dart'; // ✅ agar bisa kembali ke Menu utama

class PembayaranScreen extends StatelessWidget {
  final double totalHarga;

  const PembayaranScreen({super.key, required this.totalHarga});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Pembayaran')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Total Pembayaran Anda:',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 12),
            Text(
              'Rp ${totalHarga.toStringAsFixed(0)}',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () async {
                final orderProvider =
                Provider.of<OrderProvider>(context, listen: false);
                final items = cartProvider.cart;

                // 🔹 Simpan context ke variabel lokal agar aman dari async gaps
                final navigator = Navigator.of(context);
                final messenger = ScaffoldMessenger.of(context);

                // 🔹 Buat object pesanan baru
                final newOrder = Order(
                  id: DateTime.now().millisecondsSinceEpoch,
                  namaMakanan: items.isNotEmpty
                      ? items.map((e) => e.name).join(', ')
                      : 'Pesanan Kosong',
                  jumlah: items.length,
                  totalHarga: totalHarga,
                  tanggal: DateTime.now(),
                );

                try {
                  // ✅ Simpan ke server (MockAPI)
                  await orderProvider.tambahOrder(newOrder);

                  // Hapus isi keranjang setelah pembayaran
                  cartProvider.clearCart();

                  // Tampilkan dialog sukses
                  if (context.mounted) {
                    showDialog(
                      context: context,
                      builder: (dialogContext) => AlertDialog(
                        title: const Text('Pembayaran Berhasil'),
                        content: const Text(
                          'Pesanan Anda berhasil disimpan ke server dan sedang diproses!',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () async {
                              // Tutup dialog
                              Navigator.pop(dialogContext);

                              // Muat ulang data riwayat
                              await orderProvider.loadOrders();

                              // Kembali ke Menu utama
                              navigator.pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (_) => const MenuScreen(),
                                ),
                                    (Route<dynamic> route) => false,
                              );

                              // ✅ Gunakan messenger yang disimpan sebelum async
                              messenger.showSnackBar(
                                const SnackBar(
                                  content: Text('✅ Pembayaran berhasil!'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                            child: const Text('Kembali ke Menu'),
                          ),
                        ],
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Gagal Menyimpan Pesanan'),
                        content: Text('Terjadi kesalahan: $e'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Tutup'),
                          ),
                        ],
                      ),
                    );
                  }
                }
              },
              icon: const Icon(Icons.payment),
              label: const Text('Bayar Sekarang'),
              style: ElevatedButton.styleFrom(
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
