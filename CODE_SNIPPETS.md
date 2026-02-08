# Kantin Sekolah - Key Code Snippets

## Essential Code Examples

### 1. Login Logic (pages/auth/login_page.dart)
```dart
void _login() {
  if (_formKey.currentState!.validate()) {
    final username = _usernameController.text;
    
    // Login logic: if username == "admin", navigate to AdminHomePage
    // Otherwise, navigate to SiswaHomePage
    if (username == "admin") {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AdminHomePage()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SiswaHomePage()),
      );
    }
  }
}
```

### 2. Color Definitions (utils/app_colors.dart)
```dart
class AppColors {
  static const Color white = Color(0xFFFFFFFF);
  static const Color primaryRed = Color(0xFFE53935);
  static const Color gray = Color(0xFF808080);
  static const Color darkRed = Color(0xFFB71C1C);
  static const Color background = Color(0xFFF5F5F5);
}
```

### 3. User Model with Role (models/user.dart)
```dart
enum UserRole { admin_stan, siswa }

class User {
  final int id;
  final String username;
  final String password;
  final UserRole role;
  // ... constructor and methods
}
```

### 4. Menu Model with Discount Support (models/menu.dart)
```dart
enum JenisMenu { makanan, minuman }

class Menu {
  final int id;
  final String namaMakanan;
  final double harga;
  final JenisMenu jenis;
  final String? foto;
  final String deskripsi;
  final int idStan;
  // ... constructor and methods
}
```

### 5. Transaction Model with Status (models/transaksi.dart)
```dart
enum StatusTransaksi { belum_dikonfirm, dimasak, diantar, sampai }

class Transaksi {
  final int id;
  final DateTime tanggal;
  final int idStan;
  final int idSiswa;
  final StatusTransaksi status;
  final List<DetailTransaksi> detailTransaksi;
  
  double get totalHarga {
    return detailTransaksi.fold(0, (sum, item) => 
      sum + (item.hargaBeli * item.qty));
  }
  // ... constructor and methods
}
```

### 6. Discount Logic (pages/siswa/stan_detail_page.dart)
```dart
Diskon? _getActiveDiscount(int menuId) {
  final menuDiskon = _menuDiskons.where((md) => md.idMenu == menuId).firstOrNull;
  if (menuDiskon == null) return null;
  
  final diskon = _diskons.where((d) => d.id == menuDiskon.idDiskon).firstOrNull;
  if (diskon == null || !diskon.isActive) return null;
  
  return diskon;
}

// Calculate discounted price
final hasDiscount = diskon != null;
final discountedPrice = hasDiscount 
    ? menu.harga * (1 - diskon.persentaseDiskon / 100)
    : menu.harga;
```

### 7. Bottom Navigation (pages/siswa/home_page.dart)
```dart
BottomNavigationBar(
  currentIndex: _selectedIndex,
  onTap: _onItemTapped,
  type: BottomNavigationBarType.fixed,
  selectedItemColor: AppColors.primaryRed,
  unselectedItemColor: AppColors.gray,
  items: const [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Pesanan'),
    BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
  ],
)
```

### 8. Status Update Logic (pages/admin/orders_page.dart)
```dart
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
```

### 9. Status Chip Widget
```dart
Container(
  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  decoration: BoxDecoration(
    color: _getStatusColor(order.status),
    borderRadius: BorderRadius.circular(20),
  ),
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(_getStatusIcon(order.status), size: 16, color: AppColors.white),
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
)
```

### 10. CRUD Dialog Pattern (pages/admin/manage_menu_page.dart)
```dart
void _showMenuDialog({Menu? menu}) {
  final isEdit = menu != null;
  final namaController = TextEditingController(text: menu?.namaMakanan);
  final hargaController = TextEditingController(text: menu?.harga.toString());
  
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(isEdit ? 'Edit Menu' : 'Tambah Menu'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(controller: namaController, /* ... */),
            TextField(controller: hargaController, /* ... */),
            // More fields...
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
            // Save logic
            setState(() { /* Update data */ });
            Navigator.of(context).pop();
          },
          child: Text(isEdit ? 'Update' : 'Tambah'),
        ),
      ],
    ),
  );
}
```

### 11. Cart Badge Counter
```dart
Stack(
  children: [
    IconButton(
      icon: const Icon(Icons.shopping_cart),
      onPressed: () { /* Navigate to cart */ },
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
          child: Text(
            '$_cartItemCount',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
  ],
)
```

