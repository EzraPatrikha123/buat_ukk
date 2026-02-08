import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../utils/app_colors.dart';
import '../../models/transaksi.dart';
import '../../services/api_service.dart';
import 'receipt_page.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String _selectedMonth = DateFormat('MMMM yyyy').format(DateTime.now());
  List<Transaksi> _allTransactions = [];
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    try {
      final data = await ApiService.getTransaksiSiswa();
      setState(() {
        _allTransactions = data.map((json) => Transaksi.fromJson(json)).toList();
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
    Transaksi(
      id: 4,
      tanggal: DateTime(2026, 1, 15),
      idStan: 3,
      idSiswa: 1,
      status: StatusTransaksi.sampai,
      detailTransaksi: [
        DetailTransaksi(id: 6, idTransaksi: 4, idMenu: 6, qty: 1, hargaBeli: 13000, namaMenu: 'Soto Ayam'),
      ],
    ),
  ];

  List<String> get _availableMonths {
    final months = <String>{};
    for (final transaction in _allTransactions) {
      months.add(DateFormat('MMMM yyyy').format(transaction.tanggal));
    }
    return months.toList()..sort((a, b) => b.compareTo(a));
  }

  List<Transaksi> get _filteredTransactions {
    return _allTransactions.where((t) {
      final monthYear = DateFormat('MMMM yyyy').format(t.tanggal);
      return monthYear == _selectedMonth && t.status == StatusTransaksi.sampai;
    }).toList()
      ..sort((a, b) => b.tanggal.compareTo(a.tanggal));
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final dateFormat = DateFormat('dd MMM yyyy, HH:mm');

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          backgroundColor: AppColors.primaryRed,
          title: const Text('Riwayat Transaksi'),
        ),
        
        // Month filter dropdown
        SliverToBoxAdapter(
          child: Container(
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
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.gray.withOpacity(0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.primaryRed, width: 2),
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
        ),
        
        // Transaction list
        if (_filteredTransactions.isEmpty)
          SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: 100,
                    color: AppColors.gray,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Tidak ada riwayat transaksi',
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
                  final transaction = _filteredTransactions[index];
                  return _buildTransactionCard(transaction, currencyFormat, dateFormat);
                },
                childCount: _filteredTransactions.length,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTransactionCard(Transaksi transaction, NumberFormat currencyFormat, DateFormat dateFormat) {
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
            // Transaction header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pesanan #${transaction.id}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dateFormat.format(transaction.tanggal),
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
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 16,
                        color: AppColors.white,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Selesai',
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
            const Divider(height: 24),
            
            // Transaction items
            ...transaction.detailTransaksi.map((detail) => Padding(
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
            
            // Total and receipt button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      currencyFormat.format(transaction.totalHarga),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryRed,
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ReceiptPage(transaksi: transaction),
                      ),
                    );
                  },
                  icon: const Icon(Icons.receipt),
                  label: const Text('Lihat Nota'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryRed,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
