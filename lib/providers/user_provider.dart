import 'package:flutter/material.dart';
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  List<User> _users = [
    User(username: "admin", password: "123"),
  ];

  User? _currentUser;
  User? get currentUser => _currentUser;

  List<User> get users => _users;

  bool login(String username, String password) {
    final user = _users.firstWhere(
          (u) => u.username == username && u.password == password,
      orElse: () => User(username: "", password: ""),
    );

    if (user.username.isNotEmpty) {
      _currentUser = user;
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  void addUser(String username, String password) {
    _users.add(User(username: username, password: password));
    notifyListeners();
  }

  List<User> getAllUsers() => _users;

  void updatePassword(String username, String newPassword) {
    // Update yang sedang login
    if (_currentUser != null && _currentUser!.username == username) {
      _currentUser = User(
        username: _currentUser!.username,
        password: newPassword,
      );
    }

    // Update di list user
    for (int i = 0; i < _users.length; i++) {
      if (_users[i].username == username) {
        _users[i] = User(username: username, password: newPassword);
        notifyListeners();
        break;
      }
    }
  }

  void deleteUser(String username) {
    _users.removeWhere((u) => u.username == username);

    if (_currentUser != null && _currentUser!.username == username) {
      _currentUser = null;
    }

    notifyListeners();
  }
}
