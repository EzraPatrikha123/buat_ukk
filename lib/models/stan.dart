class Stan {
  final int id;
  final String namaStan;
  final String namaPemilik;
  final String telp;
  final int idUser;

  Stan({
    required this.id,
    required this.namaStan,
    required this.namaPemilik,
    required this.telp,
    required this.idUser,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_stan': namaStan,
      'nama_pemilik': namaPemilik,
      'telp': telp,
      'id_user': idUser,
    };
  }

  factory Stan.fromJson(Map<String, dynamic> json) {
    return Stan(
      id: json['id'] ?? 0,
      namaStan: json['nama_stan'] ?? '',
      namaPemilik: json['nama_pemilik'] ?? '',
      telp: json['telp'] ?? '',
      idUser: json['id_user'] ?? 0,
    );
  }
}
