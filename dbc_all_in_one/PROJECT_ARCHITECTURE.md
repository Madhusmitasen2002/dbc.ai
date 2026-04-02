# DBC All-In-One Flutter Project - Complete Architecture & Analysis

## 🎯 PROJECT OVERVIEW

**Project Name**: dbc_all_in_one  
**Purpose**: Comprehensive business management system for SMEs/Startups  
**Platform**: Cross-platform (Android, iOS, Windows, Linux, Web)  
**Backend**: Supabase (PostgreSQL)  
**Language**: Dart/Flutter

---
 
## 📊 SYSTEM ARCHITECTURE

### Architecture Pattern
```
┌─────────────────────────────────────────────────────┐
│                   PRESENTATION LAYER                 │
│  (UI Screens, Widgets, State Management)            │
├─────────────────────────────────────────────────────┤
│                   SERVICES LAYER                     │
│  (Business Logic, API Calls, Data Processing)       │
├─────────────────────────────────────────────────────┤
│                 SUPABASE SERVICE LAYER               │
│  (Database, Auth, Real-time Subscriptions)          │
├─────────────────────────────────────────────────────┤
│                   EXTERNAL APIs                      │
│  (Camera, Image Picker, QR Scanner, PDF)            │
└─────────────────────────────────────────────────────┘
```

### Technology Stack

**Core Framework**
- Flutter 3.6.0+
- Dart 3.6.0+
- Material Design 3

**UI & Responsive Design**
- sizer (2.0.15) - Responsive sizing system
- flutter_svg (2.0.9) - SVG icon support
- google_fonts (6.1.0) - Typography
- cached_network_image (3.3.1) - Image caching

**Backend & Data**
- supabase_flutter - Backend services
- shared_preferences (2.2.2) - Local storage
- dio (5.4.0) - HTTP client

**Feature Packages**
- camera (0.10.5+5) - Live camera access
- image_picker (1.0.4) - Image selection
- permission_handler (11.1.0) - Permission management
- mobile_scanner (6.0.11) - QR code scanning
- pdf (3.11.3) - PDF generation
- share_plus (12.0.1) - File sharing
- video_player (2.10.0) - Video playback
- fl_chart (0.65.0) - Charts & graphs
- table_calendar (3.0.9) - Calendar widget
- intl (0.19.0) - Internationalization

---

## 🎨 DESIGN SYSTEM

### Color Palette

**Light Theme**
- Primary: #6B46C1 (Deep Purple)
- Secondary: #0EA5E9 (Bright Cyan)
- Success: #10B981 (Green)
- Warning: #F59E0B (Amber)
- Error: #EF4444 (Red)
- Background: #F8FAFC (Subtle Gray)
- Surface: #FFFFFF (White)
- Text Primary: #1E293B (Dark Slate)
- Text Secondary: #64748B (Medium Gray)

**Dark Theme**
- Primary: #8B7DD8 (Lighter Purple)
- Secondary: #38BDF8 (Lighter Cyan)
- Background: #0F172A (Very Dark Slate)
- Surface: #1E293B (Dark Slate)

### Responsive Breakpoints
Using Sizer package:
- 50.w = 50% of screen width
- 20.h = 20% of screen height
- 4.w = 4% of screen width horizontal padding

---

## 📱 SCREENS & PAGES (22 Total)

### 1. **SPLASH SCREEN** (`/splash-screen`)
**Purpose**: Initial loading screen displayed on app launch  
**Components**:
- Logo/Brand animation
- Initial data loading
- Navigation to Business Dashboard

**Key Functions**:
- Initialize app configuration
- Check Supabase connectivity
- Auto-navigate after splash timeout

---

### 2. **BUSINESS DASHBOARD** (`/business-dashboard`)
**Purpose**: Main hub with 6 tabbed sections for different business functions  
**Route Path**: `/` (initial) and multi-index navigation

**Dashboard Tabs (6 Total)**:

