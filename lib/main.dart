import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/config/app_config.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_material_colors.dart';
import 'core/theme/app_text_styles.dart';
import 'core/utils/logger.dart';
import 'core/routers/app_router.dart';

void main() {
  // Khởi tạo logging
  AppLogger.info('=== ỨNG DỤNG HỌC MỖI NGÀY KHỞI ĐỘNG ===');
  AppLogger.info('Environment: ${AppConfig.environment}');
  AppLogger.info('Enable Logging: ${AppConfig.enableLogging}');
  AppLogger.info('Base URL: ${AppConfig.baseUrl}');

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    title: 'Học Mỗi Ngày',
    theme: ThemeData(
      primarySwatch: AppMaterialColors.primaryBlue,
      fontFamily: 'Roboto',
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: AppTextStyles.headlineSmall,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    ),
    routerConfig: AppRoutes.routerConfig,
  );
}
