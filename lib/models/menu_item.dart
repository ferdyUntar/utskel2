class MenuItem {
  final String name;
  final double price;
  final String image;
  int? quantity;

  MenuItem({
    required this.name,
    required this.price,
    required this.image,
    this.quantity,
  });
}
