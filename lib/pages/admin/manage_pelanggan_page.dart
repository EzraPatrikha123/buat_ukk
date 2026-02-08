import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../models/siswa.dart';
import '../../services/api_service.dart';

class ManagePelangganPage extends StatefulWidget {
  const ManagePelangganPage({super.key});

  @override
  State<ManagePelangganPage> createState() => _ManagePelangganPageState();
}

class _ManagePelangganPageState extends State<ManagePelangganPage> {
  List<Siswa> _pelanggans = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPelanggans();
  }

  Future<void> _loadPelanggans() async {
    try {
      final data = await ApiService.getAllPelanggan();
      setState(() {
        _pelanggans = data.map((json) => Siswa.fromJson(json)).toList();
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
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
              trailing: const Icon(Icons.chevron_right),
            ),
          );
        },
      ),
    );
  }
}
