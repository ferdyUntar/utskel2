import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';
import 'screens/menu_screen.dart';
import 'screens/pembayaran_screen.dart'; // ✅ tambahkan ini

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
//cobatest
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi Pemesanan Makanan',
      theme: ThemeData(primarySwatch: Colors.red),
      home: const MenuScreen(),


      routes: {
        '/pembayaran': (context) => const PembayaranScreen(
          totalHarga: 0, // akan diganti nilai sebenarnya saat navigasi
        ),
      },
    );
  }
}
