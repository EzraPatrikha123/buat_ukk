class Siswa {
  final int id;
  final String namaSiswa;
  final String alamat;
  final String telp;
  final int idUser;
  final String? foto;

  Siswa({
    required this.id,
    required this.namaSiswa,
    required this.alamat,
    required this.telp,
    required this.idUser,
    this.foto,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_siswa': namaSiswa,
      'alamat': alamat,
      'telp': telp,
      'id_user': idUser,
      'foto': foto,
    };
  }

  factory Siswa.fromJson(Map<String, dynamic> json) {
    return Siswa(
      id: json['id'],
      namaSiswa: json['nama_siswa'],
      alamat: json['alamat'],
      telp: json['telp'],
      idUser: json['id_user'],
      foto: json['foto'],
    );
  }
}
