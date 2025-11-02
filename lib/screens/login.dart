// lib/screens/login.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../providers/theme_provider.dart'; // update mira: import ThemeProvider
import 'menu_screen.dart';
import 'register_screen.dart';
import 'user_crud_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  String errorMsg = "";

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // update mira: responsif layout - gunakan LayoutBuilder
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWide = constraints.maxWidth > 800;
        return Scaffold(
          // update mira: buat background gradasi colorful
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: Theme.of(context).brightness == Brightness.dark
                    ? [Colors.indigo.shade900, Colors.black]
                    : [Colors.purple.shade400, Colors.blue.shade300],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: isWide ? 1000 : 480),
                    child: isWide ? buildWide(context) : buildNarrow(context),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // update mira: layout untuk layar sempit (mobile)
  Widget buildNarrow(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        buildHeader(context),
        const SizedBox(height: 20),
        buildFormCard(context),
        const SizedBox(height: 12),
        buildBottomLinks(context),
      ],
    );
  }

  // update mira: layout split untuk layar lebar (Windows / desktop)
  Widget buildWide(BuildContext context) {
    return Card(
      elevation: 16,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SizedBox(
        height: 520,
        child: Row(
          children: [
            // left: illustration / image area
            Expanded(
              flex: 5,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(20)),
                  gradient: LinearGradient(
                    colors: [Colors.purple.shade300, Colors.blue.shade200],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.local_dining, size: 80, color: Colors.white),
                    const SizedBox(height: 12),
                    Text(
                      'Welcome Back!',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sign in to continue ordering your favorite meals',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            // right: form area
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.all(28.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // update mira: toggle theme di pojok kanan atas (desktop)
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        tooltip: 'Toggle theme',
                        icon: Icon(Provider.of<ThemeProvider>(context).mode == ThemeMode.light ? Icons.nights_stay : Icons.wb_sunny),
                        onPressed: () {
                          Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                        },
                      ),
                    ),
                    const SizedBox(height: 6),
                    buildFormCard(context, small: true),
                    const SizedBox(height: 12),
                    buildBottomLinks(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // update mira: header untuk mobile (logo + toggle)
  Widget buildHeader(BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.local_dining, size: 72, color: Colors.white),
        const SizedBox(height: 12),
        Text('Foodie App', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        // update mira: toggle theme untuk mobile
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            icon: Icon(Provider.of<ThemeProvider>(context).mode == ThemeMode.light ? Icons.nights_stay : Icons.wb_sunny, color: Colors.white),
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
        ),
      ],
    );
  }

  // update mira: card yang berisi form (dipakai di mobile & desktop)
  Widget buildFormCard(BuildContext context, {bool small = false}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 10,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: small ? 18 : 22, vertical: small ? 20 : 26),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Login', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: "Username",
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: "Password",
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            if (errorMsg.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(errorMsg, style: const TextStyle(color: Colors.red)),
              ),
            // update mira: tombol login bergaya gradient (Material elevation + Ink)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final provider = Provider.of<UserProvider>(context, listen: false);

                  // update mira: Validasi input kosong
                  if (usernameController.text.trim().isEmpty || passwordController.text.trim().isEmpty) {
                    setState(() => errorMsg = "Username dan Password tidak boleh kosong!");
                    return;
                  }

                  bool success = provider.login(
                    usernameController.text.trim(),
                    passwordController.text.trim(),
                  );

                  if (success) {
                    // update mira: saat login sukses, navigate ke MenuScreen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const MenuScreen()),
                    );
                  } else {
                    setState(() => errorMsg = "Username atau Password salah!");
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Colors.deepPurple.shade400, Colors.pinkAccent.shade200]),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    constraints: const BoxConstraints(minHeight: 48),
                    child: const Text('Login', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // quick demo: navigasi ke register
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen()));
                    },
                    icon: const Icon(Icons.person_add),
                    label: const Text('Register'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // quick demo: navigasi ke user CRUD
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const UserCrudScreen()));
                    },
                    icon: const Icon(Icons.manage_accounts),
                    label: const Text('Users'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // update mira: bagian link bawah (forgot / info)
  Widget buildBottomLinks(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: () {
            // contoh action: tampilkan dialog lupa password
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Lupa Password'),
                content: const Text('Fitur reset password belum diaktifkan.'),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tutup')),
                ],
              ),
            );
          },
          child: const Text('Lupa Password?'),
        ),
        const SizedBox(height: 6),
        Text(
          'Versi 1.0 • UTS Project',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
