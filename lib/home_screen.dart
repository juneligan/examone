
import 'dart:async';

import 'package:examone/cart_event_type.dart';
import 'package:examone/user_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cart.dart';
import 'cart_event.dart';
import 'cart_service.dart';
import 'cart_view_service.dart';
import 'dialog_service.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  StreamController<CartEvent> streamController;
  List<Cart> carts = [];
  SharedPreferences sharedPreferences;
  CartService cartService;

  @override
  void initState() {

    streamController = StreamController.broadcast();
    cartService = UserPreferences().cartService;
    carts = cartService.getAllCarts();

    streamController.stream.listen((event) {
      setState(() {
        _handleEvent(event);
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: CartViewService.getListView(carts, streamController),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddCartDialog(),
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  void dispose() {
    super.dispose();
    streamController?.close();streamController = null;
  }

  void _handleEvent(CartEvent event) {

    Cart cart = event.cart;

    switch(event.type) {
      case CartEventType.ADDED_CART:
        cartService.saveCart(cart);
        carts.add(event.cart);
        break;
      case CartEventType.REMOVED_CART:
        cartService.deleteCart(cart);
        carts.removeWhere((item) => item.getId() == cart.getId());
        break;
      case CartEventType.CLICKED_EDIT_NAME:
        cartService.updateCartName(cart);
        int index = carts.indexWhere((item) => item.getId() == cart.getId());
        carts.removeWhere((item) => item.getId() == cart.getId());
        carts.insert(index, cart);
        break;
      default:
        break;
    }
  }

  void _saveCart(String name, StreamController<CartEvent> streamController) {
    if (name == null || name == '') {
      return;
    }
    Cart cart = cartService.build(name);
    streamController.add(CartEvent.buildAddedEvent(cart));
  }

  void _showAddCartDialog() {
    DialogService.createAlertDialog(context, 'Your Cart Name', 'Save')
        .then((value) => _saveCart(value, streamController));
  }
}





