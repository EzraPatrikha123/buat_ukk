import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../models/stan.dart';
import 'stan_detail_page.dart';
import 'order_status_page.dart';
import 'history_page.dart';

class SiswaHomePage extends StatefulWidget {
  const SiswaHomePage({super.key});

  @override
  State<SiswaHomePage> createState() => _SiswaHomePageState();
}

class _SiswaHomePageState extends State<SiswaHomePage> {
  int _selectedIndex = 0;
  final _searchController = TextEditingController();

  // Mock data
  final List<Stan> _stans = [
    Stan(id: 1, namaStan: 'Stan Makanan Bu Ani', namaPemilik: 'Bu Ani', telp: '08123456789', idUser: 2),
    Stan(id: 2, namaStan: 'Stan Minuman Pak Budi', namaPemilik: 'Pak Budi', telp: '08234567890', idUser: 3),
    Stan(id: 3, namaStan: 'Stan Snack & Jajanan', namaPemilik: 'Bu Citra', telp: '08345678901', idUser: 4),
    Stan(id: 4, namaStan: 'Stan Nasi Goreng', namaPemilik: 'Pak Dodi', telp: '08456789012', idUser: 5),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildHomePage() {
    return CustomScrollView(
      slivers: [
        // App Bar
        SliverAppBar(
          floating: true,
          backgroundColor: AppColors.primaryRed,
          title: const Text('Kantin Sekolah'),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Notifikasi')),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profil')),
                );
              },
            ),
          ],
        ),
        
        // Search bar
        SliverToBoxAdapter(
          child: Container(
            color: AppColors.primaryRed,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari stan atau menu...',
                prefixIcon: Icon(Icons.search, color: AppColors.gray),
                filled: true,
                fillColor: AppColors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
        
        // Stan list
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final stan = _stans[index];
                return _buildStanCard(stan);
              },
              childCount: _stans.length,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStanCard(Stan stan) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => StanDetailPage(stan: stan),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner image placeholder
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: AppColors.primaryRed.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.store,
                  size: 60,
                  color: AppColors.primaryRed,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stan.namaStan,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.person, size: 16, color: AppColors.gray),
                      const SizedBox(width: 4),
                      Text(
                        stan.namaPemilik,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.gray,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.phone, size: 16, color: AppColors.gray),
                      const SizedBox(width: 4),
                      Text(
                        stan.telp,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.gray,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildHomePage(),
      const OrderStatusPage(),
      const HistoryPage(),
      _buildProfilePage(),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primaryRed,
        unselectedItemColor: AppColors.gray,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Pesanan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Riwayat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  Widget _buildProfilePage() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          backgroundColor: AppColors.primaryRed,
          title: const Text('Profil'),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverToBoxAdapter(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.primaryRed,
                  child: const Icon(Icons.person, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Nama Siswa',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'siswa@example.com',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.gray,
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.phone, color: AppColors.primaryRed),
                    title: const Text('Nomor Telepon'),
                    subtitle: const Text('08123456789'),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.home, color: AppColors.primaryRed),
                    title: const Text('Alamat'),
                    subtitle: const Text('Jl. Contoh No. 123'),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryRed,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  child: const Text('Logout'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
