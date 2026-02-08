enum JenisMenu { makanan, minuman }

class Menu {
  final int id;
  final String namaMakanan;
  final double harga;
  final JenisMenu jenis;
  final String? foto;
  final String deskripsi;
  final int idStan;

  Menu({
    required this.id,
    required this.namaMakanan,
    required this.harga,
    required this.jenis,
    this.foto,
    required this.deskripsi,
    required this.idStan,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_makanan': namaMakanan,
      'harga': harga,
      'jenis': jenis.toString(),
      'foto': foto,
      'deskripsi': deskripsi,
      'id_stan': idStan,
    };
  }

  factory Menu.fromJson(Map<String, dynamic> json) {
    // Parse jenis from string to enum
    JenisMenu jenis;
    if (json['jenis'] is String) {
      jenis = json['jenis'].toLowerCase() == 'makanan' 
          ? JenisMenu.makanan 
          : JenisMenu.minuman;
    } else {
      jenis = JenisMenu.values.firstWhere(
        (e) => e.toString() == json['jenis'],
        orElse: () => JenisMenu.makanan,
      );
    }
    
    // Parse harga to double, handling int and string types
    double harga;
    if (json['harga'] is int) {
      harga = (json['harga'] as int).toDouble();
    } else if (json['harga'] is double) {
      harga = json['harga'] as double;
    } else if (json['harga'] is String) {
      harga = double.tryParse(json['harga']) ?? 0.0;
    } else {
      harga = 0.0;
    }
    
    return Menu(
      id: json['id'] ?? 0,
      namaMakanan: json['nama_makanan'] ?? '',
      harga: harga,
      jenis: jenis,
      foto: json['foto'],
      deskripsi: json['deskripsi'] ?? '',
      idStan: json['id_stan'] ?? 0,
    );
  }
}
