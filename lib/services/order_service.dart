import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/order.dart';

class OrderService {
  final String baseUrl;
  OrderService({required this.baseUrl});

  Future<List<Order>> fetchUserOrders(int userId) async {
    final res = await http.get(Uri.parse('$baseUrl/orders?user=$userId'));
    if (res.statusCode == 200) {
      final List data = json.decode(res.body);
      return data.map((e) => Order.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat data pemesanan');
    }
  }
}
