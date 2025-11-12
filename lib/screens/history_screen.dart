import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order_provider.dart';
import '../providers/user_provider.dart';
import '../models/order.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);

    final currentUser = userProvider.currentUser;
    final userId = currentUser?.userId ?? "guest";

    //  history hanya order milik user saat ini
    final List<Order> userOrders = orderProvider.orders
        .where((order) => order.userId == userId)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pemesanan'),
      ),
      body: userOrders.isEmpty
          ? const Center(
        child: Text(
          'Belum ada riwayat pemesanan.',
          style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
        ),
      )
          : ListView.builder(
        itemCount: userOrders.length,
        itemBuilder: (context, index) {
          final order = userOrders[index];
          return Card(
            margin:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue.shade100,
                child: Text('${index + 1}'),
              ),
              title: Text(order.namaMakanan),
              subtitle: Text(
                'Jumlah: ${order.jumlah} • Tanggal: ${order.tanggal.toString().split(" ")[0]}',
              ),
              trailing: Text(
                'Rp ${order.totalHarga.toStringAsFixed(0)}',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.green),
              ),
            ),
          );
        },
      ),
    );
  }
}
