# Kantin Sekolah - Flutter App

A complete Flutter frontend application for a school canteen food ordering system.

## Features

### Student (Siswa) Features:
1. ✅ Register as pelanggan/customer
2. ✅ Login to ordering page
3. ✅ View menu makanan & minuman from stan list
4. ✅ Order food with discount display (percentage off)
5. ✅ View order status (belum dikonfirm → dimasak → diantar → sampai)
6. ✅ View transaction history filtered by month dropdown
7. ✅ Print/view receipt (nota pemesanan)

### Admin Stan Features:
1. ✅ Register stan as admin
2. ✅ Login to management dashboard
3. ✅ Update stan profile
4. ✅ CRUD pelanggan/customer data
5. ✅ CRUD menu makanan & minuman
6. ✅ Confirm orders and change status
7. ✅ View orders filtered by month
8. ✅ View monthly income report (rekap pemasukan)

## Project Structure

```
lib/
├── main.dart
├── utils/
│   └── app_colors.dart
├── models/
│   ├── user.dart
│   ├── siswa.dart
│   ├── stan.dart
│   ├── menu.dart
│   ├── transaksi.dart
│   └── diskon.dart
├── pages/
│   ├── auth/
│   │   ├── login_page.dart
│   │   └── register_page.dart
│   ├── siswa/
│   │   ├── home_page.dart
│   │   ├── stan_detail_page.dart
│   │   ├── cart_page.dart
│   │   ├── order_status_page.dart
│   │   ├── history_page.dart
│   │   └── receipt_page.dart
│   └── admin/
│       ├── admin_home_page.dart
│       ├── manage_menu_page.dart
│       ├── manage_pelanggan_page.dart
│       ├── orders_page.dart
│       └── income_report_page.dart
```

## Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK

### Installation

1. Clone the repository:
```bash
git clone https://github.com/EzraPatrikha123/buat_ukk.git
cd buat_ukk
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Login Credentials

### Admin Login:
- Username: `admin`
- Password: any password

### Student Login:
- Username: anything except `admin`
- Password: any password

## Color Palette

- White: `#FFFFFF`
- Primary Red: `#E53935`
- Gray: `#808080`
- Dark Red: `#B71C1C`
- Background: `#F5F5F5`

## Technologies Used

- Flutter
- Material Design
- Dart
- intl package (for date and currency formatting)

## Notes

- This app uses mock/dummy data (no backend integration)
- All data is stored in local state
- Perfect for demonstration and UKK (Uji Kompetensi Keahlian) purposes