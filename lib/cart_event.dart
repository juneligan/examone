import 'package:examone/cart_event_type.dart';
import 'package:flutter/material.dart';

import 'cart.dart';

class CartEvent {
  Cart cart;
  CartEventType type;

  CartEvent({this.cart, this.type});

  static CartEvent buildAddedEvent(Cart cart) {
    return CartEvent(cart: cart, type: CartEventType.CART_ADDED);
  }

  static CartEvent buildRemovedEvent(Cart cart) {
    return CartEvent(cart: cart, type: CartEventType.CART_REMOVED);
  }

  static CartEvent buildViewItemEvent(Cart cart, BuildContext context) {
    return CartEvent(cart: cart, type: CartEventType.CLICK_VIEW_CART_ITEMS);
  }
}
