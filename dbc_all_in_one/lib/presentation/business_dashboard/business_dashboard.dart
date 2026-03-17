import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/invoicing_service.dart';
import '../../services/notification_service.dart';
import '../../services/security_alerts_service.dart';
import '../../services/session_manager.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../live_camera_view/live_camera_view.dart';
import '../inventory_management/inventory_management.dart';
import '../staff_management/staff_management.dart';
import './widgets/notification_carousel_widget.dart';
import './widgets/security_notification_widget.dart';
import './widgets/desktop_sidebar_widget.dart';
import './widgets/desktop_right_panel_widget.dart';
import './widgets/dashboard_tab_widget.dart';
import './widgets/more_tab_widget.dart';
import './widgets/show_create_invoice_dialog.dart';

class BusinessDashboard extends StatefulWidget {
  const BusinessDashboard({super.key});

  @override
  State<BusinessDashboard> createState() => _BusinessDashboardState();
}

class _BusinessDashboardState extends State<BusinessDashboard> {
  int _currentNavIndex = 0;
  bool _showNotificationCarousel = true;

  final String businessName = "DBC Cafe & Bistro";

  late List<NotificationItem> _notificationItems;

  final SecurityAlertsService _alertsService = SecurityAlertsService();
  final SessionManager _sessionManager = SessionManager();
  final NotificationService _notificationService = NotificationService();

  int _activeAlertsCount = 0;
  OverlayEntry? _notificationOverlay;
  int _unreadNotificationCount = 0;

