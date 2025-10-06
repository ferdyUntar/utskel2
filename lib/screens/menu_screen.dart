import 'package:flutter/material.dart';
import '../widgets/menu_card.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menu Makanan')),
      body: ListView(
        children: const [
          MenuCard(title: 'Nasi Goreng', price: 20000),
          MenuCard(title: 'Mie Ayam', price: 18000),
          MenuCard(title: 'Sate Ayam', price: 25000),
        ],
      ),
    );
  }
}
