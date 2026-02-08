import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../utils/app_colors.dart';
import '../../models/stan.dart';
import '../../models/menu.dart';
import '../../models/diskon.dart';
import 'cart_page.dart';

class StanDetailPage extends StatefulWidget {
  final Stan stan;

  const StanDetailPage({super.key, required this.stan});

  @override
  State<StanDetailPage> createState() => _StanDetailPageState();
}

class _StanDetailPageState extends State<StanDetailPage> {
  String _selectedCategory = 'Semua';
  final Map<int, int> _cart = {};
  
  // Mock menu data
  late final List<Menu> _allMenus;
  late final List<Diskon> _diskons;
  late final List<MenuDiskon> _menuDiskons;

  @override
  void initState() {
    super.initState();
    _initMockData();
  }

  void _initMockData() {
    _allMenus = [
      Menu(id: 1, namaMakanan: 'Nasi Goreng', harga: 15000, jenis: JenisMenu.makanan, deskripsi: 'Nasi goreng spesial dengan telur', idStan: widget.stan.id),
      Menu(id: 2, namaMakanan: 'Mie Goreng', harga: 12000, jenis: JenisMenu.makanan, deskripsi: 'Mie goreng pedas', idStan: widget.stan.id),
      Menu(id: 3, namaMakanan: 'Es Teh Manis', harga: 3000, jenis: JenisMenu.minuman, deskripsi: 'Teh manis segar', idStan: widget.stan.id),
      Menu(id: 4, namaMakanan: 'Jeruk Panas', harga: 5000, jenis: JenisMenu.minuman, deskripsi: 'Jeruk hangat nikmat', idStan: widget.stan.id),
      Menu(id: 5, namaMakanan: 'Bakso', harga: 10000, jenis: JenisMenu.makanan, deskripsi: 'Bakso kuah dengan mie', idStan: widget.stan.id),
      Menu(id: 6, namaMakanan: 'Soto Ayam', harga: 13000, jenis: JenisMenu.makanan, deskripsi: 'Soto ayam bumbu kuning', idStan: widget.stan.id),
    ];

    _diskons = [
      Diskon(
        id: 1,
        namaDiskon: 'Diskon 20%',
        persentaseDiskon: 20,
        tanggalAwal: DateTime.now().subtract(const Duration(days: 5)),
        tanggalAkhir: DateTime.now().add(const Duration(days: 10)),
      ),
      Diskon(
        id: 2,
        namaDiskon: 'Diskon 15%',
        persentaseDiskon: 15,
        tanggalAwal: DateTime.now().subtract(const Duration(days: 3)),
        tanggalAkhir: DateTime.now().add(const Duration(days: 7)),
      ),
    ];

    _menuDiskons = [
      MenuDiskon(id: 1, idMenu: 1, idDiskon: 1), // Nasi Goreng 20% off
      MenuDiskon(id: 2, idMenu: 3, idDiskon: 2), // Es Teh 15% off
    ];
  }

  List<Menu> get _filteredMenus {
    if (_selectedCategory == 'Semua') {
      return _allMenus;
    } else if (_selectedCategory == 'Makanan') {
      return _allMenus.where((m) => m.jenis == JenisMenu.makanan).toList();
    } else {
      return _allMenus.where((m) => m.jenis == JenisMenu.minuman).toList();
    }
  }

  Diskon? _getActiveDiscount(int menuId) {
    final menuDiskon = _menuDiskons.where((md) => md.idMenu == menuId).firstOrNull;
    if (menuDiskon == null) return null;
    
    final diskon = _diskons.where((d) => d.id == menuDiskon.idDiskon).firstOrNull;
    if (diskon == null || !diskon.isActive) return null;
    
    return diskon;
  }

  void _addToCart(Menu menu) {
    setState(() {
      _cart[menu.id] = (_cart[menu.id] ?? 0) + 1;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${menu.namaMakanan} ditambahkan ke keranjang'),
        duration: const Duration(seconds: 1),
        backgroundColor: AppColors.primaryRed,
      ),
    );
  }

  int get _cartItemCount {
    return _cart.values.fold(0, (sum, qty) => sum + qty);
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App Bar with banner
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.primaryRed,
            foregroundColor: AppColors.white,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(widget.stan.namaStan),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.darkRed,
                      AppColors.primaryRed,
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.restaurant,
                    size: 80,
                    color: AppColors.white.withOpacity(0.3),
                  ),
                ),
              ),
            ),
            actions: [
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CartPage(
                            cart: _cart,
                            menus: _allMenus,
                            stan: widget.stan,
                            diskons: _diskons,
                            menuDiskons: _menuDiskons,
                          ),
                        ),
                      );
                    },
                  ),
                  if (_cartItemCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '$_cartItemCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          
          // Category filter
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  _buildCategoryChip('Semua'),
                  const SizedBox(width: 8),
                  _buildCategoryChip('Makanan'),
                  const SizedBox(width: 8),
                  _buildCategoryChip('Minuman'),
                ],
              ),
            ),
          ),
          
          // Menu grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final menu = _filteredMenus[index];
                  final diskon = _getActiveDiscount(menu.id);
                  return _buildMenuCard(menu, diskon, currencyFormat);
                },
                childCount: _filteredMenus.length,
              ),
            ),
          ),
          
          const SliverToBoxAdapter(
            child: SizedBox(height: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    final isSelected = _selectedCategory == category;
    return FilterChip(
      label: Text(category),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedCategory = category;
        });
      },
      selectedColor: AppColors.primaryRed,
      checkmarkColor: AppColors.white,
      labelStyle: TextStyle(
        color: isSelected ? AppColors.white : AppColors.gray,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildMenuCard(Menu menu, Diskon? diskon, NumberFormat currencyFormat) {
    final hasDiscount = diskon != null;
    final discountedPrice = hasDiscount 
        ? menu.harga * (1 - diskon.persentaseDiskon / 100)
        : menu.harga;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder with discount badge
          Stack(
            children: [
              Container(
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.primaryRed.withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Center(
                  child: Icon(
                    menu.jenis == JenisMenu.makanan ? Icons.fastfood : Icons.local_drink,
                    size: 50,
                    color: AppColors.primaryRed,
                  ),
                ),
              ),
              if (hasDiscount)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${diskon.persentaseDiskon}% OFF',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    menu.namaMakanan,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  if (hasDiscount) ...[
                    Text(
                      currencyFormat.format(menu.harga),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.gray,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    Text(
                      currencyFormat.format(discountedPrice),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryRed,
                      ),
                    ),
                  ] else
                    Text(
                      currencyFormat.format(menu.harga),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryRed,
                      ),
                    ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _addToCart(menu),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryRed,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Tambah',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
