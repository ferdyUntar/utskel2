import 'package:flutter/foundation.dart';
import '../models/order.dart';
import '../services/order_service.dart';

class OrderProvider extends ChangeNotifier {
  final List<Order> _orders = [];
  final OrderService _service = OrderService(baseUrl: 'https://your-api-url.mockapi.io'); // Ganti dengan URL API kamu

  List<Order> get orders => List.unmodifiable(_orders);

  Future<void> loadOrders(int userId) async {
    try {
      final fetched = await _service.fetchUserOrders(userId);
      _orders
        ..clear()
        ..addAll(fetched);
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading orders: $e');
    }
  }

  void tambahOrder(Order order) {
    _orders.add(order);
    notifyListeners();
  }

  void hapusSemua() {
    _orders.clear();
    notifyListeners();
  }
}