### 12. Month Filter Dropdown
```dart
DropdownButtonFormField<String>(
  value: _selectedMonth,
  decoration: InputDecoration(
    labelText: 'Filter Bulan',
    prefixIcon: Icon(Icons.calendar_today, color: AppColors.primaryRed),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
  ),
  items: _availableMonths.map((month) {
    return DropdownMenuItem(value: month, child: Text(month));
  }).toList(),
  onChanged: (value) {
    if (value != null) {
      setState(() { _selectedMonth = value; });
    }
  },
)
```

### 13. Progress Indicator (Order Status)
```dart
Row(
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
        child: Icon(_getStatusIcon(steps[stepIndex]), size: 16, color: AppColors.white),
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
)
```

### 14. Currency Formatting
```dart
final currencyFormat = NumberFormat.currency(
  locale: 'id_ID', 
  symbol: 'Rp ', 
  decimalDigits: 0
);

// Usage:
Text(currencyFormat.format(menu.harga))
// Output: Rp 15.000
```

### 15. Date Formatting
```dart
final dateFormat = DateFormat('dd MMM yyyy, HH:mm');
final monthFormat = DateFormat('MMMM yyyy');

// Usage:
Text(dateFormat.format(DateTime.now()))
// Output: 08 Feb 2026, 19:16
```

### 16. Card with Rounded Corners
```dart
Card(
  margin: const EdgeInsets.only(bottom: 16),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
  elevation: 2,
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: // Content
  ),
)
```

### 17. Custom Theme (main.dart)
```dart
ThemeData(
  primaryColor: AppColors.primaryRed,
  scaffoldBackgroundColor: AppColors.background,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primaryRed,
    primary: AppColors.primaryRed,
    secondary: AppColors.darkRed,
  ),
  useMaterial3: true,
  cardTheme: CardTheme(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryRed,
      foregroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  ),
)
```

### 18. Gradient Background
```dart
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [AppColors.primaryRed, AppColors.darkRed],
    ),
    borderRadius: BorderRadius.circular(12),
  ),
  child: // Content
)
```

### 19. Search Bar
```dart
TextField(
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
)
```

### 20. Simple Bar Chart
```dart
Row(
  children: [
    SizedBox(width: 50, child: Text(label)),
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
    SizedBox(width: 70, child: Text(value)),
  ],
)
```

## Mock Data Examples

### Mock Stan Data
```dart
final List<Stan> _stans = [
  Stan(id: 1, namaStan: 'Stan Makanan Bu Ani', namaPemilik: 'Bu Ani', 
       telp: '08123456789', idUser: 2),
  Stan(id: 2, namaStan: 'Stan Minuman Pak Budi', namaPemilik: 'Pak Budi', 
       telp: '08234567890', idUser: 3),
];
```

### Mock Menu Data with Discounts
```dart
_allMenus = [
  Menu(id: 1, namaMakanan: 'Nasi Goreng', harga: 15000, 
       jenis: JenisMenu.makanan, deskripsi: 'Nasi goreng spesial', idStan: 1),
];

_diskons = [
  Diskon(id: 1, namaDiskon: 'Diskon 20%', persentaseDiskon: 20,
         tanggalAwal: DateTime.now().subtract(Duration(days: 5)),
         tanggalAkhir: DateTime.now().add(Duration(days: 10))),
];

_menuDiskons = [
  MenuDiskon(id: 1, idMenu: 1, idDiskon: 1), // Link menu to discount
];
```

## Best Practices Used

1. **Consistent Naming**: All files use snake_case for filenames
2. **Clear Structure**: Organized by feature (auth, siswa, admin)
3. **Reusable Components**: Card widgets, dialogs, etc.
4. **Type Safety**: Strong typing with enums and models
5. **Error Handling**: Form validation throughout
6. **User Feedback**: SnackBars for confirmations
7. **Responsive Design**: Flexible layouts with Expanded/Flexible
8. **Material Design**: Following Material 3 guidelines
9. **Mock Data**: Comprehensive examples for all features
10. **Documentation**: Comments where needed

## Testing Notes

To test the app:
1. Login as "admin" - see admin dashboard
2. Login as anything else - see student home
3. Navigate through all pages using bottom nav (student) or menu cards (admin)
4. Test CRUD operations in admin pages
5. Test ordering flow in student pages
6. Verify status changes work correctly
7. Check all filters and dropdowns
