import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../cart.dart';
import 'Item.dart';

class ItemService {
  final ITEM_SEQUENCE_ID_KEY = 'cartIdSequence';
  final ITEM_KEY = (cartId, itemId) => 'cart_${cartId}_item_$itemId';

  SharedPreferences _sharedPreferences;

  ItemService(SharedPreferences sharedPreferences) {
    _sharedPreferences = sharedPreferences;
  }

  get preferences {
    return _sharedPreferences;
  }

  Item build(String name) {
    int id = _getLatestId();
    return Item.build(id, name);
  }

  getItemsOf(Cart cart) {

  }

  removeItemFrom(Cart cart, Item item) {
    debugPrint("DELETING "+item.getName()+ "...");
    String cartKey = ITEM_KEY(cart.getId(), item.getId());
    _sharedPreferences.remove(cartKey);
  }

  saveItemTo(Cart cart, Item item) {
    String jsonString = jsonEncode(cart.toJson());

    String cartKey =  ITEM_KEY(cart.getId(), item.getId());
    _sharedPreferences.setString(cartKey, jsonString);
    incrementCartSequenceId();
  }

  List<Item> getAllItemsOfCart(Cart cart) {
    List<String> itemKeys = cart.geItemKeys();
    List<Item> items = itemKeys.isNotEmpty ?
    itemKeys.map((e) =>  _buildFrom(e))
            .where((item) => item.isNotNull()).toList() : [];
    return items;
  }

  Cart _buildFrom(String key) {
    Map<String, dynamic> itemMap = _getItemMap(key);
    return itemMap.isNotEmpty ? Item.fromJson(itemMap) : Item.empty();
  }

  Map<String, dynamic> _getItemMap(key) {
    String jsonString = _getItemString(key);
    return jsonString != null ? jsonDecode(jsonString) as Map<String, dynamic> : Map();
  }

  incrementCartSequenceId() {
    int id = _getLatestId();
    _sharedPreferences.setInt(ITEM_SEQUENCE_ID_KEY, (id + 1));
  }

  Item buildFrom(String itemString) {
    Map<String, dynamic> map = jsonDecode(itemString) as Map<String, dynamic>;
    return map.isNotEmpty ? Item.fromJson(map) : Item.empty();
  }

  String _getItemString(String key) {
    return _sharedPreferences.getString(key);
  }

  _getLatestId() {
    return _sharedPreferences.getInt(ITEM_SEQUENCE_ID_KEY) ?? 0;
  }

}
