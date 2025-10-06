import 'package:flutter/foundation.dart';
import '../models/menu_item.dart';

class CartProvider with ChangeNotifier {
  final List<MenuItem> _items = [];

  List<MenuItem> get items => _items;

  void addItem(MenuItem item) {
    _items.add(item);
    notifyListeners();
  }

  void removeItem(MenuItem item) {
    _items.remove(item);
    notifyListeners();
  }

  double get totalPrice =>
      _items.fold(0, (sum, item) => sum + item.price);
}
