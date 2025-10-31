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
      body: ListView.builder(
        itemCount: userProvider.users.length,
        itemBuilder: (context, index) {
          final user = userProvider.users[index];

          return ListTile(
            title: Text(user.username),
            subtitle: Text("Password: ${user.password}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => UpdatePasswordScreen(username: user.username),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    userProvider.deleteUser(user.username);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
