import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'update_password_screen.dart';

class UserCrudScreen extends StatelessWidget {
  const UserCrudScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Kelola User")),
      body: userProvider.users.isEmpty
          ? const Center(child: Text("Belum ada user terdaftar"))
          : ListView.builder(
        itemCount: userProvider.users.length,
        itemBuilder: (context, index) {
          final user = userProvider.users[index];

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue.shade100,
                child: Text('${index + 1}'),
              ),
              title: Text(user.userName),
              subtitle: Text("Password: ${user.userPass}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: "Ubah Password",
                    icon: const Icon(Icons.edit, color: Colors.orange),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              UpdatePasswordScreen(username: user.userName),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    tooltip: "Hapus User",
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      userProvider.deleteUser(user.userName);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "User '${user.userName}' telah dihapus!",
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
