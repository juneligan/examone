import 'package:examone/cart_event_type.dart';
import 'package:flutter/material.dart';

import 'cart.dart';

class CartEvent {
  Cart cart;
  CartEventType type;

  CartEvent({this.cart, this.type});

  static CartEvent buildAddedEvent(Cart cart) {
    return CartEvent(cart: cart, type: CartEventType.ADDED_CART);
  }

  static CartEvent buildRemovedEvent(Cart cart) {
    return CartEvent(cart: cart, type: CartEventType.REMOVED_CART);
  }

  static CartEvent buildClickedEditName(Cart cart) {
    return CartEvent(cart: cart, type: CartEventType.CLICKED_EDIT_NAME);
  }
}
