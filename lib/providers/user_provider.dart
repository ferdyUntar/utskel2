import 'package:flutter/foundation.dart';
import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  final List<User> _users = [];
  User? _currentUser;

  List<User> get users => List.unmodifiable(_users);
  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  //  Tambah user baru
  void addUser(String username, String password) {
    if (_users.any((u) => u.userName == username)) {
      debugPrint("⚠️ Username '$username' sudah digunakan!");
      return;
    }

    final newUser = User(
      userId: DateTime.now().millisecondsSinceEpoch.toString(),
      userName: username,
      userPass: password,
    );

    _users.add(newUser);
    debugPrint("✅ User baru ditambahkan: ${newUser.userName}");
    notifyListeners();
  }

  // ✅ Login user
  bool login(String username, String password) {
    try {
      final user = _users.firstWhere(
            (u) => u.userName == username && u.userPass == password,
      );
      _currentUser = user;
      debugPrint("✅ Login berhasil: ${user.userName}");
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("❌ Login gagal: user tidak ditemukan");
      return false;
    }
  }

  // ✅ Logout user
  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  // ✅ Reset Password (Lupa Password)
  bool resetPassword(String username, String newPassword) {
    final index = _users.indexWhere((u) => u.userName == username);
    if (index == -1) {
      debugPrint("⚠️ Username tidak ditemukan");
      return false;
    }

    final user = _users[index];
    _users[index] = User(
      userId: user.userId,
      userName: user.userName,
      userPass: newPassword,
    );

    debugPrint("🔑 Password untuk ${user.userName} berhasil diubah (reset password).");
    notifyListeners();
    return true;
  }

  // Update Password
  void updatePassword(String username, String newPassword) {
    final index = _users.indexWhere((u) => u.userName == username);
    if (index != -1) {
      final user = _users[index];
      _users[index] = User(
        userId: user.userId,
        userName: user.userName,
        userPass: newPassword,
      );

      debugPrint("✅ Password untuk ${user.userName} berhasil diperbarui (via CRUD).");
      notifyListeners();
    } else {
      debugPrint("⚠️ Gagal memperbarui password: username tidak ditemukan.");
    }
  }

  // Hapus user
  void deleteUser(String username) {
    _users.removeWhere((u) => u.userName == username);
    debugPrint("🗑 User $username dihapus");
    notifyListeners();
  }
}
