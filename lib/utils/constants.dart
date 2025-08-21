import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF1976D2);
  static const Color primaryLight = Color(0xFF42A5F5);
  static const Color primaryDark = Color(0xFF1565C0);
  
  static const Color secondary = Color(0xFF4CAF50);
  static const Color secondaryLight = Color(0xFF66BB6A);
  static const Color secondaryDark = Color(0xFF2E7D32);
  
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textLight = Color(0xFF999999);
  
  static const Color background = Color(0xFFFFFFFF);
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color backgroundDark = Color(0xFF1A1A1A);
  
  static const Color shadow = Color(0x1A000000);
  static const Color border = Color(0xFFE0E0E0);
}

class AppSizes {
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;
  static const double paddingXXLarge = 48.0;
  static const double paddingXXXLarge = 80.0;
  
  static const double marginSmall = 8.0;
  static const double marginMedium = 16.0;
  static const double marginLarge = 24.0;
  static const double marginXLarge = 32.0;
  static const double marginXXLarge = 48.0;
  static const double marginXXXLarge = 80.0;
  
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusLarge = 16.0;
  static const double borderRadiusXLarge = 20.0;
  
  static const double iconSizeSmall = 20.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;
  static const double iconSizeXLarge = 40.0;
  static const double iconSizeXXLarge = 80.0;
}

class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.2,
  );
  
  static const TextStyle heading2 = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.2,
  );
  
  static const TextStyle heading3 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 20,
    color: AppColors.textSecondary,
    height: 1.5,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 18,
    color: AppColors.textSecondary,
    height: 1.6,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: 16,
    color: AppColors.textSecondary,
    height: 1.5,
  );
  
  static const TextStyle button = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );
  
  static const TextStyle link = TextStyle(
    fontSize: 18,
    color: AppColors.primary,
    fontWeight: FontWeight.w600,
  );
}

class AppStrings {
  // Заголовки
  static const String mainTitle = 'Электронный документооборот\nс контрагентами';
  static const String mainSubtitle = 'Отправляйте акты, накладные, счета‑фактуры и другие документы\nбез дублирования на бумаге. Получайте документы бесплатно';
  
  // Кнопки
  static const String buyButton = 'Купить';
  static const String tryFreeButton = 'Попробовать бесплатно';
  static const String calculateSavingsButton = 'Рассчитать экономию';
  static const String findButton = 'Найти';
  static const String downloadAppButton = 'Скачать приложение';
  static const String sendRequestButton = 'Отправить заявку';
  
  // Секции
  static const String benefitsTitle = 'Самое время перейти\nна ЭДО';
  static const String featuresTitle = 'Возможности сервиса';
  static const String securityTitle = 'С Диадоком надежно,\nудобно и безопасно';
  static const String successStoriesTitle = 'Истории успеха клиентов';
  static const String mobileAppTitle = 'Мобильное приложение';
  static const String contactTitle = 'Начните работать в Диадоке';
  
  // Навигация
  static const String navCapabilities = 'Возможности';
  static const String navIndustries = 'Отрасли';
  static const String navPricing = 'Цены';
  static const String navIntegration = 'Интеграция';
  static const String navJournal = 'Журнал';
  static const String navLogin = 'Войти';
  static const String navConnect = 'Подключиться';
}
