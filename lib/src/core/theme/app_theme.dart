import 'package:flutter/material.dart';

class AppTheme {
  // Colors
  static const Color primaryColor = Color(0xFF6C63FF);
  static const Color primaryLight = Color(0xFF9B96FF);
  static const Color primaryDark = Color(0xFF3A31CC);

  static const Color secondaryColor = Color(0xFFFF6B9D);
  static const Color secondaryLight = Color(0xFFFF9ECF);
  static const Color secondaryDark = Color(0xFFCC386B);

  static const Color accentColor = Color(0xFFFFC947);
  static const Color accentLight = Color(0xFFFFDB75);
  static const Color accentDark = Color(0xFFCC9D1C);

  static const Color backgroundColor = Color(0xFFF8F9FE);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color cardColor = Color(0xFFFFFFFF);

  // Dark mode colors
  static const Color backgroundColorDark = Color(0xFF0F0F23);
  static const Color surfaceColorDark = Color(0xFF1A1A2E);
  static const Color cardColorDark = Color(0xFF16213E);

  // Text colors
  static const Color textPrimary = Color(0xFF2D3748);
  static const Color textSecondary = Color(0xFF718096);
  static const Color textPrimaryDark = Color(0xFFE2E8F0);
  static const Color textSecondaryDark = Color(0xFFA0AEC0);

