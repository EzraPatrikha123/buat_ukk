import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../utils/app_colors.dart';
import '../../models/transaksi.dart';
import 'receipt_page.dart';

class OrderStatusPage extends StatefulWidget {
  const OrderStatusPage({super.key});

  @override
  State<OrderStatusPage> createState() => _OrderStatusPageState();
}

class _OrderStatusPageState extends State<OrderStatusPage> {
  // Mock data
  final List<Transaksi> _orders = [
    Transaksi(
      id: 1,
      tanggal: DateTime.now().subtract(const Duration(minutes: 15)),
      idStan: 1,
      idSiswa: 1,
      status: StatusTransaksi.dimasak,
      detailTransaksi: [
        DetailTransaksi(id: 1, idTransaksi: 1, idMenu: 1, qty: 2, hargaBeli: 15000, namaMenu: 'Nasi Goreng'),
        DetailTransaksi(id: 2, idTransaksi: 1, idMenu: 3, qty: 1, hargaBeli: 3000, namaMenu: 'Es Teh Manis'),
      ],
    ),
    Transaksi(
      id: 2,
      tanggal: DateTime.now().subtract(const Duration(hours: 1)),
      idStan: 2,
      idSiswa: 1,
      status: StatusTransaksi.diantar,
      detailTransaksi: [
        DetailTransaksi(id: 3, idTransaksi: 2, idMenu: 5, qty: 1, hargaBeli: 10000, namaMenu: 'Bakso'),
      ],
    ),
    Transaksi(
      id: 3,
      tanggal: DateTime.now().subtract(const Duration(minutes: 5)),
      idStan: 1,
      idSiswa: 1,
      status: StatusTransaksi.belum_dikonfirm,
      detailTransaksi: [
        DetailTransaksi(id: 4, idTransaksi: 3, idMenu: 2, qty: 1, hargaBeli: 12000, namaMenu: 'Mie Goreng'),
        DetailTransaksi(id: 5, idTransaksi: 3, idMenu: 4, qty: 2, hargaBeli: 5000, namaMenu: 'Jeruk Panas'),
      ],
    ),
  ];

  String _getStatusLabel(StatusTransaksi status) {
    switch (status) {
      case StatusTransaksi.belum_dikonfirm:
        return 'Belum Dikonfirm';
      case StatusTransaksi.dimasak:
        return 'Sedang Dimasak';
      case StatusTransaksi.diantar:
        return 'Sedang Diantar';
      case StatusTransaksi.sampai:
        return 'Selesai';
    }
  }

  Color _getStatusColor(StatusTransaksi status) {
    switch (status) {
      case StatusTransaksi.belum_dikonfirm:
        return Colors.orange;
      case StatusTransaksi.dimasak:
        return Colors.blue;
      case StatusTransaksi.diantar:
        return Colors.purple;
      case StatusTransaksi.sampai:
        return Colors.green;
    }
  }

  IconData _getStatusIcon(StatusTransaksi status) {
    switch (status) {
      case StatusTransaksi.belum_dikonfirm:
        return Icons.pending;
      case StatusTransaksi.dimasak:
        return Icons.restaurant;
      case StatusTransaksi.diantar:
        return Icons.delivery_dining;
      case StatusTransaksi.sampai:
        return Icons.check_circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final dateFormat = DateFormat('dd MMM yyyy, HH:mm');

    // Filter only active orders (not yet completed)
    final activeOrders = _orders.where((o) => o.status != StatusTransaksi.sampai).toList();

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          backgroundColor: AppColors.primaryRed,
          title: const Text('Status Pesanan'),
        ),
        
        if (activeOrders.isEmpty)
          SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long,
                    size: 100,
                    color: AppColors.gray,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Tidak ada pesanan aktif',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.gray,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final order = activeOrders[index];
                  return _buildOrderCard(order, currencyFormat, dateFormat);
                },
                childCount: activeOrders.length,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildOrderCard(Transaksi order, NumberFormat currencyFormat, DateFormat dateFormat) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pesanan #${order.id}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order.status),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getStatusIcon(order.status),
                        size: 16,
                        color: AppColors.white,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _getStatusLabel(order.status),
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              dateFormat.format(order.tanggal),
              style: TextStyle(
                fontSize: 12,
                color: AppColors.gray,
              ),
            ),
            const Divider(height: 24),
            
            // Order items
            ...order.detailTransaksi.map((detail) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${detail.qty}x ${detail.namaMenu}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  Text(
                    currencyFormat.format(detail.hargaBeli * detail.qty),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )),
            const Divider(height: 24),
            
            // Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  currencyFormat.format(order.totalHarga),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryRed,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Progress indicator
            _buildProgressIndicator(order.status),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(StatusTransaksi currentStatus) {
    final steps = [
      StatusTransaksi.belum_dikonfirm,
      StatusTransaksi.dimasak,
      StatusTransaksi.diantar,
      StatusTransaksi.sampai,
    ];
    final currentIndex = steps.indexOf(currentStatus);

    return Row(
      children: List.generate(steps.length * 2 - 1, (index) {
        if (index.isEven) {
          final stepIndex = index ~/ 2;
          final isActive = stepIndex <= currentIndex;
          return Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: isActive ? AppColors.primaryRed : AppColors.gray.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getStatusIcon(steps[stepIndex]),
              size: 16,
              color: AppColors.white,
            ),
          );
        } else {
          final isActive = (index ~/ 2) < currentIndex;
          return Expanded(
            child: Container(
              height: 2,
              color: isActive ? AppColors.primaryRed : AppColors.gray.withOpacity(0.3),
            ),
          );
        }
      }),
    );
  }
}
