import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';
import '../providers/user_provider.dart';
import '../models/order.dart';
import 'menu_screen.dart';

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
              icon: const Icon(Icons.payment),
              label: const Text('Bayar Sekarang'),
              style: ElevatedButton.styleFrom(
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),

              //  tombol bayar
              onPressed: () async {
                final orderProvider =
                Provider.of<OrderProvider>(context, listen: false);
                final userProvider =
                Provider.of<UserProvider>(context, listen: false);


                final navigator = Navigator.of(context);
                final messenger = ScaffoldMessenger.of(context);

                final items = cartProvider.cart;
                final userId = userProvider.currentUser?.userId ?? 'guest';

                // Buat objek pesanan baru
                final newOrder = Order(
                  id: DateTime.now().millisecondsSinceEpoch,
                  namaMakanan: items.isNotEmpty
                      ? items.map((e) => e.name).join(', ')
                      : 'Pesanan Kosong',
                  jumlah: items.length,
                  totalHarga: totalHarga,
                  tanggal: DateTime.now(),
                  userId: userId,
                );

                try {
                  //  Simpan order ke server (MockAPI atau lokal)
                  await orderProvider.tambahOrder(newOrder);
                  cartProvider.clearCart();

                  if (!context.mounted) return;

                  //  dialog sukses
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
                            Navigator.pop(dialogContext); // tutup dialog
                            await orderProvider.loadOrders(userId);

                            // ✅ kembali ke MenuScreen tanpa bisa back
                            navigator.pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (_) => const MenuScreen(),
                              ),
                                  (route) => false,
                            );

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
                } catch (e) {
                  if (!context.mounted) return;
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
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
              },
            ),
          ],
        ),
      ),
    );
  }
}
