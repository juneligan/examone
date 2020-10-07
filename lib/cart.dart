import 'dart:convert';

import 'item/Item.dart';

class Cart {
  int id;
  String name;
  List<String> itemKeys;

  Cart({this.id, this.name, this.itemKeys});

  static build(int id, String name) {
    return new Cart(id: id, name: name, itemKeys: []);
  }
  
  static empty() {
    return Cart(id: null, name: null, itemKeys: []);
  }
  
  bool isNull() {
    return this.id == null && name == null && itemKeys.isEmpty;
  }

  bool isNotNull() {
    return !isNull();
  }

  int getId() {
    return this.id;
  }

  String getName() {
    return this.name;
  }

  setName(String name) {
    this.name = name;
  }

  Map<String, dynamic> toJson() {
    final listOfStringItems = this.itemKeys.join(",");

    return {
        'id': this.id,
        'name': this.name,
        'items': this.itemKeys
      };
  }

  static Cart fromJson(Map<String, dynamic> json) {
   return Cart.build(json['id'], json['name']);
  }

  geItemKeys() {
    return this.itemKeys;
  }

}