#### Tab 0: **Home Tab**
- Welcome message with business name
- Primary metrics display:
  - Total Payments: $2,450.00 (+12.5%)
  - Active Orders: 24 orders (+8 today)
- Quick action cards linking to other modules
- Staff alerts notification overlay
- Security events feed

#### Tab 1: **Live Camera View**
- Real-time CCTV/Security camera feed
- Multi-camera support
- Recording controls
- Security footage playback

#### Tab 2: **Inventory Management**
- Stock level monitoring
- Product listings with low stock alerts
- Inventory adjustment forms
- Historical tracking

#### Tab 3: **Staff Management**
- Employee roster display
- Attendance tracking (present/absent/late)
- Shift management
- Performance metrics

#### Tab 4: **Payment Processing Center**
- Transaction history
- Multiple payment gateway integration
- Invoice generation
- Payment reconciliation
- Charts for payment trends

#### Tab 5: **Order Management Hub**
- Customer orders tracking
- Sales orders management
- Order status workflow
- Buyer/Seller perspective toggles

**Key Features**:
- Bottom navigation bar with 6 main items
- Real-time alerts for staff and security
- Notification system
- Help floating button on each tab

**Key Functions**:
```
- initState() / loadDashboardData()
- _loadStaffAlerts()
- _showSecurityAlert()
- _showStaffNotification()
- _navigateToTab()
- onBottomNavTap()
```

---

### 3. **ORDER MANAGEMENT HUB** (`/order-management-hub`)
**Purpose**: Track and manage customer orders & sales  
**Tab Structure**: 2 tabs - "My Orders" | "My Sales"

**Current Features**:
- Order list with status filtering
- Status filter chips (all, pending, confirmed, shipped, delivered, cancelled)
- Order details modal
- Pull-to-refresh functionality
- Marketplace service integration

**Key Functions**:
- `_loadOrders()` - Fetch orders from MarketplaceService
- `_showOrderDetails()` - Display detailed order information
- `_loadMyOrders()` / `_loadMySales()` - Tab-specific data loading
- Status update with API call
- Real-time order status updates

---

### 4. **PAYMENT PROCESSING CENTER** (`/payment-processing-center`)
**Purpose**: Handle all monetary transactions and payment operations  
**Features**:
- Transaction list with filtering
- Payment status tracking (completed, pending, failed)
- Invoice generation and export
- Payment method selection
- Date range filtering
- Charts for payment analytics

**Key Functions**:
- `_buildTransactionList()` - Display transaction records
- `_generateInvoice()` - Create invoice PDFs
- `_initiateCashTransaction()` / `_initiateCardTransaction()`
- Reconciliation checks

---

### 5. **INVENTORY MANAGEMENT** (`/inventory-management`)
**Purpose**: Track stock levels, product information, and warehouse management  
**Features**:
- Categorized product listing
- Stock level indicators
- Low stock alerts
- Product counts
- Search and filtering
- Warehouse location tracking

**Key Functions**:
- `_loadInventory()` - Fetch products
- `_updateStockLevel()`
- `_alertLowStock()`
- Search/filter operations

---

### 6. **LIVE CAMERA VIEW** (`/live-camera-view`)
**Purpose**: Real-time security monitoring through CCTV/IP cameras  
**Features**:
- Multi-camera display
- Live feed streaming
- Recording controls
- Camera switching
- Instant snapshot capture
- 24/7 monitoring

**Key Functions**:
- Camera initialization
- Feed streaming management
- Screenshot/recording triggers

---

### 7. **STAFF MANAGEMENT** (`/staff-management`)
**Purpose**: Employee management, attendance, and HR operations  
**Tab Structure**: Multiple tabs for Hiring, Active Staff, Payroll

**Features**:
- Employee roster with avatars
- Status indicators (In Office, Remote, On Leave)
- Hours worked display
- Performance ratings
- Hiring tab with job postings
- Interview status tracking

