class Order {
  final int id;
  final String namaMakanan;
  final int jumlah;
  final double totalHarga;
  final DateTime tanggal;

  Order({
    required this.id,
    required this.namaMakanan,
    required this.jumlah,
    required this.totalHarga,
    required this.tanggal,
  });

  /// ✅ Tambahkan ini agar bisa parsing dari JSON (API → Object)
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      namaMakanan: json['namaMakanan'] ?? '',
      jumlah: json['jumlah'] is int ? json['jumlah'] : int.tryParse(json['jumlah'].toString()) ?? 0,
      totalHarga: (json['totalHarga'] is double)
          ? json['totalHarga']
          : double.tryParse(json['totalHarga'].toString()) ?? 0.0,
      tanggal: DateTime.tryParse(json['tanggal'].toString()) ?? DateTime.now(),
    );
  }

  /// ✅ Tambahkan juga supaya bisa kirim ke server (Object → JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'namaMakanan': namaMakanan,
      'jumlah': jumlah,
      'totalHarga': totalHarga,
      'tanggal': tanggal.toIso8601String(),
    };
  }
}
