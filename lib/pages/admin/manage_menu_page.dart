import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../utils/app_colors.dart';
import '../../models/menu.dart';

class ManageMenuPage extends StatefulWidget {
  const ManageMenuPage({super.key});

  @override
  State<ManageMenuPage> createState() => _ManageMenuPageState();
}

class _ManageMenuPageState extends State<ManageMenuPage> {
  final List<Menu> _menus = [
    Menu(id: 1, namaMakanan: 'Nasi Goreng', harga: 15000, jenis: JenisMenu.makanan, deskripsi: 'Nasi goreng spesial dengan telur', idStan: 1),
    Menu(id: 2, namaMakanan: 'Mie Goreng', harga: 12000, jenis: JenisMenu.makanan, deskripsi: 'Mie goreng pedas', idStan: 1),
    Menu(id: 3, namaMakanan: 'Es Teh Manis', harga: 3000, jenis: JenisMenu.minuman, deskripsi: 'Teh manis segar', idStan: 1),
    Menu(id: 4, namaMakanan: 'Jeruk Panas', harga: 5000, jenis: JenisMenu.minuman, deskripsi: 'Jeruk hangat nikmat', idStan: 1),
  ];

  void _showMenuDialog({Menu? menu}) {
    final isEdit = menu != null;
    final namaController = TextEditingController(text: menu?.namaMakanan);
    final hargaController = TextEditingController(text: menu?.harga.toString());
    final deskripsiController = TextEditingController(text: menu?.deskripsi);
    JenisMenu selectedJenis = menu?.jenis ?? JenisMenu.makanan;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(isEdit ? 'Edit Menu' : 'Tambah Menu'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: namaController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Menu',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: hargaController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Harga',
                    border: OutlineInputBorder(),
                    prefixText: 'Rp ',
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<JenisMenu>(
                  value: selectedJenis,
                  decoration: const InputDecoration(
                    labelText: 'Jenis',
                    border: OutlineInputBorder(),
                  ),
                  items: JenisMenu.values.map((jenis) {
                    return DropdownMenuItem(
                      value: jenis,
                      child: Text(jenis == JenisMenu.makanan ? 'Makanan' : 'Minuman'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setDialogState(() {
                      selectedJenis = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: deskripsiController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Deskripsi',
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
                if (namaController.text.isNotEmpty && hargaController.text.isNotEmpty) {
                  setState(() {
                    if (isEdit) {
                      final index = _menus.indexWhere((m) => m.id == menu.id);
                      _menus[index] = Menu(
                        id: menu.id,
                        namaMakanan: namaController.text,
                        harga: double.parse(hargaController.text),
                        jenis: selectedJenis,
                        deskripsi: deskripsiController.text,
                        idStan: 1,
                      );
                    } else {
                      _menus.add(Menu(
                        id: _menus.length + 1,
                        namaMakanan: namaController.text,
                        harga: double.parse(hargaController.text),
                        jenis: selectedJenis,
                        deskripsi: deskripsiController.text,
                        idStan: 1,
                      ));
                    }
                  });
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isEdit ? 'Menu berhasil diupdate' : 'Menu berhasil ditambahkan'),
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
      ),
    );
  }

  void _deleteMenu(Menu menu) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Menu'),
        content: Text('Apakah Anda yakin ingin menghapus ${menu.namaMakanan}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _menus.removeWhere((m) => m.id == menu.id);
              });
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Menu berhasil dihapus'),
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
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Kelola Menu'),
        backgroundColor: AppColors.primaryRed,
        foregroundColor: AppColors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _menus.length,
        itemBuilder: (context, index) {
          final menu = _menus[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.primaryRed.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  menu.jenis == JenisMenu.makanan ? Icons.fastfood : Icons.local_drink,
                  color: AppColors.primaryRed,
                  size: 30,
                ),
              ),
              title: Text(
                menu.namaMakanan,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(menu.deskripsi),
                  const SizedBox(height: 4),
                  Text(
                    currencyFormat.format(menu.harga),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryRed,
                    ),
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _showMenuDialog(menu: menu),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteMenu(menu),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showMenuDialog(),
        backgroundColor: AppColors.primaryRed,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Menu'),
      ),
    );
  }
}
