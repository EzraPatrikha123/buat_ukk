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
    return Menu(
      id: json['id'],
      namaMakanan: json['nama_makanan'],
      harga: json['harga'].toDouble(),
      jenis: JenisMenu.values.firstWhere(
        (e) => e.toString() == json['jenis'],
      ),
      foto: json['foto'],
      deskripsi: json['deskripsi'],
      idStan: json['id_stan'],
    );
  }
}
