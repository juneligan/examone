import 'dart:convert';

import 'package:examone/cart.dart';
import 'package:examone/cart_service.dart';
import 'package:examone/item/Item.dart';
import 'package:examone/item/item_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}
class MockItemService extends Mock implements ItemService {}

void main() {
  final prefs = MockSharedPreferences();
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

    test('putTheItemToYour should increment the item sequence id', () async {
      given:
      Cart cart = Cart.build(21, 'cart_name_21');
      Item item = Item.build(10, 'item_10');

      List<String> existingStringItems = ['{"id":1,"name":"item_1st"}',
                                          '{"id":3,"name":"item_3rd"}',
                                          '{"id":5,"name":"item_5th"}'];

      when(prefs.getStringList('cart_21_items')).thenAnswer((e) => existingStringItems);

      when:
      service.putTheItemToYour(cart, item);

      then:
      verify(itemService.incrementCartSequenceId()).called(1);
    });

    test('putTheItemToYour should put the item to the cart', () async {
      given:
      Cart cart = Cart.build(2, 'cart_name_2');
      Item item = Item.build(10, 'item_10');
      String itemString = jsonEncode(item.toJson());

      List<String> existingStringItems = [
                        '{"id":1,"name":"item_1st"}',
                        '{"id":3,"name":"item_3rd"}',
                        '{"id":5,"name":"item_5th"}'];

      List<String> expectedStringItems = [...existingStringItems, itemString];

      when(prefs.getStringList('cart_2_items')).thenAnswer((e) => existingStringItems);


      when:
      service.putTheItemToYour(cart, item);

      then:
      verify(prefs.setStringList('cart_2_items', expectedStringItems)).called(1);
    });

    test('getAllItemsFrom should return list of item objects', () async {
      given:
      Cart cart = Cart.build(2, 'cart_name_2');

      List<String> existingStringItems = [
                        '{"id":1,"name":"item_1st"}',
                        '{"id":3,"name":"item_3rd"}',
                        '{"id":5,"name":"item_5th"}'];

      when(prefs.getStringList('cart_2_items')).thenAnswer((e) => existingStringItems);
      when(itemService.buildFrom(existingStringItems[0])).thenAnswer((e) => Item.build(1, 'item_1st'));
      when(itemService.buildFrom(existingStringItems[1])).thenAnswer((e) => Item.build(3, 'item_3rd'));
      when(itemService.buildFrom(existingStringItems[2])).thenAnswer((e) => Item.build(5, 'item_5th'));

      when:
      List<Item> items = service.getAllItemsFrom(cart);

      then:
      expect(items.length, 3);
      expect(items[0].getId(), 1);
      expect(items[0].getName(), 'item_1st');
      expect(items[1].getId(), 3);
      expect(items[1].getName(), 'item_3rd');
      expect(items[2].getId(), 5);
      expect(items[2].getName(), 'item_5th');
    });

    test('getAllItemsFrom should return empty list if the cart has 0 items in the list', () async {
      given:
      Cart cart = Cart.build(2, 'cart_name_2');

      List<String> existingStringItems = [
                        '{"id":1,"name":"item_1st"}',
                        '{"id":3,"name":"item_3rd"}',
                        '{"id":5,"name":"item_5th"}'];

      when(prefs.getStringList('cart_2_items')).thenAnswer((e) => null);
      when(itemService.buildFrom(existingStringItems[0])).thenAnswer((e) => Item.build(1, 'item_1st'));
      when(itemService.buildFrom(existingStringItems[1])).thenAnswer((e) => Item.build(3, 'item_3rd'));
      when(itemService.buildFrom(existingStringItems[2])).thenAnswer((e) => Item.build(5, 'item_5th'));

      when:
      List<Item> items = service.getAllItemsFrom(cart);

      then:
      expect(items.length, 0);
    });

  });
}
