enum StatusTransaksi { belum_dikonfirm, dimasak, diantar, sampai }

class Transaksi {
  final int id;
  final DateTime tanggal;
  final int idStan;
  final int idSiswa;
  final StatusTransaksi status;
  final List<DetailTransaksi> detailTransaksi;

  Transaksi({
    required this.id,
    required this.tanggal,
    required this.idStan,
    required this.idSiswa,
    required this.status,
    this.detailTransaksi = const [],
  });

  double get totalHarga {
    return detailTransaksi.fold(0, (sum, item) => sum + (item.hargaBeli * item.qty));
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tanggal': tanggal.toIso8601String(),
      'id_stan': idStan,
      'id_siswa': idSiswa,
      'status': status.toString(),
    };
  }

  factory Transaksi.fromJson(Map<String, dynamic> json) {
    return Transaksi(
      id: json['id'],
      tanggal: DateTime.parse(json['tanggal']),
      idStan: json['id_stan'],
      idSiswa: json['id_siswa'],
      status: StatusTransaksi.values.firstWhere(
        (e) => e.toString() == json['status'],
      ),
    );
  }
}

class DetailTransaksi {
  final int id;
  final int idTransaksi;
  final int idMenu;
  final int qty;
  final double hargaBeli;
  final String? namaMenu;

  DetailTransaksi({
    required this.id,
    required this.idTransaksi,
    required this.idMenu,
    required this.qty,
    required this.hargaBeli,
    this.namaMenu,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_transaksi': idTransaksi,
      'id_menu': idMenu,
      'qty': qty,
      'harga_beli': hargaBeli,
    };
  }

  factory DetailTransaksi.fromJson(Map<String, dynamic> json) {
    return DetailTransaksi(
      id: json['id'],
      idTransaksi: json['id_transaksi'],
      idMenu: json['id_menu'],
      qty: json['qty'],
      hargaBeli: json['harga_beli'].toDouble(),
    );
  }
}