**Key Functions**:
- `_loadStaffData()`
- `_markAttendance()`
- `_updateEmployeeStatus()`
- Hiring workflow management

**Staff Alert Types**:
- Absent staff alerts (Red)
- Late arrivals (Amber)
- Overtime tracking (Purple)
- New job applications (Teal)

---

### 8. **VENDOR MARKETPLACE** (`/vendor-marketplace`)
**Purpose**: B2B supplier discovery and procurement platform  
**Tab Structure**: Suppliers | Marketplace | Orders

**Features**:
- Supplier listings with ratings
- Product categories
- Search and filtering
- Supplier details modal
- Direct ordering capability
- Supplier ratings and reviews

**Key Functions**:
- `_loadSuppliers()`
- `_searchSuppliers()`
- `_initiateOrder()`
- Supplier rating system

---

### 9. **PAYROLL PROCESSING** (`/payroll-processing`)
**Purpose**: Salary calculation, payment processing, and payroll reports  
**Features**:
- Payroll period selection (daily/weekly/bi-weekly/monthly)
- Employee salary breakdown
- Deductions tracking
- Tax calculations
- PDF payroll report generation
- Payroll summary cards
- Search and filtering

**Key Functions**:
- `_calculatePayroll()`
- `_generatePayrollReport()` - PDF export
- `_sharePayrollReport()`
- Payroll approval workflow

---

### 10. **GST FILING CENTER** (`/gst-filing-center`)
**Purpose**: GST return management and compliance tracking  
**Features**:
- GST return status (monthly/quarterly/annual)
- Filing deadline tracking
- Return filing forms
- Compliance checklist
- Due date notifications
- Historical filing records

**Key Functions**:
- `_loadGSTReturns()`
- `_submitGSTReturn()`
- Deadline calculation
- Compliance validation

---

### 11. **GST REPORTS** (`/gst-reports`)
**Purpose**: Generate detailed GST analytics and compliance reports  
**Features**:
- Tax summary reports
- GSTR-1 (outward supplies)
- GSTR-2 (inward supplies)
- GSTR-3B (ITC and tax liability)
- PDF report generation
- Data export functionality

**Key Functions**:
- `_generateGSTReport()`
- `_filterByDateRange()`
- Report visualization with charts

---

### 12. **INVOICE MANAGEMENT CENTER** (`/invoice-management-center`)
**Purpose**: Invoice creation, tracking, and payment status management  
**Features**:
- Invoice list with timeline view
- Status filtering (sent, viewed, partially paid, paid, overdue)
- Date range filtering
- Search by invoice number
- Invoice PDF generation
- Payment status updates
- Customer communication

**Key Functions**:
- `_loadInvoices()`
- `_createInvoice()`
- `_updatePaymentStatus()`
- `_generateInvoicePDF()`

**Key Widgets**:
- DateRangeSelectorWidget
- InvoiceTimelineCardWidget
- PaymentStatusFilterChipWidget

---

### 13. **HIRING MARKETPLACE** (`/hiring-marketplace`)
**Purpose**: Recruitment platform for hiring new employees  
**Tab Structure**: Job Postings | Candidates | Interviews

**Features**:
- Job posting creation/management
- Candidate database
- Resume/CV upload
- Interview scheduling
- Status tracking (applied/shortlisted/selected/rejected)
- Candidate rating system

**Key Functions**:
- `_postJobOpening()`
- `_searchCandidates()`
- `_scheduleInterview()`
- Application status updates

---

### 14. **STAFF HIRING SCREEN** (`/staff-hiring`)
**Purpose**: Streamlined employee hiring workflow  
**Features**:
- Job application form
- Candidate information collection
- Document upload
- Interview scheduling
- Offer letter generation

---

### 15. **APP WORKFLOW OVERVIEW** (`/app-workflow-overview`)
**Purpose**: Visual map of all app modules and their connections  
**Features**:
- Module visualization with color-coded sections
- Connection lines showing data flow
- Route navigation from overview
- Search/filter by module
- Module descriptions

