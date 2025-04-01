import 'package:flutter/material.dart';

class AppColors {
  // Primary palette
  static const Color primary = Color(0xFF4d9feb); // #91C9FF
  static const Color primaryLight = Color(0xFFD3E9FF); // #D3E9FF
  static const Color primaryDark = Color(0xFF192841); // #192841
  static const Color accent = Color(0xFF000000); // #000000

  // Status colors
  static const Color pending = Color(0xFFD9D93A); // #D9D93A
  static const Color completed = Color(0xFF128235); // #128235
  static const Color progress = Color(0xFFF8A12F); // #F8A12F
  static const Color darkGrey = Color(0xFF525252); // #525252

  // UI element colors
  static const Color scaffoldBackground = Colors.white;
  static const Color homeScaffold = Color(0xFFf2f2f2);
  static const Color sidebarBackground = Colors.white;
  static const Color sidebarText = Colors.white;
  static const Color buttonPrimary = Color(0xFF4d9feb); // Same as primary
  static const Color buttonSecondary = Color(0xFF6C757D); // #6C757D
  static const Color buttonSuccess = Color(0xFF28A745); // #28A745
  static const Color buttonDanger = Color(0xFFDC3545); // #DC3545
}

class AppTextStyles {
  /// Large display text style (e.g., headings).
  static const TextStyle displayLarge = TextStyle(
    fontWeight: FontWeight.w600, // SemiBold
    fontSize: 32,
    color: AppColors.primaryDark,
  );

  /// Medium display text style (e.g., subheadings).
  static const TextStyle displayMedium = TextStyle(
    fontWeight: FontWeight.w500, // Medium
    fontSize: 28,
    color: AppColors.primaryDark,
  );

  /// Large body text style (e.g., paragraphs).
  static const TextStyle bodyLarge = TextStyle(
    fontWeight: FontWeight.w400, // Regular
    fontSize: 16,
    color: AppColors.primaryDark,
  );

  /// Medium body text style (e.g., captions).
  static const TextStyle bodyMedium = TextStyle(
    fontWeight: FontWeight.w300, // Light
    fontSize: 14,
    color: AppColors.primaryDark,
  );
}

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.scaffoldBackground,
        error: AppColors.buttonDanger,
        onPrimary: Colors.white,
        onSecondary: AppColors.primaryDark,
        onSurface: AppColors.darkGrey,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: AppColors.scaffoldBackground,
      textTheme: const TextTheme(
        displayLarge: AppTextStyles.displayLarge,
        displayMedium: AppTextStyles.displayMedium,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        titleLarge: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 22,
          color: AppColors.primaryDark,
        ),
        titleMedium: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: AppColors.primaryDark,
        ),
        titleSmall: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: AppColors.primaryDark,
        ),
        labelLarge: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 16,
          color: AppColors.darkGrey,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 6,
        titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        shadowColor: AppColors.accent.withValues(alpha: 0.4),
        surfaceTintColor: AppColors.primary,
        scrolledUnderElevation: 3,
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: AppColors.sidebarBackground,
        scrimColor: Colors.black54,
        elevation: 1,
        surfaceTintColor: AppColors.primary.withValues(alpha: 0.02),
      ),
      listTileTheme: const ListTileThemeData(
        textColor: AppColors.sidebarText,
        iconColor: AppColors.sidebarText,
        selectedColor: AppColors.primary,
        selectedTileColor: Colors.white10,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.buttonPrimary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 1,
          shadowColor: Colors.black.withValues(alpha: 0.2),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.buttonPrimary,
          side: const BorderSide(color: AppColors.buttonPrimary),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.buttonPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 1,
        shadowColor: Colors.black.withValues(alpha: 0.1),
        surfaceTintColor: AppColors.primary.withValues(alpha: 0.05),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.darkGrey,
        elevation: 8,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
      iconTheme: const IconThemeData(color: AppColors.darkGrey, size: 24),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.darkGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.buttonDanger),
        ),
        filled: true,
        fillColor: Colors.white,
        labelStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.darkGrey,
        ),
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.darkGrey.withValues(alpha: 0.6),
        ),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: Colors.white,
        surfaceTintColor: AppColors.primary.withValues(alpha: 0.05),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        titleTextStyle: AppTextStyles.displayMedium,
        contentTextStyle: AppTextStyles.bodyLarge,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.primaryDark,
        contentTextStyle: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 16,
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        behavior: SnackBarBehavior.floating,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.progress,
        linearTrackColor: AppColors.primaryLight,
        circularTrackColor: AppColors.primaryLight,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) =>
              states.contains(WidgetState.selected)
                  ? AppColors.primary
                  : AppColors.darkGrey,
        ),
        checkColor: WidgetStateProperty.all(Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) =>
              states.contains(WidgetState.selected)
                  ? AppColors.primary
                  : AppColors.darkGrey,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) =>
              states.contains(WidgetState.selected)
                  ? AppColors.primary
                  : Colors.white,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) =>
              states.contains(WidgetState.selected)
                  ? AppColors.primaryLight
                  : AppColors.darkGrey,
        ),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.primaryDark,
          borderRadius: BorderRadius.circular(4),
        ),
        textStyle: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.buttonPrimary,
        foregroundColor: Colors.white,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      dividerTheme: DividerThemeData(
        color: AppColors.darkGrey.withValues(alpha: 0.2),
        thickness: 1,
      ),
      tabBarTheme: const TabBarTheme(
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.darkGrey,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
    );
  }
}
