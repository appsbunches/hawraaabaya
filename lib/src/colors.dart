import 'package:entaj/src/app_config.dart';
import 'package:flutter/material.dart';

/// Main - Header
const headerBackgroundColor = Color(0xffffffff);
const headerForegroundColor = Color(0xff000000);
const headerLogoColor = null;

/// Main - Bottom Navigation
final bottomBackgroundColor = HexColor.fromHex('#FFFFFF');
final bottomSelectedIconColor = primaryColor;
final bottomUnselectedIconColor = HexColor.fromHex('#9FA4B2');

/// Authentication
final authButtonColor = primaryColor;
final authTextButtonColor = HexColor.fromHex('#ffffff');
final authBackgroundColor = HexColor.fromHex('#eeeeee');
final authForegroundAppbarColor = HexColor.fromHex('#000000');
final authBackgroundAppbarColor = HexColor.fromHex('#ffffff');

/// Categories
const categoryBackgroundColor = Colors.white;
const categoryTextColor = Colors.black;
const categoryHomeBackgroundColor = Colors.white;
const categoryHomeTextColor = Colors.black;
const categoryProductDetailsBackgroundColor = Color(0xffD8F2E2);
const categoryProductDetailsTextColor = Color(0xff233668);
/// DropDown
const dropdownColor = Colors.grey;
const dropdownTextColor = Colors.white;
final dropdownDividerLineColor = Colors.grey.shade700;
///Prices
const formattedSalePriceTextColor = Colors.black;
const formattedPriceTextColorWithSale = moveColor;
const formattedPriceTextColorWithoutSale = Colors.black;
/// Buttons
//Login
const buttonBackgroundLoginColor =
    AppConfig.showButtonWithBorder ? Colors.white : primaryColor;
const buttonTextLoginColor =
    AppConfig.showButtonWithBorder ? primaryColor : Colors.white;
//Checkout
const buttonBackgroundCheckoutColor =
    AppConfig.showButtonWithBorder ? Colors.white : primaryColor;
const buttonTextCheckoutColor =
    AppConfig.showButtonWithBorder ? primaryColor : Colors.white;
//Coupon
const buttonBackgroundCouponColor =
    AppConfig.showButtonWithBorder ? Colors.white : primaryColor;
const buttonTextCouponColor =
    AppConfig.showButtonWithBorder ? primaryColor : Colors.white;
//Call
const buttonBackgroundCallColor = primaryColor;
const buttonTextCallColor = Colors.white;
//add to cart
const progressColor =
    AppConfig.showButtonWithBorder ? primaryColor : Colors.white;
const addToCartColor =
    !AppConfig.showButtonWithBorder ? primaryColor : Colors.white;
const textAddToCartColor =
    AppConfig.showButtonWithBorder ? primaryColor : Colors.white;
/// Home - Features
const featuresBackgroundColor = primaryColor;
const featuresForegroundColor = Colors.white;
/// Icons
const socialMediaIconColor = primaryColor;

// const primaryColor = Color.fromRGBO(123, 63, 85, 1.0);
const primaryColor = Color(0XFF9A474F);
const secondaryColor = Color.fromRGBO(132, 78, 53, 1.0);
const errorBackgroundColor = Color(0xFF616161);

const moveColor = Color.fromRGBO(234, 68, 60, 1.0);
const blueLightColor = Color.fromRGBO(179, 211, 218, 1.0);
const greenLightColor = primaryColor;
const yalowColor = Color.fromRGBO(255, 215, 80, 1.0);
final baseColor = Colors.grey.shade100;
final highlightColor = Colors.grey.shade300;
const blueLightSplashBackgroundColor = Color.fromRGBO(255, 255, 255, 1.0);

Map<int, Color> mapColor = {
  50: const Color.fromRGBO(51, 81, 76, .1),
  100: const Color.fromRGBO(51, 81, 76, .2),
  200: const Color.fromRGBO(51, 81, 76, .3),
  300: const Color.fromRGBO(51, 81, 76, .4),
  400: const Color.fromRGBO(51, 81, 76, .5),
  500: const Color.fromRGBO(51, 81, 76, .6),
  600: const Color.fromRGBO(51, 81, 76, .7),
  700: const Color.fromRGBO(51, 81, 76, .8),
  800: const Color.fromRGBO(51, 81, 76, .9),
  900: const Color.fromRGBO(51, 81, 76, 1),
};

MaterialColor mainColor = MaterialColor(0xFF33514C, mapColor);

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
