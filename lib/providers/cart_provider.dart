import 'package:flutter/material.dart';
import '../models/menu_item.dart';

class CartProvider with ChangeNotifier {
  final List<MenuItem> _cart = [];

  List<MenuItem> get cart => _cart;

  double get totalPrice =>
      _cart.fold(0, (sum, item) => sum + item.price);

  void addToCart(MenuItem item) {
    _cart.add(item);
    notifyListeners();
  }

  void removeFromCart(MenuItem item) {
    _cart.remove(item);
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }
}
