import 'package:flutter/material.dart';

class AppHelper {
  static IconData getIconFromName(String name) {
    Map iconsMap = {
      'location_on': Icons.location_on,
      'search': Icons.search,
      'shopping_cart': Icons.shopping_cart,
      'favorite': Icons.favorite,
      'settings': Icons.settings,
      'home': Icons.home,
      'person': Icons.person,
      'notifications': Icons.notifications,
      'star': Icons.star,
      'check_circle': Icons.check_circle,
      'arrow_back': Icons.arrow_back,
      'arrow_forward': Icons.arrow_forward,
      'edit': Icons.edit,
      'delete': Icons.delete,
      'info': Icons.info,
      'lock': Icons.lock,
      'logout': Icons.logout,
      'help': Icons.help,
      // Add more as needed...
    };
    return iconsMap[name] ?? Icons.help;
  }

  static Color hexToColor(String hexString) {
    try {
      final s = hexString.trim();
      if (!s.startsWith('#') || (s.length != 7 && s.length != 9)) {
        return Colors.black; // default fallback
      }
      // Support #RRGGBB and #AARRGGBB
      if (s.length == 7) {
        return Color(int.parse(s.substring(1, 7), radix: 16) + 0xFF000000);
      } else {
        return Color(int.parse(s.substring(1, 9), radix: 16));
      }
    } catch (_) {
      return Colors.black;
    }
  }
}
