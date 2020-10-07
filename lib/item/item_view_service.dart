import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../cart.dart';
import '../cart_service.dart';
import 'Item.dart';
import 'item_event.dart';
class ItemViewService {

  static Widget getListView(List<Item> items, Cart cart, CartService cartService, StreamController<ItemEvent> streamController) {

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        Item item = items[index];
        return ListTile(
          leading: Icon(Icons.shopping_cart),
          title: Text(item.getName()),
          trailing: getRow(cart, item, cartService, streamController),
          onTap: () => debugPrint('TEEEEEEEEEEEEEEEEEEEST'),
        );
      },
    );
  }

  static Widget getRow(Cart cart, Item item, CartService cartService, StreamController<ItemEvent> streamController) {
    return Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
//                cartService.removeItemFrom(cart, item); // TODO ipagawas sa top level
                streamController.add(ItemEvent.buildRemovedEvent(item));
              } )
        ]
    );
  }
}
