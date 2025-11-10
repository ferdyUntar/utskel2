import 'package:flutter/foundation.dart';
import '../models/menu_item.dart';

class CartProvider with ChangeNotifier {  // ⚠️ Pastikan huruf besar kecil persis
  final List<MenuItem> _cart = [];

  List<MenuItem> get cart => _cart;

  double get totalPrice {
    double total = 0;
    for (var item in _cart) {
      total += item.price * (item.quantity ?? 1);
    }
    return total;
  }

  void addToCart(MenuItem item) {
    final index = _cart.indexWhere((e) => e.name == item.name);
    if (index != -1) {
      _cart[index].quantity = (_cart[index].quantity ?? 1) + 1;
    } else {
      item.quantity = 1;
      _cart.add(item);
    }
    notifyListeners();
  }

  void increaseQuantity(MenuItem item) {
    final index = _cart.indexWhere((e) => e.name == item.name);
    if (index != -1) {
      _cart[index].quantity = (_cart[index].quantity ?? 1) + 1;
      notifyListeners();
    }
  }

  void decreaseQuantity(MenuItem item) {
    final index = _cart.indexWhere((e) => e.name == item.name);
    if (index != -1) {
      if ((_cart[index].quantity ?? 1) > 1) {
        _cart[index].quantity = (_cart[index].quantity ?? 1) - 1;
      } else {
        _cart.removeAt(index);
      }
      notifyListeners();
    }
  }

  void removeFromCart(MenuItem item) {
    _cart.removeWhere((e) => e.name == item.name);
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }
}
