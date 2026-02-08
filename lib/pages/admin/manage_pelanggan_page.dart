import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../models/siswa.dart';

class ManagePelangganPage extends StatefulWidget {
  const ManagePelangganPage({super.key});

  @override
  State<ManagePelangganPage> createState() => _ManagePelangganPageState();
}

class _ManagePelangganPageState extends State<ManagePelangganPage> {
  final List<Siswa> _pelanggans = [
    Siswa(id: 1, namaSiswa: 'Ahmad Rizki', alamat: 'Jl. Merdeka No. 10', telp: '08123456789', idUser: 10),
    Siswa(id: 2, namaSiswa: 'Siti Nurhaliza', alamat: 'Jl. Sudirman No. 25', telp: '08234567890', idUser: 11),
    Siswa(id: 3, namaSiswa: 'Budi Santoso', alamat: 'Jl. Gatot Subroto No. 5', telp: '08345678901', idUser: 12),
  ];

  void _showPelangganDialog({Siswa? pelanggan}) {
    final isEdit = pelanggan != null;
    final namaController = TextEditingController(text: pelanggan?.namaSiswa);
    final alamatController = TextEditingController(text: pelanggan?.alamat);
    final telpController = TextEditingController(text: pelanggan?.telp);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEdit ? 'Edit Pelanggan' : 'Tambah Pelanggan'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Siswa',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: alamatController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Alamat',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: telpController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'No. Telepon',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (namaController.text.isNotEmpty && 
                  alamatController.text.isNotEmpty && 
                  telpController.text.isNotEmpty) {
                setState(() {
                  if (isEdit) {
                    final index = _pelanggans.indexWhere((p) => p.id == pelanggan.id);
                    _pelanggans[index] = Siswa(
                      id: pelanggan.id,
                      namaSiswa: namaController.text,
                      alamat: alamatController.text,
                      telp: telpController.text,
                      idUser: pelanggan.idUser,
                    );
                  } else {
                    _pelanggans.add(Siswa(
                      id: _pelanggans.length + 1,
                      namaSiswa: namaController.text,
                      alamat: alamatController.text,
                      telp: telpController.text,
                      idUser: 100 + _pelanggans.length,
                    ));
                  }
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(isEdit ? 'Pelanggan berhasil diupdate' : 'Pelanggan berhasil ditambahkan'),
                    backgroundColor: AppColors.primaryRed,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
            ),
            child: Text(isEdit ? 'Update' : 'Tambah'),
          ),
        ],
      ),
    );
  }

  void _deletePelanggan(Siswa pelanggan) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Pelanggan'),
        content: Text('Apakah Anda yakin ingin menghapus ${pelanggan.namaSiswa}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _pelanggans.removeWhere((p) => p.id == pelanggan.id);
              });
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Pelanggan berhasil dihapus'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Data Pelanggan'),
        backgroundColor: AppColors.primaryRed,
        foregroundColor: AppColors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _pelanggans.length,
        itemBuilder: (context, index) {
          final pelanggan = _pelanggans[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: CircleAvatar(
                radius: 30,
                backgroundColor: AppColors.primaryRed,
                child: Text(
                  pelanggan.namaSiswa[0].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                pelanggan.namaSiswa,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.home, size: 16, color: AppColors.gray),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(pelanggan.alamat),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.phone, size: 16, color: AppColors.gray),
                      const SizedBox(width: 4),
                      Text(pelanggan.telp),
                    ],
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _showPelangganDialog(pelanggan: pelanggan),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deletePelanggan(pelanggan),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showPelangganDialog(),
        backgroundColor: AppColors.primaryRed,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Pelanggan'),
      ),
    );
  }
}