  static const _navItems = [
    {'icon': Icons.home_outlined, 'activeIcon': Icons.home, 'label': 'Home'},
    {
      'icon': Icons.security_outlined,
      'activeIcon': Icons.security,
      'label': 'Security'
    },
    {
      'icon': Icons.inventory_2_outlined,
      'activeIcon': Icons.inventory_2,
      'label': 'Stock'
    },
    {
      'icon': Icons.people_outline,
      'activeIcon': Icons.people,
      'label': 'Staff'
    },
    {'icon': Icons.more_horiz, 'activeIcon': Icons.more_horiz, 'label': 'More'},
  ];

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _checkForSecurityAlerts();
    _loadUnreadNotificationCount();
  }

  void _initializeNotifications() {
    _notificationItems = [
      NotificationItem(
        title: 'Payment Received ✓',
        message: 'Customer paid \$2,450.00 for Invoice #INV-2024-001',
        icon: 'payment',
        color: const Color(0xFF10B981),
        displayDuration: 2,
      ),
      NotificationItem(
        title: 'Security Alert ⚠️',
        message: 'Unauthorized access detected in CCTV zone 3 - Please review',
        icon: 'security',
        color: const Color(0xFFEF4444),
        displayDuration: 5,
      ),
      NotificationItem(
        title: 'Low Inventory Alert',
        message: 'Espresso Beans stock below 10 units - Reorder recommended',
        icon: 'inventory',
        color: const Color(0xFFF59E0B),
        displayDuration: 3,
      ),
    ];
  }

  Future<void> _loadUnreadNotificationCount() async {
    try {
      final count = await _notificationService.getUnreadCount();
      if (mounted) setState(() => _unreadNotificationCount = count);
    } catch (_) {}
  }

  @override
  void dispose() {
    _notificationOverlay?.remove();
    _notificationOverlay = null;
    super.dispose();
  }

  Future<void> _checkForSecurityAlerts() async {
    try {
      final hasShown = await _sessionManager.wasAlertShownInCurrentSession();
      if (hasShown) return;
      final count = await _alertsService.getActiveAlertsCount();
      setState(() => _activeAlertsCount = count);
      if (count > 0) {
        Future.delayed(const Duration(milliseconds: 500), () async {
          if (mounted) {
            _showSecurityNotification();
            await _sessionManager.markAlertAsShown();
          }
        });
      }
    } catch (_) {}
  }

  void _showSecurityNotification() {
    _notificationOverlay?.remove();
    _notificationOverlay = OverlayEntry(
      builder: (context) => SecurityNotificationWidget(
        alertsCount: _activeAlertsCount,
        onTap: () {
          _notificationOverlay?.remove();
          _notificationOverlay = null;
          Navigator.pushNamed(context, AppRoutes.securityAlertsDashboard);
        },
        onDismiss: () {
          _notificationOverlay?.remove();
          _notificationOverlay = null;
        },
      ),
    );
    Overlay.of(context).insert(_notificationOverlay!);
  }

  // ─────────────────────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 700;
        return isDesktop ? _buildDesktopScaffold() : _buildMobileScaffold();
      },
    );
  }

  // ─────────────────────────────────────────────────────────────
  // DESKTOP: sidebar | constrained content | right panel
  // ─────────────────────────────────────────────────────────────
  Widget _buildDesktopScaffold() {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F1F5),
      body: Row(
        children: [
          // Left sidebar
          DesktopSidebarWidget(
            currentIndex: _currentNavIndex,
            unreadCount: _unreadNotificationCount,
            navItems: _navItems,
            onTap: (i) => setState(() => _currentNavIndex = i),
            onNotificationTap: () =>
                Navigator.pushNamed(context, AppRoutes.notificationCenter)
                    .then((_) => _loadUnreadNotificationCount()),
          ),

          // Center content — capped at 780px, never stretches
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 780),
                child: Stack(
                  children: [
                    _getScreen(),
                    Positioned(
                      bottom: 24,
                      right: 24,
                      child: FloatingActionButton.extended(
                        onPressed: () => showCreateInvoiceDialog(context),
                        backgroundColor: const Color(0xFF10B981),
                        icon: const Icon(Icons.receipt_long),
                        label: const Text('Bill'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Right panel
          DesktopRightPanelWidget(
            unreadCount: _unreadNotificationCount,
            onNotificationTap: () =>
                Navigator.pushNamed(context, AppRoutes.notificationCenter)
                    .then((_) => _loadUnreadNotificationCount()),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // MOBILE: bottom nav bar
  // ─────────────────────────────────────────────────────────────
  Widget _buildMobileScaffold() {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: _currentNavIndex == 0
          ? null
          : AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: Text(
                _getAppBarTitle(),
                style: const TextStyle(
                    color: Color(0xFF1A1A1A),
                    fontWeight: FontWeight.w700,
                    fontSize: 18),
              ),
              actions: [
                Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications_outlined,
                          color: Color(0xFF1A1A1A)),
                      onPressed: () => Navigator.pushNamed(
                              context, AppRoutes.notificationCenter)
                          .then((_) => _loadUnreadNotificationCount()),
                    ),
                    if (_unreadNotificationCount > 0)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                              color: Colors.red, shape: BoxShape.circle),
                          child: Text(
                            _unreadNotificationCount > 99
                                ? '99+'
                                : _unreadNotificationCount.toString(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
      body: _getScreen(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showCreateInvoiceDialog(context),
        backgroundColor: const Color(0xFF10B981),
        icon: const Icon(Icons.receipt_long),
        label: const Text('Bill'),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentNavIndex,
        onTap: (i) => setState(() => _currentNavIndex = i),
        variant: CustomBottomBarVariant.standard,
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // SCREEN ROUTER
  // ─────────────────────────────────────────────────────────────
  Widget _getScreen() {
    switch (_currentNavIndex) {
      case 0:
        return DashboardTabWidget(
          businessName: businessName,
          notificationItems: _notificationItems,
          showNotificationCarousel: _showNotificationCarousel,
          activeAlertsCount: _activeAlertsCount,
          unreadNotificationCount: _unreadNotificationCount,
          onDismissCarousel: () =>
              setState(() => _showNotificationCarousel = false),
          onViewAll: () => setState(() => _currentNavIndex = 4),
          onRefresh: _handleRefresh,
          onNotificationTap: () =>
              Navigator.pushNamed(context, AppRoutes.notificationCenter)
                  .then((_) => _loadUnreadNotificationCount()),
        );
      case 1:
        return const LiveCameraView();
      case 2:
        return const InventoryManagement();
      case 3:
        return const StaffManagement();
      case 4:
        return const MoreTabWidget();
      default:
        return const SizedBox();
    }
  }

  String _getAppBarTitle() {
    switch (_currentNavIndex) {
      case 1:
        return 'Security';
      case 2:
        return 'Inventory';
      case 3:
        return 'Staff';
      case 4:
        return 'More';
      default:
        return 'Dashboard';
    }
  }

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Dashboard refreshed successfully'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        duration: const Duration(seconds: 2),
      ));
    }
  }
}
