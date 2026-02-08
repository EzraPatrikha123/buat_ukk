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
      );
    }
    
    return Menu(
      id: json['id'],
      namaMakanan: json['nama_makanan'],
      harga: json['harga'].toDouble(),
      jenis: jenis,
      foto: json['foto'],
      deskripsi: json['deskripsi'] ?? '',
      idStan: json['id_stan'],
    );
  }
}
