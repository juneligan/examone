import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cart.dart';
import 'item/Item.dart';
import 'item/item_service.dart';

class CartService {
  static final CART_SEQUENCE_ID_KEY = 'cartIdSequence';
  static final CART_KEY_PREFIX = 'cart_';
  static final CART_ITEMS_KEY_POSTFIX = '_items';

  SharedPreferences _sharedPreferences;
  ItemService _itemService;

  CartService(SharedPreferences sharedPreferences, ItemService itemService) {
    _sharedPreferences = sharedPreferences;
    _itemService = itemService;
  }

  get preferences {
    return _sharedPreferences;
  }

  build(String name) {
    int id = _getLatestId();
    return Cart.build(id, name);
  }

  throwAwayTheItemToThePersonNearYou(Cart cart, Item item) {
    String itemString = jsonEncode(item.toJson());

    List<String> stringItems = _getAllStringItemsFrom(cart);
    stringItems.add(itemString);

    stringItems.removeWhere((element) => element == itemString);

    String cartItemsKey = _getCartItemsKey(cart);
    _sharedPreferences.setStringList(cartItemsKey, stringItems);
  }

  throwItAllAwayToTheGuard(Cart cart) {
    String cartItemsKey = _getCartItemsKey(cart);
    _sharedPreferences.remove(cartItemsKey);
  }

  List<Item> getAllItemsFrom(Cart cart) {

    List<String> stringItems = _getAllStringItemsFrom(cart);
    List<Item> items = stringItems
        .map((item) => _itemService.buildFrom(item))
        .toList();

    return items;
  }

  putTheItemToYour(Cart cart, Item item) {
    String itemString = jsonEncode(item.toJson());

    List<String> stringItems = _getAllStringItemsFrom(cart);
    stringItems.add(itemString);

    String cartItemsKey = _getCartItemsKey(cart);
    _sharedPreferences.setStringList(cartItemsKey, stringItems);
    _itemService.incrementCartSequenceId();
  }

  updateItemName(Cart cart, Item item, Item oldItem) {
    String itemString = jsonEncode(item.toJson());
    String oldItemString = jsonEncode(oldItem.toJson());

    List<String> stringItems = _getAllStringItemsFrom(cart);
    int index = stringItems.indexWhere((e) => e == oldItemString);
    stringItems.removeWhere((e) => e == oldItemString);
    stringItems.insert(index, itemString);

    String cartItemsKey = _getCartItemsKey(cart);
    _sharedPreferences.setStringList(cartItemsKey, stringItems);
  }

  String _getCartItemsKey(Cart cart) {
    return CART_KEY_PREFIX + cart.getId().toString() + CART_ITEMS_KEY_POSTFIX;
  }

  List<String> _getAllStringItemsFrom(Cart cart) {

    String cartItemsKey = _getCartItemsKey(cart);
    List<String> stringItems = _sharedPreferences.getStringList(cartItemsKey);

    return stringItems != null ? stringItems : [];
  }

  deleteCart(Cart cart) {
    String cartKey = _buildCartKey(cart);
    _sharedPreferences.remove(cartKey);
    throwItAllAwayToTheGuard(cart);
  }

  saveCart(Cart cart) {
    String jsonString = jsonEncode(cart.toJson());

    String cartKey = _buildCartKey(cart);
    _sharedPreferences.setString(cartKey, jsonString);
    _incrementCartSequenceId();
  }

  updateCartName(Cart cart) {
    String cartKey = _buildCartKey(cart);
    String jsonString = jsonEncode(cart.toJson());
    _sharedPreferences.setString(cartKey, jsonString);
  }

  List<Cart> getAllCarts() {
    List<String> cartKeys = _getAllPossibleCartKeys();
    List<Cart> carts = cartKeys.map((e) =>  _buildFrom(e))
        .where((cart) => cart.isNotNull()).toList();
    return carts;
  }

  String _buildCartKey(Cart cart) {
    return CART_KEY_PREFIX + cart.getId().toString();
  }
  
  List<String> _getAllPossibleCartKeys() {
    int idSequence = _getLatestId();
    return List<String>.generate((idSequence + 1),
            (counter) => (CART_KEY_PREFIX + counter.toString()));
  }

  Cart _buildFrom(String key) {
    Map<String, dynamic> cartMap = _getCartMap(key);
    return cartMap.isNotEmpty ? Cart.fromJson(cartMap) : Cart.empty();
  }

  Map<String, dynamic> _getCartMap(key) {
    String jsonString = _getCartString(key);
    return jsonString != null ? jsonDecode(jsonString) as Map<String, dynamic> : Map();
  }

  String _getCartString(String key) {
    return _sharedPreferences.getString(key);
  }

  _getLatestId() {
    return _sharedPreferences.getInt(CART_SEQUENCE_ID_KEY) ?? 0;
  }

  _incrementCartSequenceId() {
    int id = _getLatestId();
    _sharedPreferences.setInt(CART_SEQUENCE_ID_KEY, (id + 1));
  }

}
