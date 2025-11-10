import 'package:flutter/foundation.dart';
import '../models/order.dart';
import '../services/order_service.dart';

class OrderProvider extends ChangeNotifier {
  final OrderService _service = OrderService();
  final List<Order> _orders = [];

  List<Order> get orders => List.unmodifiable(_orders);

  Future<void> loadOrders() async {
    try {
      final fetched = await _service.fetchOrders();
      _orders
        ..clear()
        ..addAll(fetched);
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error loading orders: $e');
    }
  }

  Future<void> tambahOrder(Order order) async {
    try {
      await _service.addOrder(order);
      _orders.add(order);
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error adding order: $e');
    }
  }

  Future<void> hapusSemua() async {
    try {
      await _service.clearOrders();
      _orders.clear();
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error clearing orders: $e');
    }
  }
}
