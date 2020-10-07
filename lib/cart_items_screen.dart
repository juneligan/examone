import 'dart:async';

import 'package:examone/item/item_event_type.dart';
import 'package:examone/item/item_service.dart';
import 'package:examone/user_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'cart.dart';
import 'cart_service.dart';
import 'dialog_service.dart';
import 'item/Item.dart';
import 'item/item_event.dart';
import 'item/item_view_service.dart';

class ItemsScreen extends StatefulWidget {
  final String title;
  final Cart cart;
  ItemsScreen({Key key, this.title, this.cart}) : super(key: key);

  @override
  _ItemsScreenState createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  StreamController<ItemEvent> streamController;
  CartService cartService;
  ItemService itemService;
  List<Item> items = [];
  Cart cart;

  @override
  void initState() {
    cart = widget.cart;
    streamController = StreamController.broadcast();
    cartService = UserPreferences().cartService;
    itemService = UserPreferences().itemService;
    items = cartService.getAllItemsFrom(cart);

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
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Your Cart\'s Items'),
      ),
      body: ItemViewService.getListView(items, cart, streamController),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddItemDialog(),
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

  void _handleEvent(ItemEvent event) {
    Item item = event.item;
    switch (event.type) {

      case ItemEventType.ADDED_ITEM:
        items.add(item);
        cartService.putTheItemToYour(cart, item);
        break;
      case ItemEventType.REMOVED_ITEM:
        items.removeWhere((e) => e.getId() == item.getId());
        cartService.throwAwayTheItemToThePersonNearYou(cart, item);
        break;
      case ItemEventType.CLICKED_EDIT:

        Item oldItem = items.firstWhere((e) => e.getId() == item.getId());
        cartService.updateItemName(cart, item, oldItem);
        int index = items.indexWhere((e) => e.getId() == item.getId());
        items.removeWhere((e) => e.getId() == item.getId());
        items.insert(index, item);
        break;
      default:
        break;
    }
  }

  void _saveCart(String name, StreamController<ItemEvent> streamController) {
    Item item = itemService.build(name);
    streamController.add(ItemEvent.buildAddedEvent(item));
  }

  void _showAddItemDialog() {
    DialogService.createAlertDialog(context, 'Your New Item', 'Save')
        .then((value) => _saveCart(value, streamController));
  }
}
