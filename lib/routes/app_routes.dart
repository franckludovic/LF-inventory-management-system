import 'package:get/get.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/home/presentation/screens/dashboard_screen.dart';
import '../features/search/presentation/screens/search_screen.dart';
import '../features/search/presentation/screens/part_details_screen.dart';
import '../features/Parts/presentation/screens/low_stock_alerts_screen.dart';
import '../features/Parts/presentation/screens/stock_update_screen.dart';
import '../features/Parts/presentation/screens/stock_update_success_screen.dart';
import '../features/reports/presentation/screens/generate_report_screen.dart';
import '../features/reports/presentation/screens/report_details_screen.dart';
import '../features/profile/presentation/screens/profile_screen.dart';
import '../core/widgets/navigation_menu.dart';
import '../features/auth/bindings/login_binding.dart';
import '../features/home/bindings/dashboard_binding.dart';
import '../features/search/bindings/search_binding.dart';
import '../features/search/bindings/part_details_binding.dart';
import '../features/Parts/bindings/low_stock_alerts_binding.dart';
import '../features/Parts/bindings/stock_update_binding.dart';
import '../features/Parts/bindings/stock_update_success_binding.dart';
import '../features/reports/bindings/generate_report_binding.dart';
import '../features/reports/bindings/report_details_binding.dart';
import '../features/profile/bindings/profile_binding.dart';
import '../core/controllers/navigation_binding.dart';

class AppRoutes {
  static const String initial = '/';
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String search = '/search';
  static const String partDetails = '/part-details';
  static const String lowStockAlerts = '/low-stock-alerts';
  static const String stockUpdate = '/stock-update';
  static const String stockUpdateSuccess = '/stock-update-success';
  static const String generateReport = '/generate-report';
  static const String reportDetails = '/report-details';
  static const String profile = '/profile';

  static List<GetPage> pages = [
    GetPage(
      name: initial,
      page: () => const NavigationMenu(),
      binding: NavigationBinding(),
    ),
    GetPage(
      name: login,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: dashboard,
      page: () => const DashboardScreen(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: search,
      page: () => const SearchScreen(),
      binding: SearchBinding(),
    ),
    GetPage(
      name: partDetails,
      page: () => const PartDetailsScreen(),
      binding: PartDetailsBinding(),
    ),
    GetPage(
      name: lowStockAlerts,
      page: () => const LowStockAlertsScreen(),
      binding: LowStockAlertsBinding(),
    ),
    GetPage(
      name: stockUpdate,
      page: () => const StockUpdateScreen(),
      binding: StockUpdateBinding(),
    ),
    GetPage(
      name: stockUpdateSuccess,
      page: () => const StockUpdateSuccessScreen(),
      binding: StockUpdateSuccessBinding(),
    ),
    GetPage(
      name: generateReport,
      page: () => const GenerateReportScreen(),
      binding: GenerateReportBinding(),
    ),
    GetPage(
      name: reportDetails,
      page: () => const ReportDetailsScreen(),
      binding: ReportDetailsBinding(),
    ),
    GetPage(
      name: profile,
      page: () => const ProfileScreen(),
      binding: ProfileBinding(),
    ),
  ];
}
