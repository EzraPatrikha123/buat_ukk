# Kantin Sekolah - Flutter App

A complete Flutter frontend application for a school canteen food ordering system with real API integration.

## API Integration

This app connects to the real school API:
- **Base URL:** `https://ukk-p2.smktelkom-mlg.sch.id/api/`
- **Documentation:** https://documenter.getpostman.com/view/31319845/2sAYQZGrs6

## Features

### Student (Siswa) Features:
1. ✅ Register as pelanggan/customer via API
2. ✅ Login to ordering page with token authentication
3. ✅ View menu makanan & minuman from stan list (API data)
4. ✅ Order food with discount display
5. ✅ View order status (belum dikonfirm → dimasak → diantar → sampai)
6. ✅ View transaction history filtered by month dropdown (API data)
7. ✅ Print/view receipt (nota pemesanan)

### Admin Stan Features:
1. ✅ Register stan as admin via API
2. ✅ Login to management dashboard with token authentication
3. ✅ CRUD menu makanan & minuman via API
4. ✅ View pelanggan/customer data from API
5. ✅ Confirm orders and change status via API
6. ✅ View orders filtered by month (API data)
7. ✅ View monthly income report (rekap pemasukan)

## Project Structure

```
lib/
├── main.dart
├── utils/
│   └── app_colors.dart
├── services/
│   └── api_service.dart          # HTTP client for API calls
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
- Internet connection (for API calls)

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

### Admin Login (for testing):
- Username: `kantinstand`
- Password: `kantin1`

### Student Login (for testing):
- Username: `ezrapatrikha`
- Password: `ezra1`

## Color Palette

- White: `#FFFFFF`
- Primary Red: `#E53935`
- Gray: `#808080`
- Dark Red: `#B71C1C`
- Background: `#F5F5F5`
- Black: `#212121`

## Technologies Used

- Flutter
- Material Design
- Dart
- http package (^1.1.0) - for API calls
- shared_preferences package (^2.2.2) - for token storage
- intl package (^0.18.1) - for date and currency formatting

## Features Implementation

### Authentication
- JWT token-based authentication
- Token stored in SharedPreferences
- Auto-login based on stored token and user role
- Logout clears token from storage

### API Integration
All data operations go through the ApiService class:
- Auth endpoints (login, register, logout)
- Stan endpoints (get all, get by ID)
- Menu endpoints (get by stan, CRUD operations)
- Transaksi endpoints (create, get by siswa/stan, update status)
- Pelanggan endpoints (get all customers)
- Diskon endpoints (get active discounts)

### Error Handling
- Try-catch blocks for all API calls
- User-friendly error messages
- Loading indicators during API operations
- HTTP status code validation