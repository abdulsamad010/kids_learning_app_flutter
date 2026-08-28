import 'package:flutter/material.dart';
import 'features/content/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF6A1B9A),
      brightness: Brightness.light,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kids Learning App',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: const Color(0xFFF8F5FA),
        fontFamily: 'Roboto',
        visualDensity: VisualDensity.adaptivePlatformDensity,

        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
          displayMedium: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
          ),
          displaySmall: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
          ),
          headlineLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
          headlineMedium: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w700,
          ),
          headlineSmall: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w700,
          ),
          titleLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
          titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          titleSmall: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            height: 1.5,
          ),
          bodyMedium: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            height: 1.45,
          ),
          bodySmall: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            height: 1.4,
          ),
          labelLarge: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
          labelMedium: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          labelSmall: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),

        appBarTheme: AppBarTheme(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 8,
          shadowColor: colorScheme.primary.withValues(
            alpha: 0.35,
          ),
          surfaceTintColor: Colors.transparent,
          scrolledUnderElevation: 8,
          centerTitle: true,
          toolbarHeight: 68,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(36),
            ),
          ),
          iconTheme: IconThemeData(
            color: colorScheme.onPrimary,
            size: 27,
          ),
          actionsIconTheme: IconThemeData(
            color: colorScheme.onPrimary,
            size: 27,
          ),
          titleTextStyle: TextStyle(
            color: colorScheme.onPrimary,
            fontSize: 21,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.2,
          ),
        ),

        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 4,
          shadowColor: colorScheme.primary.withValues(
            alpha: 0.15,
          ),
          margin: EdgeInsets.zero,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            elevation: 3,
            shadowColor: colorScheme.primary.withValues(
              alpha: 0.3,
            ),
            minimumSize: const Size(0, 52),
            padding: const EdgeInsets.symmetric(
              horizontal: 22,
              vertical: 14,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: colorScheme.primary,
            minimumSize: const Size(0, 52),
            padding: const EdgeInsets.symmetric(
              horizontal: 22,
              vertical: 14,
            ),
            side: BorderSide(
              color: colorScheme.primary,
              width: 1.5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: colorScheme.primary,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        iconTheme: IconThemeData(
          color: colorScheme.primary,
          size: 28,
        ),

        listTileTheme: ListTileThemeData(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 8,
          ),
          minVerticalPadding: 10,
          iconColor: colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: colorScheme.outlineVariant,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: colorScheme.outlineVariant,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: colorScheme.primary,
              width: 2,
            ),
          ),
        ),

        chipTheme: ChipThemeData(
          backgroundColor: colorScheme.primaryContainer,
          selectedColor: colorScheme.primary,
          elevation: 1,
          pressElevation: 3,
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 7,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),

        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: colorScheme.primary,
          linearTrackColor: colorScheme.primaryContainer,
          circularTrackColor: colorScheme.primaryContainer,
          linearMinHeight: 10,
        ),

        dividerTheme: DividerThemeData(
          color: colorScheme.outlineVariant,
          thickness: 1,
          space: 20,
        ),

        dialogTheme: DialogThemeData(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),

        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 8,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(26),
            ),
          ),
        ),

        floatingActionButtonTheme:
        FloatingActionButtonThemeData(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),

        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          elevation: 5,
          backgroundColor: colorScheme.inverseSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentTextStyle: TextStyle(
            color: colorScheme.onInverseSurface,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),

        checkboxTheme: CheckboxThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}