**Module Groups**:
- Finance (GST Filings, Payments, Invoicing)
- Inventory & Sales
- HR & Payroll
- Marketplace

**Key Functions**:
- `_filterModules()`
- `_navigateToScreen()`
- Workflow visualization

---

### 16. **VENDOR PRODUCT MANAGEMENT** (`/vendor-product-management`)
**Purpose**: For vendors to manage product listings  
**Features**:
- Product listing management
- Stock quantity updates
- Status management (active/inactive)
- Add/Edit/Delete product dialogs
- Vendor statistics display

**Key Functions**:
- `_loadVendorData()`
- `_addListing()`
- `_updateListing()`
- `_deleteListing()`

---

### 17. **MARKETPLACE PRODUCT CATALOG** (`/marketplace-product-catalog`)
**Purpose**: Browse and manage marketplace products  
**Features**:
- Product catalog display
- Sorting and filtering
- Product details modal
- Add to cart functionality
- Wishlist management

---

### 18. **NEWS UPDATES HUB** (`/news-updates-hub`)
**Purpose**: Business news, alerts, and system notifications feed  
**Features**:
- News feed display
- Category filtering
- Search functionality
- News detail view
- Bookmark/save articles

---

### 19. **SECURITY ALERTS DASHBOARD** (`/security-alerts-dashboard`)
**Purpose**: Overall security event monitoring and alerts  
**Features**:
- Security event timeline
- Alert severity indicators
- Incident logging
- Response tracking
- Event history

**Key Functions**:
- `_loadSecurityEvents()`
- `_createSecurityLog()`

---

### 20. **SECURITY EVENTS HISTORY** (`/security-events-history`)
**Purpose**: Historical log of all security incidents  
**Features**:
- Event timeline/list view
- Filtering by type/severity
- Date range searching
- Event details modal
- Export functionality

---

### 21. **DATA MIGRATION CENTER** (`/data-migration-center`)
**Purpose**: Data import/export and system migrations  
**Features**:
- File upload/download
- Data mapping interface
- Batch operations
- Progress tracking
- Error reporting

---

### 22. **GLOBAL SEARCH CENTER** (`/global-search-center`)
**Purpose**: Unified search across all app modules  
**Features**:
- Search bar with auto-complete
- Results from multiple modules
- Filtered search results
- Quick navigation to results
- Search history

**Key Functions**:
- `_searchAll()`
- Cross-module query execution

---

## 🔧 SERVICES LAYER (12 Services)

### 1. **MarketplaceService**
**Purpose**: Handle marketplace operations and vendor/product data  
**Key Methods**:
```
- getAllProducts(category, searchQuery, condition, sortBy)
- getProductDetails(id)
- getVendors()
- getMyOrders(status)
- getMySales(status)
- updateOrderStatus(orderId, newStatus)
- createOrder(productId, quantity)
- getVendorListings()
- addListing(productData)
- updateListing(id, data)
- deleteListing(id)
```

### 2. **InvoicingService**
**Purpose**: Invoice management and generation  
**Key Methods**:
```
- getInvoices(status, dateRange)
- createInvoice(invoiceData)
- updateInvoiceStatus(invoiceId, status)
- generateInvoicePDF(invoiceId)
- sendInvoiceByEmail(invoiceId)
```

### 3. **SupabaseService**
**Purpose**: Core backend connection and database operations  
**Key Methods**:
```
- get client() - Returns Supabase client
- initialize() - Setup Supabase connection
```

### 4. **GSTService**
**Purpose**: GST filing and reporting  
**Key Methods**:
```
- getGSTReturns()
- submitGSTReturn(returnData)
- generateGSTReport(reportType, dateRange)
- getFilingDeadlines()
```

### 5. **SecurityAlertsService**
**Purpose**: Security event logging and alerts  
**Key Methods**:
```
- getSecurityEvents()
- logSecurityEvent(details)
- getActiveAlerts()
```

