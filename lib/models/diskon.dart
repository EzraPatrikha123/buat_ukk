class Diskon {
  final int id;
  final String namaDiskon;
  final int persentaseDiskon;
  final DateTime tanggalAwal;
  final DateTime tanggalAkhir;

  Diskon({
    required this.id,
    required this.namaDiskon,
    required this.persentaseDiskon,
    required this.tanggalAwal,
    required this.tanggalAkhir,
  });

  bool get isActive {
    final now = DateTime.now();
    return now.isAfter(tanggalAwal) && now.isBefore(tanggalAkhir);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_diskon': namaDiskon,
      'persentase_diskon': persentaseDiskon,
      'tanggal_awal': tanggalAwal.toIso8601String(),
      'tanggal_akhir': tanggalAkhir.toIso8601String(),
    };
  }

  factory Diskon.fromJson(Map<String, dynamic> json) {
    return Diskon(
      id: json['id'],
      namaDiskon: json['nama_diskon'],
      persentaseDiskon: json['persentase_diskon'],
      tanggalAwal: DateTime.parse(json['tanggal_awal']),
      tanggalAkhir: DateTime.parse(json['tanggal_akhir']),
    );
  }
}

class MenuDiskon {
  final int id;
  final int idMenu;
  final int idDiskon;

  MenuDiskon({
    required this.id,
    required this.idMenu,
    required this.idDiskon,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_menu': idMenu,
      'id_diskon': idDiskon,
    };
  }

  factory MenuDiskon.fromJson(Map<String, dynamic> json) {
    return MenuDiskon(
      id: json['id'],
      idMenu: json['id_menu'],
      idDiskon: json['id_diskon'],
    );
  }
}
