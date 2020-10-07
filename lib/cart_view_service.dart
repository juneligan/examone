import 'dart:async';

import 'package:examone/cart_event.dart';
import 'package:examone/cart_items_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'cart.dart';
import 'cart_service.dart';
import 'inherited_injection.dart';

class CartViewService {



  static Widget getListView(List<Cart> carts, CartService cartService, StreamController<CartEvent> streamController) {

    var listView2  = ListView.builder(
      itemCount: carts.length,
      itemBuilder: (context, index) {
        Cart cart = carts[index];
        return ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text(cart.getName()),
            subtitle: Text("Items for the kitchen"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
//                    cartService.deleteCart(cart);
                    streamController.add(CartEvent.buildRemovedEvent(cart));
                  } )
              ]
            ),
            onTap: () {
              debugPrint('TEEEEEEEEEEEEEEEEEEEST');
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => ItemsScreen(cart: cart)));
            },
        );
      },
    );
    return listView2;
  }
}
