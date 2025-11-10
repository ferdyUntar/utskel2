import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order_provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final orders = orderProvider.orders;

    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Pemesanan')),
      body: orders.isEmpty
          ? const Center(child: Text('Belum ada riwayat pemesanan.'))
          : ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(order.namaMakanan),
              subtitle: Text(
                'Jumlah: ${order.jumlah}\nTanggal: ${order.tanggal.toString().split(" ")[0]}',
              ),
              trailing: Text(
                'Rp ${order.totalHarga.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
