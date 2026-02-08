import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../utils/app_colors.dart';
import '../../models/transaksi.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  String _selectedMonth = DateFormat('MMMM yyyy').format(DateTime.now());

  final List<Transaksi> _allOrders = [
    Transaksi(
      id: 1,
      tanggal: DateTime.now().subtract(const Duration(hours: 2)),
      idStan: 1,
      idSiswa: 1,
      status: StatusTransaksi.belum_dikonfirm,
      detailTransaksi: [
        DetailTransaksi(id: 1, idTransaksi: 1, idMenu: 1, qty: 2, hargaBeli: 15000, namaMenu: 'Nasi Goreng'),
        DetailTransaksi(id: 2, idTransaksi: 1, idMenu: 3, qty: 1, hargaBeli: 3000, namaMenu: 'Es Teh Manis'),
      ],
    ),
    Transaksi(
      id: 2,
      tanggal: DateTime.now().subtract(const Duration(hours: 3)),
      idStan: 1,
      idSiswa: 2,
      status: StatusTransaksi.dimasak,
      detailTransaksi: [
        DetailTransaksi(id: 3, idTransaksi: 2, idMenu: 2, qty: 1, hargaBeli: 12000, namaMenu: 'Mie Goreng'),
      ],
    ),
    Transaksi(
      id: 3,
      tanggal: DateTime.now().subtract(const Duration(hours: 1)),
      idStan: 1,
      idSiswa: 3,
      status: StatusTransaksi.diantar,
      detailTransaksi: [
        DetailTransaksi(id: 4, idTransaksi: 3, idMenu: 1, qty: 1, hargaBeli: 15000, namaMenu: 'Nasi Goreng'),
        DetailTransaksi(id: 5, idTransaksi: 3, idMenu: 4, qty: 2, hargaBeli: 5000, namaMenu: 'Jeruk Panas'),
      ],
    ),
  ];

  List<String> get _availableMonths {
    final months = <String>{};
    for (final order in _allOrders) {
      months.add(DateFormat('MMMM yyyy').format(order.tanggal));
    }
    return months.toList()..sort((a, b) => b.compareTo(a));
  }

  List<Transaksi> get _filteredOrders {
    return _allOrders.where((o) {
      final monthYear = DateFormat('MMMM yyyy').format(o.tanggal);
      return monthYear == _selectedMonth;
    }).toList()
      ..sort((a, b) => b.tanggal.compareTo(a.tanggal));
  }

  void _updateOrderStatus(Transaksi order) {
    final nextStatus = _getNextStatus(order.status);
    if (nextStatus == null) return;

    setState(() {
      final index = _allOrders.indexWhere((o) => o.id == order.id);
      _allOrders[index] = Transaksi(
        id: order.id,
        tanggal: order.tanggal,
        idStan: order.idStan,
        idSiswa: order.idSiswa,
        status: nextStatus,
        detailTransaksi: order.detailTransaksi,
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Status pesanan diupdate ke ${_getStatusLabel(nextStatus)}'),
        backgroundColor: AppColors.primaryRed,
      ),
    );
  }

  StatusTransaksi? _getNextStatus(StatusTransaksi currentStatus) {
    switch (currentStatus) {
      case StatusTransaksi.belum_dikonfirm:
        return StatusTransaksi.dimasak;
      case StatusTransaksi.dimasak:
        return StatusTransaksi.diantar;
      case StatusTransaksi.diantar:
        return StatusTransaksi.sampai;
      case StatusTransaksi.sampai:
        return null;
    }
  }

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

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final dateFormat = DateFormat('dd MMM yyyy, HH:mm');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Kelola Pesanan'),
        backgroundColor: AppColors.primaryRed,
        foregroundColor: AppColors.white,
      ),
      body: Column(
        children: [
          // Month filter
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.white,
            child: DropdownButtonFormField<String>(
              value: _selectedMonth,
              decoration: InputDecoration(
                labelText: 'Filter Bulan',
                prefixIcon: Icon(Icons.calendar_today, color: AppColors.primaryRed),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: _availableMonths.map((month) {
                return DropdownMenuItem(
                  value: month,
                  child: Text(month),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedMonth = value;
                  });
                }
              },
            ),
          ),
          
          // Orders list
          Expanded(
            child: _filteredOrders.isEmpty
                ? Center(
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
                          'Tidak ada pesanan',
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.gray,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredOrders.length,
                    itemBuilder: (context, index) {
                      final order = _filteredOrders[index];
                      return _buildOrderCard(order, currencyFormat, dateFormat);
                    },
                  ),
          ),
        ],
      ),
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pesanan #${order.id}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dateFormat.format(order.tanggal),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.gray,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order.status),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _getStatusLabel(order.status),
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            
            // Order items
            ...order.detailTransaksi.map((detail) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text('${detail.qty}x ${detail.namaMenu}'),
                  ),
                  Text(
                    currencyFormat.format(detail.hargaBeli * detail.qty),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )),
            const Divider(height: 24),
            
            // Total and action button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total'),
                    Text(
                      currencyFormat.format(order.totalHarga),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryRed,
                      ),
                    ),
                  ],
                ),
                if (order.status != StatusTransaksi.sampai)
                  ElevatedButton(
                    onPressed: () => _updateOrderStatus(order),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryRed,
                      foregroundColor: AppColors.white,
                    ),
                    child: Text(_getNextStatusLabel(order.status)),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getNextStatusLabel(StatusTransaksi status) {
    switch (status) {
      case StatusTransaksi.belum_dikonfirm:
        return 'Konfirmasi';
      case StatusTransaksi.dimasak:
        return 'Antar';
      case StatusTransaksi.diantar:
        return 'Selesai';
      case StatusTransaksi.sampai:
        return 'Selesai';
    }
  }
}
