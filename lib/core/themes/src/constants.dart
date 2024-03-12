part of '../theme.dart';


const displayLarge = TextStyle(fontWeight: FontWeight.w700, fontSize: 16);
const displayMedium = TextStyle(fontWeight: FontWeight.w400, fontSize: 14);
const displaySmall = TextStyle(fontWeight: FontWeight.w400, fontSize: 10);

const labelLarge  = TextStyle(fontWeight: FontWeight.w400, fontSize: 16);
const labelMedium  = TextStyle(fontWeight: FontWeight.w400, fontSize: 14);
const labelSmall = TextStyle(fontWeight: FontWeight.w400, fontSize: 10);

abstract class AppColors {
  static const white = Colors.white;
  static const black = Colors.black;

  static const orange = Color(0xFFFF5500);
  static const orangeVariant = Color(0xFFE29D00);
  static const green = Color(0xFF3BB33B);

  static const red = Colors.red;

  // static const darkerRed = Color(0xFFCB5A5E);

  static const grey = Color(0xFF999999);
  static const darkerGrey = Color(0xFF6C6C6C);
  static const darkestGrey = Color(0xFF1D1D1D);



  // static const lighterGrey = Color(0xFF959595);
  static const lightGrey = Color(0xFFD2CCCB);

  // static const lighterDark = Color(0xFF272727);
  // static const lightDark = Color(0xFF1b1b1b);

}


 final a = ColorScheme.fromSeed(
            seedColor: const Color(0xFFEC612A),
            primary: const Color(0xFFEC612A),
            onPrimary: const Color(0xFFFFFFFF),
            secondary: const Color(0xFF262626),
            onSecondary: const Color(0xFF939393),
            background: const Color(0xFF000000),
            surface: const Color(0xFF121212),
          );