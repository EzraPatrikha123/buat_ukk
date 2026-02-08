# Kantin Sekolah - Application Flow

## Navigation Flow Diagram

```
┌─────────────────────────────────────────────────────────────────────────┐
│                           KANTIN SEKOLAH APP                             │
└─────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
                            ┌───────────────┐
                            │  Login Page   │
                            │  (main.dart)  │
                            └───────┬───────┘
                                    │
                    ┌───────────────┴───────────────┐
                    │                               │
            username == "admin"              username != "admin"
                    │                               │
                    ▼                               ▼
        ┌───────────────────────┐       ┌──────────────────────┐
        │  ADMIN FLOW           │       │  STUDENT FLOW        │
        └───────────────────────┘       └──────────────────────┘
                    │                               │
                    ▼                               ▼
        ┌───────────────────────┐       ┌──────────────────────┐
        │ Admin Home Dashboard  │       │  Siswa Home Page     │
        │  - Welcome Card       │       │  - Stan List         │
        │  - 4 Menu Grid        │       │  - Search Bar        │
        │  - Quick Stats        │       │  - Bottom Nav        │
        └───────┬───────────────┘       └──────┬───────────────┘
                │                               │
     ┌──────────┼──────────┬──────────┐       │
     │          │          │          │       │
     ▼          ▼          ▼          ▼       ▼
┌─────────┐ ┌──────┐ ┌──────────┐ ┌────────┐
│ Kelola  │ │ Data │ │ Pesanan  │ │Laporan │
│  Menu   │ │ Pel. │ │          │ │        │
└─────────┘ └──────┘ └──────────┘ └────────┘

Student Navigation:
                    ┌──────────────────────┐
                    │  Bottom Navigation   │
                    └──────────────────────┘
                              │
         ┌────────────────────┼────────────────────┬─────────────┐
         │                    │                    │             │
         ▼                    ▼                    ▼             ▼
    ┌────────┐         ┌───────────┐        ┌──────────┐   ┌─────────┐
    │  Home  │         │  Pesanan  │        │ Riwayat  │   │ Profil  │
    │        │         │  (Status) │        │ (History)│   │         │
    └───┬────┘         └───────────┘        └────┬─────┘   └─────────┘
        │                                         │
        ▼                                         │
┌──────────────┐                                  │
│ Stan Detail  │                                  │
│  - Menu Grid │                                  │
│  - Filters   │                                  │
└───┬──────────┘                                  │
    │                                             │
    ▼                                             │
┌──────────┐                                      │
│   Cart   │                                      │
│  - Items │                                      │
│  - Total │                                      │
└──┬───────┘                                      │
   │ Checkout                                     │
   │                                              │
   └──────────────────┬───────────────────────────┘
                      │
                      ▼
               ┌─────────────┐
               │   Receipt   │
               │  (Nota)     │
               └─────────────┘
```

## Screen Descriptions

### Authentication Screens
1. **Login Page**
   - Username field
   - Password field (with show/hide toggle)
   - Login button
   - Register link

2. **Register Page**
   - Role selection (Radio buttons: Siswa / Admin Stan)
   - Username field
   - Name field (Nama Siswa / Nama Pemilik)
   - Additional fields based on role:
     * Siswa: Alamat, Telp
     * Admin: Nama Stan, Telp
   - Password fields (with confirmation)
   - Register button

### Student Screens

3. **Siswa Home Page**
   - AppBar with notifications and profile icons
   - Search bar
   - Scrollable stan cards:
     * Banner image placeholder
     * Stan name
     * Owner name with icon
     * Phone number with icon
   - Bottom navigation (4 tabs)

4. **Stan Detail Page**
   - Expandable AppBar with banner
   - Cart icon with badge
   - Category filter chips (Semua/Makanan/Minuman)
   - Menu grid (2 columns):
     * Menu image placeholder
     * Discount badge (if applicable)
     * Menu name
     * Original price (strikethrough if discounted)
     * Discounted price
     * "Tambah" button

5. **Cart Page**
   - Item cards:
     * Image placeholder
     * Menu name
     * Discount badge
     * Price
     * Quantity controls (+/-)
   - Bottom section:
     * Total amount
     * Checkout button

