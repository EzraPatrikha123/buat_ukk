import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../utils/app_colors.dart';
import '../../models/menu.dart';
import '../../models/stan.dart';
import '../../models/diskon.dart';
import '../../models/transaksi.dart';
import 'order_status_page.dart';

class CartPage extends StatefulWidget {
  final Map<int, int> cart;
  final List<Menu> menus;
  final Stan stan;
  final List<Diskon> diskons;
  final List<MenuDiskon> menuDiskons;

  const CartPage({
    super.key,
    required this.cart,
    required this.menus,
    required this.stan,
    required this.diskons,
    required this.menuDiskons,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Map<int, int> _cart;

  @override
  void initState() {
    super.initState();
    _cart = Map.from(widget.cart);
  }

  Diskon? _getActiveDiscount(int menuId) {
    final menuDiskon = widget.menuDiskons.where((md) => md.idMenu == menuId).firstOrNull;
    if (menuDiskon == null) return null;
    
    final diskon = widget.diskons.where((d) => d.id == menuDiskon.idDiskon).firstOrNull;
    if (diskon == null || !diskon.isActive) return null;
    
    return diskon;
  }

  double _getMenuPrice(Menu menu) {
    final diskon = _getActiveDiscount(menu.id);
    if (diskon != null) {
      return menu.harga * (1 - diskon.persentaseDiskon / 100);
    }
    return menu.harga;
  }

  double get _totalPrice {
    double total = 0;
    for (final entry in _cart.entries) {
      final menu = widget.menus.firstWhere((m) => m.id == entry.key);
      total += _getMenuPrice(menu) * entry.value;
    }
    return total;
  }

  void _updateQuantity(int menuId, int delta) {
    setState(() {
      final newQty = (_cart[menuId] ?? 0) + delta;
      if (newQty <= 0) {
        _cart.remove(menuId);
      } else {
        _cart[menuId] = newQty;
      }
    });
  }

  void _checkout() {
    if (_cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Keranjang kosong')),
      );
      return;
    }

    // Create order
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Pesanan'),
        content: const Text('Apakah Anda yakin ingin melakukan checkout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Go back to stan detail
              Navigator.of(context).pop(); // Go back to home
              
              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Pesanan berhasil! Cek status pesanan Anda.'),
                  backgroundColor: AppColors.primaryRed,
                  duration: const Duration(seconds: 3),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
            ),
            child: const Text('Ya, Checkout'),
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
        title: const Text('Keranjang'),
        backgroundColor: AppColors.primaryRed,
        foregroundColor: AppColors.white,
      ),
      body: _cart.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 100,
                    color: AppColors.gray,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Keranjang kosong',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.gray,
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _cart.length,
                    itemBuilder: (context, index) {
                      final menuId = _cart.keys.elementAt(index);
                      final qty = _cart[menuId]!;
                      final menu = widget.menus.firstWhere((m) => m.id == menuId);
                      final price = _getMenuPrice(menu);
                      final diskon = _getActiveDiscount(menu.id);

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              // Image placeholder
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryRed.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  menu.jenis == JenisMenu.makanan 
                                      ? Icons.fastfood 
                                      : Icons.local_drink,
                                  color: AppColors.primaryRed,
                                ),
                              ),
                              const SizedBox(width: 12),
                              
                              // Menu info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      menu.namaMakanan,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    if (diskon != null)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.orange,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          '${diskon.persentaseDiskon}% OFF',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    const SizedBox(height: 4),
                                    Text(
                                      currencyFormat.format(price),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryRed,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              // Quantity controls
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () => _updateQuantity(menuId, -1),
                                        icon: const Icon(Icons.remove_circle_outline),
                                        color: AppColors.primaryRed,
                                        constraints: const BoxConstraints(),
                                        padding: EdgeInsets.zero,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                        child: Text(
                                          '$qty',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () => _updateQuantity(menuId, 1),
                                        icon: const Icon(Icons.add_circle_outline),
                                        color: AppColors.primaryRed,
                                        constraints: const BoxConstraints(),
                                        padding: EdgeInsets.zero,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    currencyFormat.format(price * qty),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.gray,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                
                // Total and checkout
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              currencyFormat.format(_totalPrice),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryRed,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _checkout,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryRed,
                              foregroundColor: AppColors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Checkout',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
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
