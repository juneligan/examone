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
  final ADD_ITEM_DIALOG_TEXT = 'Your Item Name';
  final BUTTON_SAVE_TEXT = 'Save';
  Cart cart;
  StreamController<ItemEvent> streamController;
  List<Item> items = [];
  CartService cartService;
  ItemService itemService;

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
        title: Text('ANAKA GIGIT 2'),
      ),
      body: ItemViewService.getListView(items, cart, cartService, streamController),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          DialogService.createAlertDialog(context, ADD_ITEM_DIALOG_TEXT, BUTTON_SAVE_TEXT)
              .then((value) => _saveCart(value, streamController));
        },
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
        cartService.saveItemTo(cart, item);
        break;
      case ItemEventType.REMOVED_ITEM:
        items.removeWhere((e) => e.getId() == item.getId());
        cartService.removeItemFrom(cart, item);
        break;
      case ItemEventType.CLICKED_EDIT:
      // TODO: Handle this case.
        break;
      default:
        break;
    }
  }

  void _saveCart(String name, StreamController<ItemEvent> streamController) {
    Item item = itemService.build(name);
    streamController.add(ItemEvent.buildAddedEvent(item));
  }
}
