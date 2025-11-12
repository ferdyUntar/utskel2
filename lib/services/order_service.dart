import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/order.dart';

class OrderService {
  final String baseUrl = 'https://6911d19952a60f10c81f612e.mockapi.io';

  ///  Ambil hanya pesanan punya user tertentu
  Future<List<Order>> fetchOrdersByUser(String userId) async {
    final res = await http.get(Uri.parse('$baseUrl/orders?userId=$userId'));
    if (res.statusCode == 200) {
      final List data = json.decode(res.body);
      return data.map((e) => Order.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat data pesanan');
    }
  }

  ///  Tambah pesanan baru
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

  ///  Hapus pesanan
  Future<void> clearOrders(String userId) async {
    final res = await http.get(Uri.parse('$baseUrl/orders?userId=$userId'));
    if (res.statusCode == 200) {
      final List data = json.decode(res.body);
      for (var item in data) {
        await http.delete(Uri.parse('$baseUrl/orders/${item['id']}'));
      }
    }
  }
}
