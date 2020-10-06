import 'package:shared_preferences/shared_preferences.dart';

import 'cart_service.dart';

class App {
  static SharedPreferences localStorage;
  static CartService cartService;
  static Future init() async {
    localStorage = await SharedPreferences.getInstance();
    cartService = new CartService();
  }
}