### 6. **NotificationService**
**Purpose**: Push notifications and in-app alerts  
**Key Methods**:
```
- sendNotification(title, body)
- scheduleNotification(time, data)
- getNotificationHistory()
```

### 7. **HiringService**
**Purpose**: Recruitment and hiring operations  
**Key Methods**:
```
- postJobOpening(jobData)
- getApplications()
- updateApplicationStatus(appId, status)
- scheduleInterview(candidateId, time)
```

### 8. **SessionManager**
**Purpose**: User session and authentication management  
**Key Methods**:
```
- getCurrentUser()
- logout()
- isUserAuthenticated()
```

### 9. **HelpService**
**Purpose**: Contextual help and tutorials  
**Key Methods**:
```
- getScreenHelp(routeName)
- getTutorial(feature)
```

### 10. **GlobalSearchService**
**Purpose**: Cross-module unified search  
**Key Methods**:
```
- searchAll(query)
- searchByModule(query, module)
```

### 11. **DataMigrationService**
**Purpose**: Data import/export operations  
**Key Methods**:
```
- exportData(format)
- importData(file)
- mapFieldsForImport(data)
```

### 12. **AppNotifications**
**Purpose**: Local and remote notification management  
**Key Methods**:
```
- initialize()
- handleNotification()
```

---

## 🧩 CORE WIDGETS (7 Shared Components)

### 1. **CustomBottomBar**
- Bottom navigation with 5-6 items
- Active/inactive icon switching
- Tab navigation handler

### 2. **CustomAppBar**
- Configurable header with title
- Back button support
- Action buttons

### 3. **CustomIconWidget**
- Centralized icon rendering
- Size and color customization
- SVG and Material Icons support

### 4. **CustomImageWidget**
- Network image caching
- Fallback handling
- Loading states

### 5. **HelpFloatingButton**
- Contextual help trigger
- Route-aware help content
- Modal bottom sheet for help

### 6. **CustomErrorWidget**
- Error message display
- Retry functionality
- Icon and text customization

### 7. **ContextualTooltipWidget**
- Hover tooltip support
- Position-aware display
- Custom styling

---

## 🛣️ ROUTING SYSTEM

**Route Pattern**: Named route navigation using `AppRoutes` class

**Main Routes**:
```
'/'                           → SplashScreen
'/business-dashboard'         → BusinessDashboard (Tab 0)
'/live-camera-view'           → BusinessDashboard (Tab 1)
'/inventory-management'       → BusinessDashboard (Tab 2)
'/staff-management'           → BusinessDashboard (Tab 3)
'/payment-processing-center'  → BusinessDashboard (Tab 4)
'/order-management-hub'       → BusinessDashboard (Tab 5)
'/vendor-marketplace'         → VendorMarketplace
'/hiring-marketplace'         → HiringMarketplace
'/gst-filing-center'          → GSTFilingCenter
'/gst-reports'                → GSTReportsScreen
'/payroll-processing'         → PayrollProcessing
'/invoice-management-center'  → InvoiceManagementCenter
'/app-workflow-overview'      → AppWorkflowOverview
'/global-search-center'       → GlobalSearchCenter
'/data-migration-center'      → DataMigrationCenter
```

**Navigation Methods**:
```dart
// Named route navigation
Navigator.pushNamed(context, '/order-management-hub');

// Multi-index dashboard navigation
Navigator.pushReplacement(
  context,
  MaterialPageRoute(child: BusinessDashboard(initialIndex: 5))
);

// Direct screen navigation
Navigator.push(context, MaterialPageRoute(child: OrderManagementHub()));
```

---

## 💾 DATA FLOW & STATE MANAGEMENT

### Data Flow Pattern
```
User Action (Button Tap, Scroll)
        ↓
Widget Event Handler (onTap, onRefresh)
        ↓
Service Method Call (MarketplaceService.getOrders())
        ↓
Supabase Query Execution
        ↓
setState() ← Update Local State
        ↓
Widget Rebuild (build() method)
```

