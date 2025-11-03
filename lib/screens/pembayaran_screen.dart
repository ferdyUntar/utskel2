import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class PembayaranScreen extends StatelessWidget {
  final double totalHarga;

  const PembayaranScreen({super.key, required this.totalHarga});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
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
              onPressed: () {
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
