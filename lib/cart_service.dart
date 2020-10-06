import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cart.dart';

class CartService {

  SharedPreferences _sharedPreferences;

  CartService() {
    // TODO inject shared preferences
  }

  List<Cart> getAllCarts() {

//    final prefs = await SharedPreferences.getInstance();
    // TODO fetch carts json
    // TODO convert carts json to object

    return [
      Cart.build(1, 'cart 1'),
      Cart.build(2, 'cart 2'),
      Cart.build(3, 'cart 3')
    ];
  }

  getLatestId() {
    debugPrint(_sharedPreferences.toString());
    return _sharedPreferences.getInt('cartIdSequence') ?? 0;
  }

  getCart(Cart cart) {

  }

  deleteCart(Cart cart) {

  }

  saveCart(Cart cart) {

  }

}
