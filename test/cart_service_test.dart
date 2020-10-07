import 'package:examone/cart.dart';
import 'package:examone/cart_service.dart';
import 'package:examone/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('saveCart should actually save the card in the shared preferences', () async {
    final prefs = await SharedPreferences.getInstance();

    final service = CartService(null, null);
    //given:
//    Cart cart = Cart.build('cart_1');

//    service.saveCart(cart);

//    verify(prefs.set('cart', cart.to)).called(1);
  });
}
