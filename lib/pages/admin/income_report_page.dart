import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../utils/app_colors.dart';

class IncomeReportPage extends StatefulWidget {
  const IncomeReportPage({super.key});

  @override
  State<IncomeReportPage> createState() => _IncomeReportPageState();
}

class _IncomeReportPageState extends State<IncomeReportPage> {
  String _selectedMonth = DateFormat('MMMM yyyy').format(DateTime.now());

  // Mock income data
  final Map<String, Map<String, dynamic>> _incomeData = {
    'February 2026': {
      'total': 1250000,
      'orders': 42,
      'daily': [
        {'date': '1 Feb', 'amount': 45000},
        {'date': '2 Feb', 'amount': 67000},
        {'date': '3 Feb', 'amount': 52000},
        {'date': '4 Feb', 'amount': 78000},
        {'date': '5 Feb', 'amount': 65000},
        {'date': '6 Feb', 'amount': 89000},
        {'date': '7 Feb', 'amount': 72000},
        {'date': '8 Feb', 'amount': 55000},
      ],
    },
    'January 2026': {
      'total': 980000,
      'orders': 35,
      'daily': [
        {'date': '1 Jan', 'amount': 35000},
        {'date': '2 Jan', 'amount': 42000},
        {'date': '3 Jan', 'amount': 48000},
      ],
    },
  };

  List<String> get _availableMonths => _incomeData.keys.toList();

  Map<String, dynamic> get _currentData => _incomeData[_selectedMonth] ?? {'total': 0, 'orders': 0, 'daily': []};

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Laporan Pemasukan'),
        backgroundColor: AppColors.primaryRed,
        foregroundColor: AppColors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Month selector
            Container(
              padding: const EdgeInsets.all(16),
              color: AppColors.white,
              child: DropdownButtonFormField<String>(
                value: _selectedMonth,
                decoration: InputDecoration(
                  labelText: 'Pilih Bulan',
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
            
            // Summary cards
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      'Total Pemasukan',
                      currencyFormat.format(_currentData['total']),
                      Icons.attach_money,
                      Colors.green,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSummaryCard(
                      'Total Pesanan',
                      '${_currentData['orders']}',
                      Icons.receipt_long,
                      Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            
            // Chart visualization (simple bar chart)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Pemasukan Harian',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildChart(),
                    ],
                  ),
                ),
              ),
            ),
            
            // Daily breakdown
            Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Rincian Harian',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ..._currentData['daily'].map<Widget>((day) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                day['date'],
                                style: const TextStyle(fontSize: 14),
                              ),
                              Text(
                                currencyFormat.format(day['amount']),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryRed,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.gray,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChart() {
    final dailyData = _currentData['daily'] as List;
    if (dailyData.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            'Tidak ada data',
            style: TextStyle(color: AppColors.gray),
          ),
        ),
      );
    }

    final maxAmount = dailyData.map((d) => d['amount'] as int).reduce((a, b) => a > b ? a : b);

    return Column(
      children: dailyData.map<Widget>((day) {
        final amount = day['amount'] as int;
        final percentage = amount / maxAmount;
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              SizedBox(
                width: 50,
                child: Text(
                  day['date'],
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              Expanded(
                child: Container(
                  height: 30,
                  decoration: BoxDecoration(
                    color: AppColors.primaryRed.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: percentage,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primaryRed,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 70,
                child: Text(
                  'Rp ${(amount / 1000).toStringAsFixed(0)}K',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
