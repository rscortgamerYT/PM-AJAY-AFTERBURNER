import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  // Color Palette
  static const Color primaryIndigo = Color(0xFF3F51B5);
  static const Color secondaryTeal = Color(0xFF26A69A);
  
  // Neutral Colors
  static const Color backgroundOffWhite = Color(0xFFF5F7FA);
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF546E7A);
  
  // Semantic Colors
  static const Color successGreen = Color(0xFF2E7D32);
  static const Color warningAmber = Color(0xFFFFB300);
  static const Color errorRed = Color(0xFFC62828);
  
  // Additional UI Colors
  static const Color inputFill = Color(0xFFE0F2F1);
  static const Color cardShadow = Color(0x1A000000);
  static const Color dividerLight = Color(0xFFE0E0E0);
  static const Color overlayDark = Color(0x80000000);
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryIndigo, Color(0xFF5C6BC0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient tealGradient = LinearGradient(
    colors: [secondaryTeal, Color(0xFF4DB6AC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Typography
  static const String primaryFontFamily = 'Inter';
  static const String headingFontFamily = 'Roboto Slab';
  
  static const TextStyle h1 = TextStyle(
    fontFamily: headingFontFamily,
    fontSize: 32,
    fontWeight: FontWeight.bold,
    height: 1.3,
    color: textPrimary,
  );
  
  static const TextStyle h2 = TextStyle(
    fontFamily: headingFontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: textPrimary,
  );
  
  static const TextStyle h3 = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 20,
    fontWeight: FontWeight.bold,
    height: 1.3,
    color: textPrimary,
  );
  
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 1.5,
    color: textPrimary,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.5,
    color: textSecondary,
  );
  
  static const TextStyle labelLarge = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: textPrimary,
  );

  // Spacing (8-point grid)
  static const double spacing1 = 4.0;
  static const double spacing2 = 8.0;
  static const double spacing3 = 12.0;
  static const double spacing4 = 16.0;
  static const double spacing5 = 20.0;
  static const double spacing6 = 24.0;
  static const double spacing8 = 32.0;
  static const double spacing10 = 40.0;
  static const double spacing12 = 48.0;
  static const double spacing16 = 64.0;

  // Border Radius
  static const double radiusSmall = 4.0;
  static const double radiusMedium = 8.0;
  static const double radiusLarge = 12.0;
  static const double radiusXLarge = 16.0;
  static const double radiusRound = 24.0;

  // Shadows
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 1),
      blurRadius: 3,
      spreadRadius: 0,
    ),
  ];
  
  static const List<BoxShadow> elevatedShadow = [
    BoxShadow(
      color: Color(0x1F000000),
      offset: Offset(0, 2),
      blurRadius: 8,
      spreadRadius: 0,
    ),
  ];
  
  static const List<BoxShadow> floatingShadow = [
    BoxShadow(
      color: Color(0x26000000),
      offset: Offset(0, 4),
      blurRadius: 12,
      spreadRadius: 0,
    ),
  ];

  // Theme Data
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: primaryIndigo,
        secondary: secondaryTeal,
        surface: surfaceWhite,
        background: backgroundOffWhite,
        error: errorRed,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textPrimary,
        onBackground: textPrimary,
        onError: Colors.white,
      ),
      
      // Typography
      textTheme: const TextTheme(
        displayLarge: h1,
        displayMedium: h2,
        displaySmall: h3,
        headlineLarge: h2,
        headlineMedium: h3,
        titleLarge: h3,
        titleMedium: TextStyle(
          fontFamily: primaryFontFamily,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          height: 1.3,
          color: textPrimary,
        ),
        titleSmall: labelLarge,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        labelLarge: labelLarge,
        labelMedium: TextStyle(
          fontFamily: primaryFontFamily,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          height: 1.3,
          color: textSecondary,
        ),
      ),
      
      // App Bar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryIndigo,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: headingFontFamily,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      
      // Card Theme
      cardTheme: CardTheme(
        color: surfaceWhite,
        elevation: 0,
        shadowColor: cardShadow.first.color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
      ),
      
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryIndigo,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: cardShadow.first.color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: spacing4,
            vertical: spacing3,
          ),
          textStyle: const TextStyle(
            fontFamily: primaryFontFamily,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryIndigo,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: spacing4,
            vertical: spacing2,
          ),
          textStyle: const TextStyle(
            fontFamily: primaryFontFamily,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryIndigo,
          side: const BorderSide(color: primaryIndigo, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: spacing4,
            vertical: spacing3,
          ),
          textStyle: const TextStyle(
            fontFamily: primaryFontFamily,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: inputFill,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: primaryIndigo, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: errorRed, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacing4,
          vertical: spacing3,
        ),
        labelStyle: const TextStyle(
          fontFamily: primaryFontFamily,
          fontSize: 14,
          color: textSecondary,
        ),
        hintStyle: const TextStyle(
          fontFamily: primaryFontFamily,
          fontSize: 14,
          color: textSecondary,
        ),
      ),
      
      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: inputFill,
        selectedColor: primaryIndigo.withOpacity(0.1),
        labelStyle: const TextStyle(
          fontFamily: primaryFontFamily,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusRound),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: spacing2,
          vertical: spacing1,
        ),
      ),
      
      // Tab Bar Theme
      tabBarTheme: const TabBarTheme(
        labelColor: primaryIndigo,
        unselectedLabelColor: textSecondary,
        indicatorColor: primaryIndigo,
        labelStyle: TextStyle(
          fontFamily: primaryFontFamily,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: primaryFontFamily,
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
      ),
      
      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surfaceWhite,
        selectedItemColor: primaryIndigo,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(
          fontFamily: primaryFontFamily,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: primaryFontFamily,
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
      ),
      
      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: dividerLight,
        thickness: 1,
        space: 1,
      ),
      
      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return primaryIndigo;
          }
          return Colors.grey[400];
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return primaryIndigo.withOpacity(0.3);
          }
          return Colors.grey[300];
        }),
      ),
      
      // Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return primaryIndigo;
          }
          return Colors.transparent;
        }),
        checkColor: MaterialStateProperty.all(Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
        ),
      ),
      
      // Radio Theme
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return primaryIndigo;
          }
          return textSecondary;
        }),
      ),
      
      // Slider Theme
      sliderTheme: const SliderThemeData(
        activeTrackColor: primaryIndigo,
        inactiveTrackColor: dividerLight,
        thumbColor: primaryIndigo,
        overlayColor: Color(0x1A3F51B5),
      ),
      
      // Progress Indicator Theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primaryIndigo,
        linearTrackColor: dividerLight,
        circularTrackColor: dividerLight,
      ),
      
      // Snack Bar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: textPrimary,
        contentTextStyle: const TextStyle(
          fontFamily: primaryFontFamily,
          fontSize: 14,
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      
      // Dialog Theme
      dialogTheme: DialogTheme(
        backgroundColor: surfaceWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLarge),
        ),
        titleTextStyle: h3,
        contentTextStyle: bodyLarge,
      ),
      
      // Bottom Sheet Theme
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: surfaceWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(radiusXLarge),
          ),
        ),
      ),
    );
  }

  // Role-specific theme variations
  static ThemeData getCentreTheme() {
    return lightTheme.copyWith(
      appBarTheme: lightTheme.appBarTheme.copyWith(
        backgroundColor: primaryIndigo,
        foregroundColor: Colors.white,
      ),
    );
  }

  static ThemeData getStateTheme() {
    return lightTheme.copyWith(
      appBarTheme: lightTheme.appBarTheme.copyWith(
        backgroundColor: const Color(0xFF1976D2), // Blue 700
        foregroundColor: Colors.white,
      ),
    );
  }

  static ThemeData getAgencyTheme() {
    return lightTheme.copyWith(
      appBarTheme: lightTheme.appBarTheme.copyWith(
        backgroundColor: secondaryTeal,
        foregroundColor: Colors.white,
      ),
    );
  }

  static ThemeData getAuditorTheme() {
    return lightTheme.copyWith(
      appBarTheme: lightTheme.appBarTheme.copyWith(
        backgroundColor: const Color(0xFF7B1FA2), // Purple 700
        foregroundColor: Colors.white,
      ),
    );
  }

  static ThemeData getPublicTheme() {
    return lightTheme.copyWith(
      appBarTheme: lightTheme.appBarTheme.copyWith(
        backgroundColor: const Color(0xFF388E3C), // Green 700
        foregroundColor: Colors.white,
      ),
    );
  }
}

// Animation Durations
class AppAnimations {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration medium = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  
  // Curves
  static const Curve easeInOut = Curves.easeInOut;
  static const Curve easeOut = Curves.easeOut;
  static const Curve bounceOut = Curves.bounceOut;
}

// Breakpoints for Responsive Design
class AppBreakpoints {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
  static const double largeDesktop = 1600;
}

// Extension for responsive design
extension ResponsiveExtension on BuildContext {
  bool get isMobile => MediaQuery.of(this).size.width < AppBreakpoints.mobile;
  bool get isTablet => MediaQuery.of(this).size.width >= AppBreakpoints.mobile && 
                      MediaQuery.of(this).size.width < AppBreakpoints.desktop;
  bool get isDesktop => MediaQuery.of(this).size.width >= AppBreakpoints.desktop;
  bool get isLargeDesktop => MediaQuery.of(this).size.width >= AppBreakpoints.largeDesktop;
}
