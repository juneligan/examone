import 'dart:convert';

import 'package:examone/cart.dart';
import 'package:examone/cart_service.dart';
import 'package:examone/item/item_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharePreferences extends Mock implements SharedPreferences {}
class MockItemService extends Mock implements ItemService {}

void main() {
  final prefs = MockSharePreferences();
  final itemService = MockItemService();
  final service = CartService(prefs, itemService);


  group('CartServiceSpec', () {
    test('saveCart should save the cart', () async {
      given:
      Cart cart = Cart.build(2, 'cart_name_1');
      String jsonString = jsonEncode(cart.toJson());
      String cartKey = CartService.CART_KEY_PREFIX + cart.getId().toString();

      when:
      service.saveCart(cart);

      then:
      verify(prefs.setString(cartKey, jsonString)).called(1);
    });

    test('saveCart should increment the cart sequence id after saving the cart', () async {
      given:
      Cart cart = Cart.build(2, 'cart_name_1');
      int latestCartId = 3;
      when(prefs.getInt(CartService.CART_SEQUENCE_ID_KEY)).thenAnswer((e) => latestCartId);

      when:
      service.saveCart(cart);

      then:
      verify(prefs.setInt(CartService.CART_SEQUENCE_ID_KEY, (latestCartId + 1))).called(1);
    });

    test('updateCartName should update the name of the cart', () async {
      given:
      Cart cart = Cart.build(2, 'cart_name_2');
      String jsonString = jsonEncode(cart.toJson());
      String cartKey = CartService.CART_KEY_PREFIX + cart.getId().toString();

      when:
      service.updateCartName(cart);

      then:
      verify(prefs.setString(cartKey, jsonString)).called(1);
    });

    test('getAllCarts should get all the carts with the possible keys from key 0 until the latest cart sequence id', () async {
      given:
      int latestCartId = 10;
      List<String>.generate(latestCartId + 1,
              (num) => (CartService.CART_KEY_PREFIX + num.toString()));

      and:
      when(prefs.getInt(CartService.CART_SEQUENCE_ID_KEY)).thenAnswer((e) => latestCartId);

      when:
      service.getAllCarts();

      then:
      verify(prefs.getString('cart_0')).called(1);
      verify(prefs.getString('cart_1')).called(1);
      verify(prefs.getString('cart_2')).called(1);
      verify(prefs.getString('cart_3')).called(1);
      verify(prefs.getString('cart_4')).called(1);
      verify(prefs.getString('cart_5')).called(1);
      verify(prefs.getString('cart_6')).called(1);
      verify(prefs.getString('cart_7')).called(1);
      verify(prefs.getString('cart_8')).called(1);
      verify(prefs.getString('cart_9')).called(1);
      verify(prefs.getString('cart_10')).called(1);
      verifyNever(prefs.getString('cart_11'));
    });

    test('getAllCarts should get all the carts with the possible keys from key 0 until the latest cart sequence id', () async {
      given:
      int latestCartId = 0;
      List<String>.generate(latestCartId + 1,
              (num) => (CartService.CART_KEY_PREFIX + num.toString()));

      and:
      when(prefs.getInt(CartService.CART_SEQUENCE_ID_KEY)).thenAnswer((e) => latestCartId);

      when:
      service.getAllCarts();

      then:
      verify(prefs.getString('cart_0')).called(1);
      verifyNever(prefs.getString('cart_1'));
    });

    test('getAllCarts should return empty list if non existent key', () async {
      given:
      int latestCartId = 0;
      List<String>.generate(latestCartId + 1,
              (num) => (CartService.CART_KEY_PREFIX + num.toString()));

      and:
      when(prefs.getString('cart_0')).thenAnswer((e) => null);

      then:
      expect(service.getAllCarts(), []);
    });

    test('getAllCarts should return list of carts', () async {
      given:
      Cart cart1 = Cart.build(2, 'cart_name_1');
      String jsonString1 = jsonEncode(cart1.toJson());
      Cart cart2 = Cart.build(3, 'cart_name_2');
      String jsonString2 = jsonEncode(cart2.toJson());
      int latestCartId = 3;
      List<String>.generate(latestCartId + 1,
              (num) => (CartService.CART_KEY_PREFIX + num.toString()));

      and:
      when(prefs.getInt(CartService.CART_SEQUENCE_ID_KEY)).thenAnswer((e) => latestCartId);
      when(prefs.getString('cart_2')).thenAnswer((e) => jsonString1);
      when(prefs.getString('cart_3')).thenAnswer((e) => jsonString2);

      when:
      List<Cart> carts = service.getAllCarts();

      then:
      expect(carts.first.getId(), cart1.getId());
      expect(carts.first.getName(), cart1.getName());

      and:
      expect(carts.last.getId(), cart2.getId());
      expect(carts.last.getName(), cart2.getName());
    });

    test('deleteCart should remove the cart', () async {
      given:
      Cart cart = Cart.build(3, 'cart_name_1');

      when:
      service.deleteCart(cart);

      then:
      verify(prefs.remove('cart_3')).called(1);
    });

    test('deleteCart should also remove the items of the cart', () async {
      given:
      Cart cart = Cart.build(2, 'cart_name_1');

      when:
      service.deleteCart(cart);

      then:
      verify(prefs.remove('cart_2_items')).called(1);
    });


    // TODO add cart item related method/functions
  });
}
