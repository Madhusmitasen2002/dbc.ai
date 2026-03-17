import 'package:flutter/material.dart';
import '../../../core/app_export.dart';

class MoreTabWidget extends StatelessWidget {
  const MoreTabWidget({super.key});

  static const _moreMenuItems = [
    {
      "title": "GST Filing",
      "subtitle": "2 Pending · Due in 7 days",
      "icon": Icons.account_balance,
      "color": Color(0xFFE11D48),
      "route": "/gst-filing-center",
    },
    {
      "title": "GST Reports",
      "subtitle": "Compliance & reports",
      "icon": Icons.description,
      "color": Color(0xFF6366F1),
      "route": "/gst-reports",
    },
    {
      "title": "Payroll",
      "subtitle": "\$12,500 · Processing",
      "icon": Icons.payments,
      "color": Color(0xFF06B6D4),
      "route": "/payroll-processing",
    },
    {
      "title": "Hiring",
      "subtitle": "5 Open · 12 applications",
      "icon": Icons.work,
      "color": Color(0xFFF97316),
      "route": "/staff-hiring",
    },
    {
      "title": "Vendor Marketplace",
      "subtitle": "45 Products · 3 new vendors",
      "icon": Icons.storefront,
      "color": Color(0xFF14B8A6),
      "route": "/marketplace-product-catalog",
    },
    {
      "title": "Security Alerts",
      "subtitle": "3 Active alerts",
      "icon": Icons.warning,
      "color": Color(0xFFEF4444),
      "route": "/security-alerts-dashboard",
    },
    {
      "title": "Order Management",
      "subtitle": "24 Active · +8 today",
      "icon": Icons.shopping_cart,
      "color": Color(0xFF8B5CF6),
      "route": "/order-management-hub",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        _sectionHeader('Account'),
        _moreTile(context,
            icon: Icons.person_outline,
            iconColor: const Color(0xFF6B46C1),
            title: 'Profile',
            onTap: () {}),
        _moreTile(context,
            icon: Icons.settings_outlined,
            iconColor: const Color(0xFF6B46C1),
            title: 'Settings',
            onTap: () {}),
        _moreTile(context,
            icon: Icons.notifications_outlined,
            iconColor: const Color(0xFF6B46C1),
            title: 'Notifications',
            onTap: () =>
                Navigator.pushNamed(context, AppRoutes.notificationCenter)),
        _moreTile(context,
            icon: Icons.help_outline,
            iconColor: const Color(0xFF6B46C1),
            title: 'Help',
            onTap: () {}),
        const SizedBox(height: 8),
        _sectionHeader('Business Tools'),
        ..._moreMenuItems.map((item) => _moreTile(context,
              icon: item['icon'] as IconData,
              iconColor: item['color'] as Color,
              title: item['title'] as String,
              subtitle: item['subtitle'] as String,
              onTap: () =>
                  Navigator.pushNamed(context, item['route'] as String))),
        const Divider(height: 24, indent: 16, endIndent: 16),
        _moreTile(context,
            icon: Icons.logout,
            iconColor: Colors.red,
            title: 'Logout',
            titleColor: Colors.red,
            onTap: () {}),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Text(title.toUpperCase(),
          style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Color(0xFF9E9E9E),
              letterSpacing: 1.2)),
    );
  }

  Widget _moreTile(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
    Color? titleColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(title,
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: titleColor ?? const Color(0xFF1A1A1A))),
      subtitle: subtitle != null
          ? Text(subtitle,
              style:
                  const TextStyle(fontSize: 12, color: Color(0xFF9E9E9E)))
          : null,
      trailing: const Icon(Icons.chevron_right,
          color: Color(0xFFBDBDBD), size: 20),
      onTap: onTap,
    );
  }
}