import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/order.dart';

class OrderService {
  final String baseUrl = 'https://6911d19952a60f10c81f612e.mockapi.io';

  /// 🔹 Ambil semua data pesanan
  Future<List<Order>> fetchOrders() async {
    final res = await http.get(Uri.parse('$baseUrl/orders'));
    if (res.statusCode == 200) {
      final List data = json.decode(res.body);
      return data.map((e) => Order.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat data (${res.statusCode})');
    }
  }

  /// 🔹 Tambah pesanan baru ke server
  Future<void> addOrder(Order order) async {
    final res = await http.post(
      Uri.parse('$baseUrl/orders'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(order.toJson()),
    );

    if (res.statusCode != 201) {
      throw Exception('Gagal menyimpan pesanan');
    }
  }

  /// 🔹 Hapus semua pesanan
  Future<void> clearOrders() async {
    final res = await http.get(Uri.parse('$baseUrl/orders'));
    if (res.statusCode == 200) {
      final List data = json.decode(res.body);
      for (var item in data) {
        await http.delete(Uri.parse('$baseUrl/orders/${item['id']}'));
      }
    }
  }
}
