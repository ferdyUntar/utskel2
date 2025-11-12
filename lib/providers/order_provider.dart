import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/order.dart';

class OrderProvider extends ChangeNotifier {
  final String baseUrl = "https://6911d19952a60f10c81f612e.mockapi.io/orders";
  List<Order> _orders = [];

  List<Order> get orders => _orders;

  //  Muat semua order dari server untuk user tertentu(kayak semacam admin)
  Future<void> loadOrders(String userId) async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        //  Filter berdasarkan userId agar hanya tampil order milik user login
        _orders = data
            .map((json) => Order.fromJson(json))
            .where((order) => order.userId == userId)
            .toList();

        debugPrint("✅ ${_orders.length} pesanan berhasil dimuat untuk user $userId");
        notifyListeners();
      } else {
        debugPrint("❌ Gagal memuat pesanan (status ${response.statusCode})");
      }
    } catch (e) {
      debugPrint("⚠️ Error loadOrders: $e");
    }
  }

  //  Tambah order baru ke MockAPI
  Future<void> tambahOrder(Order order) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(order.toJson()),
      );

      if (response.statusCode == 201) {
        _orders.add(order);
        notifyListeners();
        debugPrint("✅ Pesanan baru berhasil ditambahkan ke server.");
      } else {
        debugPrint("❌ Gagal menambah pesanan: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("⚠️ Error tambahOrder: $e");
    }
  }

  //  Hapus semua pesanan untuk user tertentu
  Future<void> hapusSemua(String userId) async {
    try {
      // Ambil semua order dari user ini
      final userOrders = _orders.where((o) => o.userId == userId).toList();

      for (final order in userOrders) {
        await http.delete(Uri.parse("$baseUrl/${order.id}"));
      }

      _orders.removeWhere((o) => o.userId == userId);
      notifyListeners();

      debugPrint("🗑 Semua pesanan user $userId berhasil dihapus.");
    } catch (e) {
      debugPrint("⚠️ Error hapusSemua: $e");
    }
  }

  //  Hapus 1 pesanan berdasarkan id
  Future<void> hapusOrder(int id) async {
    try {
      final response = await http.delete(Uri.parse("$baseUrl/$id"));

      if (response.statusCode == 200) {
        _orders.removeWhere((o) => o.id == id);
        notifyListeners();
        debugPrint("🗑 Pesanan ID $id berhasil dihapus.");
      } else {
        debugPrint("❌ Gagal hapus order (status ${response.statusCode})");
      }
    } catch (e) {
      debugPrint("⚠️ Error hapusOrder: $e");
    }
  }
}
