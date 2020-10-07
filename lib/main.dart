
import 'package:examone/cart_service.dart';
import 'package:examone/inherited_injection.dart';
import 'package:examone/user_preferences.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';

CartService cartService;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserPreferences().init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Basic List View',
        home: HomeScreen(title: 'Shopping Cart List',)
      );
  }
}