6. **Order Status Page**
   - Active orders list
   - Order cards:
     * Order number
     * Date/time
     * Status chip with color
     * Item list
     * Total
     * Progress indicator (4 stages)

7. **History Page**
   - Month dropdown filter
   - Transaction cards:
     * Order number
     * Date/time
     * "Selesai" status badge
     * Item list
     * Total
     * "Lihat Nota" button

8. **Receipt Page**
   - Header with logo
   - Order information
   - Item breakdown
   - Total
   - Print button

### Admin Screens

9. **Admin Home Dashboard**
   - Welcome card with gradient
   - 4 menu cards in grid:
     * Kelola Menu (orange)
     * Data Pelanggan (blue)
     * Pesanan (green)
     * Laporan (purple)
   - Quick statistics card

10. **Manage Menu Page**
    - Menu list with cards
    - Each card shows:
      * Menu icon
      * Name
      * Description
      * Price
      * Edit button
      * Delete button
    - Floating action button (Add Menu)
    - Add/Edit dialog with form

11. **Manage Pelanggan Page**
    - Customer list with cards
    - Each card shows:
      * Avatar with initial
      * Name
      * Address
      * Phone
      * Edit button
      * Delete button
    - Floating action button (Add Pelanggan)
    - Add/Edit dialog with form

12. **Orders Page**
    - Month dropdown filter
    - Order cards:
      * Order number
      * Date/time
      * Status chip
      * Item list
      * Total
      * Action button (Konfirmasi/Antar/Selesai)

13. **Income Report Page**
    - Month selector dropdown
    - Summary cards:
      * Total income
      * Total orders
    - Bar chart visualization
    - Daily breakdown list

## Color Usage

### Status Colors
- **Belum Dikonfirm**: Orange
- **Dimasak**: Blue
- **Diantar**: Purple
- **Sampai**: Green

### UI Colors
- **Primary Actions**: Primary Red (#E53935)
- **Text**: Dark (default)
- **Secondary Text**: Gray (#808080)
- **Background**: Light Gray (#F5F5F5)
- **Cards**: White (#FFFFFF)
- **Discount Badges**: Orange

## Icon Usage

### Student App Icons
- Home: `Icons.storefront`, `Icons.store`, `Icons.restaurant`
- Orders: `Icons.receipt_long`, `Icons.shopping_cart`
- History: `Icons.history`
- Profile: `Icons.person`
- Search: `Icons.search`
- Notifications: `Icons.notifications`
- Food: `Icons.fastfood`
- Drinks: `Icons.local_drink`

### Admin App Icons
- Menu Management: `Icons.restaurant_menu`
- Customers: `Icons.people`
- Orders: `Icons.receipt_long`
- Reports: `Icons.assessment`
- Add: `Icons.add`
- Edit: `Icons.edit`
- Delete: `Icons.delete`
- Calendar: `Icons.calendar_today`
- Money: `Icons.attach_money`

## Data Flow

### Order Creation Flow
```
1. Student browses stan → 
2. Views menu items → 
3. Adds items to cart → 
4. Reviews cart → 
5. Checkout → 
6. Order created (status: belum_dikonfirm)
```

### Order Processing Flow
```
1. Admin views new order →
2. Confirms order (status: dimasak) →
3. Marks as delivered (status: diantar) →
4. Marks as completed (status: sampai) →
5. Order appears in student's history
```

### Discount Application Flow
```
1. Menu has linked discount →
2. Check if discount is active (date range) →
3. Display discount badge →
4. Calculate discounted price →
5. Show original price (strikethrough) →
6. Show discounted price
```

## State Management

All data is managed through:
- Local state using `setState()`
- Mock data initialized in `initState()`
- Data passed between screens via constructor parameters
- No external state management library needed (for simplicity)

## Responsive Design

- Uses Material Design 3
- Flexible layouts with `Expanded`, `Flexible`
- ScrollView for long content
- GridView for menu items
- ListView for lists
- Cards for content grouping
- Proper padding and margins throughout
