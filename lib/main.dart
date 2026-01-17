import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lf_project/core/constants/strings.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/bindings/login_binding.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'core/widgets/navigation_menu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppStrings.appTitle,
      debugShowCheckedModeBanner: false,

      // THEMES
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,

      // ROUTES
      initialRoute: '/login',
      getPages: [
        GetPage(
          name: '/login',
          page: () => const LoginScreen(),
          binding: LoginBinding(),
        ),

        GetPage(
          name: '/home',
          page: () => const NavigationMenu(),
        ),
      ],
    );
  }
}
