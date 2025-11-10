import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';
import '../models/order.dart';

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
            const Text('Total Pembayaran Anda:', style: TextStyle(fontSize: 20)),
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
              onPressed: () {
                final orderProvider =
                Provider.of<OrderProvider>(context, listen: false);

                final items = cartProvider.cart; // ✅ gunakan getter cart

                final newOrder = Order(
                  id: DateTime.now().millisecondsSinceEpoch,
                  namaMakanan: items.isNotEmpty
                      ? items.map((e) => e.name).join(', ')
                      : 'Pesanan Kosong',
                  jumlah: items.length,
                  totalHarga: totalHarga,
                  tanggal: DateTime.now(),
                );

                orderProvider.tambahOrder(newOrder);
                cartProvider.clearCart();

                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Pembayaran Berhasil'),
                    content: const Text(
                      'Terima kasih telah melakukan pembayaran.\nPesanan Anda sedang diproses!',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/history');
                        },
                        child: const Text('Lihat Riwayat Pesanan'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.popUntil(context, (route) => route.isFirst);
                        },
                        child: const Text('Kembali ke Menu'),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.payment),
              label: const Text('Bayar Sekarang'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
