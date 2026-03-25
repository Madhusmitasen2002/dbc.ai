import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'presentation/splash_screen/splash_screen.dart';
import 'presentation/business_dashboard/business_dashboard.dart';
import 'presentation/payment_processing_center/payment_processing_center.dart';
import 'presentation/staff_management/staff_management.dart';
import 'presentation/live_camera_view/live_camera_view.dart';
import 'presentation/inventory_management/inventory_management.dart';
import 'presentation/order_management_hub/order_management_hub.dart';

// ✅ ADD THIS (GLOBAL KEY)
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ REQUIRED: Supabase MUST be initialized
  await Supabase.initialize(
    url: 'https://dummy.supabase.co', // ← TEMP PLACEHOLDER
    anonKey: 'dummy-key', // ← TEMP PLACEHOLDER
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          navigatorKey: navigatorKey, // ✅ ADD THIS
          debugShowCheckedModeBanner: false,
          title: 'dbc_all_in_one',
          home: const SplashScreen(),
          routes: {
    '/payment-processing-center': (context) => const PaymentProcessingCenter(),
  '/order-management-hub': (context) => const OrderManagementHub(),
  '/staff-management': (context) => const StaffManagement(),
  '/inventory-management': (context) => const InventoryManagement(),
  '/live-camera-view': (context) => const LiveCameraView(),
  },
        );
      },
    );
  }
}
