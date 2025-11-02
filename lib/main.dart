import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';
import 'providers/user_provider.dart';
import 'screens/login.dart';
import 'screens/menu_screen.dart';
import 'screens/pembayaran_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
//ini push mira test

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi Pemesanan Makanan',
      theme: ThemeData(primarySwatch: Colors.red),
      home: LoginScreen(),


      routes: {
        '/menu': (context) => const MenuScreen(),
        '/pembayaran': (context) => const PembayaranScreen(
          totalHarga: 0, // akan diganti nilai sebenarnya saat navigasi
        ),
      },
    );
  }
}