### State Management Approach
- **Local State**: StatefulWidget with setState()
- **Session Data**: SessionManager service
- **Local Persistence**: SharedPreferences
- **Real-time Data**: Supabase subscriptions
- **Global Navigation**: GlobalKey<NavigatorState>

### Data Persistence
- **Local Storage**: SharedPreferences for user preferences, session tokens
- **Database**: Supabase PostgreSQL for all business data
- **Caching**: cached_network_image for image caching

---

## 🔐 SECURITY FEATURES

### Authentication
- Supabase authentication integration
- Session management via SessionManager
- Global navigator key for forced navigation (logout scenarios)

### Security Alerts
- Real-time security event logging
- Incident tracking and response
- Dashboard notifications

### Data Security
- All data transmitted over HTTPS
- Supabase row-level security policies
- User role-based access control

---

## 📊 KEY FEATURES SUMMARY

| Feature | Status | Module |
|---------|--------|--------|
| Real-time Inventory | ✅ | Inventory Mgmt |
| Order Tracking | ✅ | Order Hub |
| Payment Processing | ✅ | Payment Center |
| Invoice Generation | ✅ | Invoice Center |
| GST Filing | ✅ | GST Center |
| Payroll Management | ✅ | Payroll |
| Live CCTV Monitoring | ✅ | Live Camera |
| Staff Management | ✅ | Staff Mgmt |
| Recruitment | ✅ | Hiring |
| Marketplace | ✅ | Vendor Marketplace |
| PDF Export | ✅ | Payroll, Invoice |
| Mobile Scanner | ✅ | QR Code Features |
| Responsive Design | ✅ | All Screens |

---

## 🎯 KEY FUNCTIONS SUMMARY

### App Initialization
```
main() → initialize Supabase → Sizer wrapper → MaterialApp setup
```

### Navigation
```
AppRoutes.routes → Named route map → Widget builder factory
```

### Common Patterns
```
initState() → Load data via service → setState() → Rebuild UI
Pull-to-refresh → Service call → setState() → Update display
Modal dialog → User input → Service method → Update state
```

---

# ✅ ORDER MANAGEMENT HUB - Design Requirements

## 📋 Current Implementation Status
The OrderManagementHub is partially implemented with:
- Basic order list display
- 2 tabs: "My Orders" | "My Sales"
- Status filtering
- Order details modal
- MarketplaceService integration

---

## 🎨 ENHANCED UI/UX DESIGN REQUIREMENTS

### 1. **Layout Structure**
```
┌─────────────────────────────────────┐
│         Top App Bar                  │
│    "Order Management" + Settings     │
├─────────────────────────────────────┤
│  [All] [Pending] [Confirmed] ...    │  ← Status Chips
├─────────────────────────────────────┤
│  ┌─────────────────────────────────┐ │
│  │   Order Card 1                   │ │
│  │  #ORD-001 - $250.00             │ │
│  │  Status: Shipped [>]             │ │
│  └─────────────────────────────────┘ │
│                                      │
│  ┌─────────────────────────────────┐ │
│  │   Order Card 2                   │ │
│  │  #ORD-002 - $480.50             │ │
│  │  Status: Pending ⏳              │ │
│  └─────────────────────────────────┘ │
├─────────────────────────────────────┤
│  [⬇] Bottom Navigation Bar           │
└─────────────────────────────────────┘
```

### 2. **Order Card Display**
Each order card should show:
```
┌──────────────────────────────────┐
│ [Product Image] Order ID         │
│                 Amount: $XXX.XX   │
│                 Date: Nov 27, 2024│
│ Product Name                      │
│ Order Status [Badge]              │
│ Buyer/Seller Name                │
│ [Detail Button →]                │
└──────────────────────────────────┘
```

