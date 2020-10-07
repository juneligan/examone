import 'dart:async';

import 'package:examone/cart_event.dart';
import 'package:examone/cart_items_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'cart.dart';
import 'cart_service.dart';
import 'dialog_service.dart';

class CartViewService {

  static Widget getListView(List<Cart> carts, StreamController<CartEvent> streamController) {

    var listView2  = ListView.builder(
      itemCount: carts.length,
      itemBuilder: (context, index) {
        Cart cart = carts[index];
        return ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text(cart.getName()),
            trailing: _getTrailingRowButtons(cart, context, streamController),
            onTap: () => _navigateToCartItems(cart, context),
        );
      },
    );
    return listView2;
  }
  
  static _navigateToCartItems(Cart cart, BuildContext context) {
    debugPrint('YOUR CART ${cart.getName()} - ${cart.getId()}');
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => ItemsScreen(cart: cart)));
  }
  
  static Widget _getTrailingRowButtons(Cart cart, BuildContext context, StreamController<CartEvent> streamController) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _getEditNameButton(cart, context, streamController),
        _getRemoveButton(cart, streamController),
      ],
    );
  }
  
  static Widget _getRemoveButton(Cart cart, StreamController streamController) {

    return IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          streamController.add(CartEvent.buildRemovedEvent(cart));
        });
  }

  static Widget _getEditNameButton(Cart cart, BuildContext context, StreamController streamController) {

    return IconButton(
          icon: Icon(Icons.edit),
          onPressed: () => _showUpdateNameDialog(cart, context, streamController)
      );
  }

  static _showUpdateNameDialog(Cart cart, BuildContext context, StreamController streamController) {
    DialogService.createAlertDialog(context, 'Your New Cart Name', 'Update')
        .then((value) => streamController.add(CartEvent.buildClickedEditName(Cart.build(cart.getId(), value))));
  }
}
