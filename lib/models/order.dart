class Order {
  final int id;
  final String namaMakanan;
  final int jumlah;
  final double totalHarga;
  final DateTime tanggal;
  final String userId;

  Order({
    required this.id,
    required this.namaMakanan,
    required this.jumlah,
    required this.totalHarga,
    required this.tanggal,
    required this.userId,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: int.tryParse(json['id'].toString()) ?? 0,
      namaMakanan: json['namaMakanan'] ?? '',
      jumlah: int.tryParse(json['jumlah'].toString()) ?? 0,
      totalHarga: double.tryParse(json['totalHarga'].toString()) ?? 0.0,
      tanggal: DateTime.tryParse(json['tanggal'] ?? '') ?? DateTime.now(),
      userId: json['userId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id.toString(),
      'namaMakanan': namaMakanan,
      'jumlah': jumlah,
      'totalHarga': totalHarga,
      'tanggal': tanggal.toIso8601String(),
      'userId': userId,
    };
  }
}