**Card Elements**:
- Product thumbnail (50x50 dp)
- Order ID with # prefix (e.g., #ORD-001234)
- Total amount in local currency
- Order date (relative or absolute)
- Product name (1-2 lines, truncated)
- Status badge with color coding:
  - Pending: Yellow/Amber
  - Confirmed: Blue
  - Shipped: Purple
  - Delivered: Green
  - Cancelled: Red
- User name (buyer or seller depending on tab)
- Tap target for details (entire card)

### 3. **Status Filter Chips** (Horizontal Scrollable)
- Chip styles:
  - Inactive: Light gray background, dark text
  - Active: Primary color (Purple #6B46C1) background, white text
- Chips: [All] [Pending] [Confirmed] [Shipped] [Delivered] [Cancelled]
- Smooth scroll behavior
- Active chip clearly highlighted

### 4. **Order Details Modal Sheet**
Height: 85% of screen  
Content sections:

#### Section A: Product Information
```
┌──────────────────────────┐
│ [Large Product Image]    │
│ Product Name             │
│ Category · Condition     │
└──────────────────────────┘
```

#### Section B: Order Summary
```
Order ID:        #ORD-001234
Order Date:      Nov 27, 2024
Quantity:        5 units
Unit Price:      $50.00
Total:           $250.00
```

#### Section C: Party Details (Buyer/Seller)
```
Name:            [Buyer/Seller Name]
Phone:           +91 XXXX XXX XXX
Address:         [Full Address]
Email:           user@example.com
Rating:          ⭐ 4.5 (120 reviews)
```

#### Section D: Status Timeline
```
┌─────────────────────────┐
│ ✓ Confirmed    Nov 27   │
│ ↳ Processing           │
│ → Shipped (5 dec)      │
│ → Delivered (Pending)  │
└─────────────────────────┘
```

#### Section E: Actions
- Button: "Add Note" (Open note input)
- Button: "Call Buyer/Seller"
- Status Update Dropdown (for sellers):
  - Change Status To: [Pending/Confirmed/Shipped/Delivered/Cancelled]
- Button: "Share Invoice" (PDF export)

### 5. **Tab Implementation**
Tabs at top:
- "My Orders" (Customer perspective - buyer)
- "My Sales" (Seller perspective - seller)

**Visual distinction**:
- Tab indicator on active tab
- Smooth transition animation
- Data reloads when switching tabs

### 6. **Empty State**
When no orders exist:
```
┌─────────────────────────┐
│     📦 No Orders        │
│                         │
│  No orders found for    │
│  this period            │
│                         │
│  [Browse Marketplace]   │
│  Button (link to        │
│   vendor marketplace)   │
└─────────────────────────┘
```

### 7. **Loading State**
- Circular progress indicator in center
- Shimmer loading skeleton for cards (optional)
- For pull-to-refresh: Material refresh indicator

### 8. **Error State**
```
⚠️ Failed to load orders

[Details of error]

[Retry] Button
```

### 9. **Search & Advanced Filtering**
Optional sections to add:
- Search bar: Search by Order ID, Product Name, Buyer/Seller Name
- Date range picker: From - To dates
- Amount filter: Min - Max price range
- Advanced filters button with modal

### 10. **Color Coding for Status**
```
Pending:    #F59E0B (Amber) - Attention needed
Confirmed:  #3B82F6 (Blue) - Acknowledged
Shipped:    #8B5CF6 (Purple) - In transit
Delivered:  #10B981 (Green) - Complete
Cancelled:  #EF4444 (Red) - Not proceeding
```

### 11. **Icons & Visual Elements**
- Order ID: Receipt icon (📋)
- Shipped status: Truck icon (🚚)
- Delivered status: Checkmark icon (✓)
- Pending status: Clock icon (⏳)
- Cancelled status: X icon (✗)
- User avatar: Initials or image
- Rating: Star icon (⭐)

### 12. **Responsiveness**
- **Mobile** (< 600 dp): Single column layout
- **Tablet** (> 600 dp): Two-column grid layout
- Card width: Use sizer (100% width on mobile, 48.w on tablet)

---

## 🔧 FUNCTIONAL REQUIREMENTS

### 1. **Data Loading**
- Load orders on screen init
- Separate endpoints for "My Orders" vs "My Sales"
- Filter by status parameter
- Pagination if > 50 orders (optional)

### 2. **User Interactions**
- Tap order card → Show details modal
- Swipe up modal → Expand/collapse sections
- Pull-to-refresh → Reload orders
- Status chip tap → Filter by status
- Detail modal: Status update dropdown changes (sellers only)
- Call button → Open phone dialer
- Share button → Generate & share invoice PDF

### 3. **Real-time Updates**
- Subscribe to order status changes (if backend supports)
- Auto-refresh every 30 seconds (polling) or use WebSocket
- Badge notifications for new orders (if tab is inactive)

### 4. **Performance**
- Lazy load images with caching
- Limit initial data to 20 orders
- Pagination: Load more on scroll
- Debounce search input (300ms)

---

## 📱 COMPONENT SPECIFICATIONS

### OrderCardWidget Parameters
```dart
class OrderCardWidget extends StatelessWidget {
  final Map<String, dynamic> order;
  final bool isSeller;
  final VoidCallback onTap;
  final Function(String)? onStatusChange;  // For sellers
}
```

### StatusFilterChipWidget Parameters
```dart
class StatusFilterChipWidget extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
}
```

### OrderDetailsSheet Content
```dart
class OrderDetailsSheet extends StatefulWidget {
  final Map<String, dynamic> order;
  final bool isSeller;
  final Function(String) onStatusUpdate;
  final VoidCallback onCallTap;
  final VoidCallback onShareTap;
}
```

---

## 🎯 Recommended Enhancements (Phase 2)

1. **Map Integration**: Show delivery location on map
2. **Tracking Numbers**: Display and manage shipment tracking
3. **Chat System**: In-app messaging with buyer/seller
4. **Payment Link**: Resend payment link if unpaid
5. **Invoice Portal**: Customer-facing invoice portal
6. **Bulk Operations**: Bulk status updates for multiple orders
7. **Analytics**: Orders dashboard with trends, metrics
8. **Notifications**: Push/SMS for order status changes
9. **Returns Management**: Handle order returns workflow
10. **Ratings & Reviews**: After delivery, collect feedback

---

## 📊 API Endpoints Expected (Supabase)

```
GET  /orders?buyer_id=X&status=pending
GET  /orders?seller_id=X&status=shipped
POST /orders/update-status/{order_id}
GET  /orders/{order_id}/details
POST /orders/{order_id}/notes
GET  /orders/{order_id}/invoice
```

---

## ✨ Design Token References

**Spacing**:
- Standard padding: 4.w (4% width)
- Card margins: 2.w (2% width)
- Icon spacing: 1.5.h (1.5% height)

**Typography**:
- Title: 18.sp (title large)
- Subtitle: 14.sp (body medium)
- Body: 12.sp (body small)
- Caption: 10.sp (caption)

**Border Radius**:
- Cards: 12 dp
- Chips: 20 dp
- Dialog: 20 dp

**Elevation**:
- Cards: 2 dp
- Modals: 4 dp
- FAB: 4 dp

---

## 🚀 Implementation Priority

**Phase 1 (MVP)**:
1. ✅ Order card UI with all fields
2. ✅ Status filter chips
3. ✅ Order details modal
4. ✅ Tab switching (My Orders/Sales)
5. ✅ Pull-to-refresh
6. Status update (sellers)

**Phase 2 (Enhancement)**:
1. Search/filter
2. Advanced date filtering
3. Bulk operations
4. Invoice generation
5. Call integration

**Phase 3 (Premium)**:
1. Real-time updates
2. Map tracking
3. Chat system
4. Analytics dashboard
5. Mobile-specific optimizations

---

