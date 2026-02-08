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
      id: json['id'] ?? 0,
      namaDiskon: json['nama_diskon'] ?? '',
      persentaseDiskon: json['persentase_diskon'] ?? 0,
      tanggalAwal: json['tanggal_awal'] != null 
          ? DateTime.parse(json['tanggal_awal']) 
          : DateTime.now(),
      tanggalAkhir: json['tanggal_akhir'] != null 
          ? DateTime.parse(json['tanggal_akhir']) 
          : DateTime.now(),
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
      id: json['id'] ?? 0,
      idMenu: json['id_menu'] ?? 0,
      idDiskon: json['id_diskon'] ?? 0,
    );
  }
}