  // Error and success colors
  static const Color errorColor = Color(0xFFE53E3E);
  static const Color successColor = Color(0xFF38A169);
  static const Color warningColor = Color(0xFFED8936);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primarySwatch: MaterialColor(primaryColor.value, {
      50: primaryColor.withOpacity(0.05),
      100: primaryColor.withOpacity(0.1),
      200: primaryColor.withOpacity(0.2),
      300: primaryColor.withOpacity(0.3),
      400: primaryColor.withOpacity(0.4),
      500: primaryColor,
      600: primaryColor.withOpacity(0.8),
      700: primaryColor.withOpacity(0.7),
      800: primaryColor.withOpacity(0.6),
      900: primaryColor.withOpacity(0.5),
    }),
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    cardColor: cardColor,

    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: accentColor,
      surface: surfaceColor,
      error: errorColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onTertiary: Colors.black,
      onSurface: textPrimary,
      onError: Colors.white,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      iconTheme: IconThemeData(color: textPrimary),
      titleTextStyle: TextStyle(
        color: textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        shadowColor: primaryColor.withOpacity(0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),

    cardTheme: const CardThemeData(
      color: cardColor,
      elevation: 4,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),

    // fontFamily: 'Poppins',
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textPrimary,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: textPrimary,
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      headlineLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      headlineSmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      titleLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      titleMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textPrimary,
      ),
      titleSmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textPrimary,
      ),
      bodyLarge: TextStyle(fontSize: 16, color: textPrimary),
      bodyMedium: TextStyle(fontSize: 14, color: textPrimary),
      bodySmall: TextStyle(fontSize: 12, color: textSecondary),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primarySwatch: MaterialColor(primaryColor.value, {
      50: primaryColor.withOpacity(0.05),
      100: primaryColor.withOpacity(0.1),
      200: primaryColor.withOpacity(0.2),
      300: primaryColor.withOpacity(0.3),
      400: primaryColor.withOpacity(0.4),
      500: primaryColor,
      600: primaryColor.withOpacity(0.8),
      700: primaryColor.withOpacity(0.7),
      800: primaryColor.withOpacity(0.6),
      900: primaryColor.withOpacity(0.5),
    }),
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColorDark,
    cardColor: cardColorDark,

    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: accentColor,
      surface: surfaceColorDark,
      error: errorColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onTertiary: Colors.black,
      onSurface: textPrimaryDark,
      onError: Colors.white,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      iconTheme: IconThemeData(color: textPrimaryDark),
      titleTextStyle: TextStyle(
        color: textPrimaryDark,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        shadowColor: primaryColor.withOpacity(0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),

    cardTheme: const CardThemeData(
      color: cardColorDark,
      elevation: 4,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceColorDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),

    // fontFamily: 'Poppins',
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textPrimaryDark,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: textPrimaryDark,
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textPrimaryDark,
      ),
      headlineLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: textPrimaryDark,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimaryDark,
      ),
      headlineSmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textPrimaryDark,
      ),
      titleLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textPrimaryDark,
      ),
      titleMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textPrimaryDark,
      ),
      titleSmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textPrimaryDark,
      ),
      bodyLarge: TextStyle(fontSize: 16, color: textPrimaryDark),
      bodyMedium: TextStyle(fontSize: 14, color: textPrimaryDark),
      bodySmall: TextStyle(fontSize: 12, color: textSecondaryDark),
    ),
  );

  // Character-based themes
  static final Map<String, Map<String, ThemeData>> characterThemes = {
    'sherlock_holmes': {
      'light': _createSherlockTheme(false),
      'dark': _createSherlockTheme(true),
    },
    'peppa_pig': {
      'light': _createPeppaTheme(false),
      'dark': _createPeppaTheme(true),
    },
    'dora_explorer': {
      'light': _createDoraTheme(false),
      'dark': _createDoraTheme(true),
    },
    'iron_man': {
      'light': _createIronManTheme(false),
      'dark': _createIronManTheme(true),
    },
    'elsa_frozen': {
      'light': _createElsaTheme(false),
      'dark': _createElsaTheme(true),
    },
    'spider_man': {
      'light': _createSpiderManTheme(false),
      'dark': _createSpiderManTheme(true),
    },
    'winnie_pooh': {
      'light': _createPoohTheme(false),
      'dark': _createPoohTheme(true),
    },
    'mickey_mouse': {
      'light': _createMickeyTheme(false),
      'dark': _createMickeyTheme(true),
    },
  };

  static ThemeData _createSherlockTheme(bool isDark) {
    final baseTheme = isDark ? darkTheme : lightTheme;
    const primaryColor = Color(0xFF8D6E63);

    return baseTheme.copyWith(
      primaryColor: primaryColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: primaryColor,
        secondary: isDark ? const Color(0xFFBCAAA4) : const Color(0xFF6D4C41),
        surface: isDark ? const Color(0xFF1A1412) : const Color(0xFFFAF8F6),
        background: isDark ? const Color(0xFF0D0B0A) : const Color(0xFFFFFBF8),
      ),
      scaffoldBackgroundColor: isDark
          ? const Color(0xFF0D0B0A)
          : const Color(0xFFFFFBF8),
      appBarTheme: AppBarTheme(
        backgroundColor: isDark
            ? const Color(0xFF1A1412)
            : const Color(0xFF5D4037),
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 2,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: isDark ? const Color(0xFF1F1B18) : const Color(0xFFF5F5DC),
        elevation: isDark ? 8 : 4,
        shadowColor: isDark ? primaryColor.withOpacity(0.2) : Colors.black12,
        surfaceTintColor: isDark ? primaryColor.withOpacity(0.05) : null,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          side: isDark
              ? BorderSide(color: primaryColor.withOpacity(0.1))
              : BorderSide.none,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isDark ? const Color(0xFF1A1412) : null,
        selectedItemColor: primaryColor,
        unselectedItemColor: isDark ? Colors.grey[400] : Colors.grey,
        elevation: isDark ? 16 : 8,
      ),
    );
  }

  static ThemeData _createPeppaTheme(bool isDark) {
    final baseTheme = isDark ? darkTheme : lightTheme;
    const primaryColor = Color(0xFFE91E63);

    return baseTheme.copyWith(
      primaryColor: primaryColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: primaryColor,
        secondary: isDark ? const Color(0xFFFF80AB) : const Color(0xFFC2185B),
        surface: isDark ? const Color(0xFF1A0E14) : const Color(0xFFFDF7FA),
        background: isDark ? const Color(0xFF0F070A) : const Color(0xFFFFFAFC),
      ),
      scaffoldBackgroundColor: isDark
          ? const Color(0xFF0F070A)
          : const Color(0xFFFFFAFC),
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? const Color(0xFF1A0E14) : primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 2,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: isDark ? const Color(0xFF1F0B15) : const Color(0xFFFCE4EC),
        elevation: isDark ? 8 : 4,
        shadowColor: isDark ? primaryColor.withOpacity(0.2) : Colors.black12,
        surfaceTintColor: isDark ? primaryColor.withOpacity(0.05) : null,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          side: isDark
              ? BorderSide(color: primaryColor.withOpacity(0.1))
              : BorderSide.none,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isDark ? const Color(0xFF1A0E14) : null,
        selectedItemColor: primaryColor,
        unselectedItemColor: isDark ? Colors.grey[400] : Colors.grey,
        elevation: isDark ? 16 : 8,
      ),
    );
  }

  static ThemeData _createDoraTheme(bool isDark) {
    final baseTheme = isDark ? darkTheme : lightTheme;
    const primaryColor = Color(0xFFFF9800);

    return baseTheme.copyWith(
      primaryColor: primaryColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: primaryColor,
        secondary: isDark ? const Color(0xFFFFCC80) : const Color(0xFFF57C00),
        surface: isDark ? const Color(0xFF1A1300) : const Color(0xFFFFF8E1),
        background: isDark ? const Color(0xFF0F0A00) : const Color(0xFFFFFBF0),
      ),
      scaffoldBackgroundColor: isDark
          ? const Color(0xFF0F0A00)
          : const Color(0xFFFFFBF0),
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? const Color(0xFF1A1300) : primaryColor,
        foregroundColor: isDark ? Colors.white : Colors.black87,
        elevation: 0,
        scrolledUnderElevation: 2,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: isDark ? const Color(0xFF1F1500) : const Color(0xFFFFF3E0),
        elevation: isDark ? 8 : 4,
        shadowColor: isDark ? primaryColor.withOpacity(0.2) : Colors.black12,
        surfaceTintColor: isDark ? primaryColor.withOpacity(0.05) : null,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          side: isDark
              ? BorderSide(color: primaryColor.withOpacity(0.1))
              : BorderSide.none,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isDark ? const Color(0xFF1A1300) : null,
        selectedItemColor: primaryColor,
        unselectedItemColor: isDark ? Colors.grey[400] : Colors.grey,
        elevation: isDark ? 16 : 8,
      ),
    );
  }

  static ThemeData _createIronManTheme(bool isDark) {
    final baseTheme = isDark ? darkTheme : lightTheme;
    const primaryColor = Color(0xFFD32F2F);

    return baseTheme.copyWith(
      primaryColor: primaryColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: primaryColor,
        secondary: isDark ? const Color(0xFFFFD54F) : const Color(0xFFC62828),
        surface: isDark ? const Color(0xFF1A0808) : const Color(0xFFFFFAFA),
        background: isDark ? const Color(0xFF0F0404) : const Color(0xFFFFFEFE),
      ),
      scaffoldBackgroundColor: isDark
          ? const Color(0xFF0F0404)
          : const Color(0xFFFFFEFE),
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? const Color(0xFF1A0808) : primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 2,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: isDark ? const Color(0xFF1F0A0A) : const Color(0xFFFFEBEE),
        elevation: isDark ? 8 : 4,
        shadowColor: isDark ? primaryColor.withOpacity(0.3) : Colors.black12,
        surfaceTintColor: isDark ? primaryColor.withOpacity(0.05) : null,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          side: isDark
              ? BorderSide(color: primaryColor.withOpacity(0.2))
              : BorderSide.none,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isDark ? const Color(0xFF1A0808) : null,
        selectedItemColor: primaryColor,
        unselectedItemColor: isDark ? Colors.grey[400] : Colors.grey,
        elevation: isDark ? 16 : 8,
      ),
    );
  }

  static ThemeData _createElsaTheme(bool isDark) {
    final baseTheme = isDark ? darkTheme : lightTheme;
    const primaryColor = Color(0xFF2196F3);

    return baseTheme.copyWith(
      primaryColor: primaryColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: primaryColor,
        secondary: isDark ? const Color(0xFF81D4FA) : const Color(0xFF1976D2),
        surface: isDark ? const Color(0xFF0A1218) : const Color(0xFFF3F9FF),
        background: isDark ? const Color(0xFF050A0F) : const Color(0xFFFAFDFF),
      ),
      scaffoldBackgroundColor: isDark
          ? const Color(0xFF050A0F)
          : const Color(0xFFFAFDFF),
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? const Color(0xFF0A1218) : primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 2,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: isDark ? const Color(0xFF0F1419) : const Color(0xFFE3F2FD),
        elevation: isDark ? 8 : 4,
        shadowColor: isDark ? primaryColor.withOpacity(0.2) : Colors.black12,
        surfaceTintColor: isDark ? primaryColor.withOpacity(0.05) : null,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          side: isDark
              ? BorderSide(color: primaryColor.withOpacity(0.1))
              : BorderSide.none,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isDark ? const Color(0xFF0A1218) : null,
        selectedItemColor: primaryColor,
        unselectedItemColor: isDark ? Colors.grey[400] : Colors.grey,
        elevation: isDark ? 16 : 8,
      ),
    );
  }

  static ThemeData _createSpiderManTheme(bool isDark) {
    final baseTheme = isDark ? darkTheme : lightTheme;
    const primaryColor = Color(0xFFE53935);

    return baseTheme.copyWith(
      primaryColor: primaryColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: primaryColor,
        secondary: isDark ? const Color(0xFF2196F3) : const Color(0xFFD32F2F),
        surface: isDark ? const Color(0xFF1A0606) : const Color(0xFFFFFAFA),
        background: isDark ? const Color(0xFF0F0303) : const Color(0xFFFFFEFE),
      ),
      scaffoldBackgroundColor: isDark
          ? const Color(0xFF0F0303)
          : const Color(0xFFFFFEFE),
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? const Color(0xFF1A0606) : primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 2,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: isDark ? const Color(0xFF1F0808) : const Color(0xFFFFEBEE),
        elevation: isDark ? 8 : 4,
        shadowColor: isDark ? primaryColor.withOpacity(0.3) : Colors.black12,
        surfaceTintColor: isDark ? primaryColor.withOpacity(0.05) : null,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          side: isDark
              ? BorderSide(color: primaryColor.withOpacity(0.2))
              : BorderSide.none,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isDark ? const Color(0xFF1A0606) : null,
        selectedItemColor: primaryColor,
        unselectedItemColor: isDark ? Colors.grey[400] : Colors.grey,
        elevation: isDark ? 16 : 8,
      ),
    );
  }

  static ThemeData _createPoohTheme(bool isDark) {
    final baseTheme = isDark ? darkTheme : lightTheme;
    const primaryColor = Color(0xFFFFC107);

    return baseTheme.copyWith(
      primaryColor: primaryColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: primaryColor,
        secondary: isDark ? const Color(0xFFFF8A65) : const Color(0xFFFF8F00),
        surface: isDark ? const Color(0xFF1A1600) : const Color(0xFFFFF9C4),
        background: isDark ? const Color(0xFF0F0C00) : const Color(0xFFFFFDE7),
      ),
      scaffoldBackgroundColor: isDark
          ? const Color(0xFF0F0C00)
          : const Color(0xFFFFFDE7),
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? const Color(0xFF1A1600) : primaryColor,
        foregroundColor: isDark ? Colors.white : Colors.black87,
        elevation: 0,
        scrolledUnderElevation: 2,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: isDark ? const Color(0xFF1F1800) : const Color(0xFFFFF8E1),
        elevation: isDark ? 8 : 4,
        shadowColor: isDark ? primaryColor.withOpacity(0.2) : Colors.black12,
        surfaceTintColor: isDark ? primaryColor.withOpacity(0.05) : null,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          side: isDark
              ? BorderSide(color: primaryColor.withOpacity(0.1))
              : BorderSide.none,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isDark ? const Color(0xFF1A1600) : null,
        selectedItemColor: primaryColor,
        unselectedItemColor: isDark ? Colors.grey[400] : Colors.grey,
        elevation: isDark ? 16 : 8,
      ),
    );
  }

  static ThemeData _createMickeyTheme(bool isDark) {
    final baseTheme = isDark ? darkTheme : lightTheme;
    const primaryColor = Color(0xFFFF1744);

    return baseTheme.copyWith(
      primaryColor: primaryColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: primaryColor,
        secondary: isDark ? const Color(0xFFFFC107) : const Color(0xFFE91E63),
        surface: isDark ? const Color(0xFF1A0509) : const Color(0xFFFFF8FA),
        background: isDark ? const Color(0xFF0F0305) : const Color(0xFFFFFCFD),
      ),
      scaffoldBackgroundColor: isDark
          ? const Color(0xFF0F0305)
          : const Color(0xFFFFFCFD),
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? const Color(0xFF1A0509) : primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 2,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: isDark ? const Color(0xFF1F070B) : const Color(0xFFFFEBEE),
        elevation: isDark ? 8 : 4,
        shadowColor: isDark ? primaryColor.withOpacity(0.2) : Colors.black12,
        surfaceTintColor: isDark ? primaryColor.withOpacity(0.05) : null,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          side: isDark
              ? BorderSide(color: primaryColor.withOpacity(0.1))
              : BorderSide.none,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isDark ? const Color(0xFF1A0509) : null,
        selectedItemColor: primaryColor,
        unselectedItemColor: isDark ? Colors.grey[400] : Colors.grey,
        elevation: isDark ? 16 : 8,
      ),
    );
  }

  static ThemeData getThemeForCharacter(String characterId, bool isDark) {
    final characterTheme = characterThemes[characterId];
    if (characterTheme != null) {
      return characterTheme[isDark ? 'dark' : 'light'] ??
          (isDark ? darkTheme : lightTheme);
    }
    return isDark ? darkTheme : lightTheme;
  }
}
