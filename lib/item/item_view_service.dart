import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../cart.dart';
import '../cart_service.dart';
import '../dialog_service.dart';
import 'Item.dart';
import 'item_event.dart';

class ItemViewService {

  static Widget getListView(List<Item> items, Cart cart, StreamController<ItemEvent> streamController) {

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        Item item = items[index];
        return ListTile(
          leading: Icon(Icons.shopping_cart),
          title: Text(item.getName()),
          trailing: _getTrailingRowButtons(cart, item, context, streamController),
          onTap: () => debugPrint('ITEM DETAILS'),
        );
      },
    );
  }

  static Widget _getTrailingRowButtons(Cart cart, Item item, BuildContext context, StreamController<ItemEvent> streamController) {
    return Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _getEditNameButton(item, context, streamController),
          _getRemoveButton(item, streamController),
        ]
    );
  }
  
  static Widget _getRemoveButton(Item item, StreamController streamController) {

    return IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          streamController.add(ItemEvent.buildRemovedEvent(item));
        });
  }
  
  static Widget _getEditNameButton(Item item, BuildContext context, StreamController streamController) {

    return IconButton(
        icon: Icon(Icons.edit),
        onPressed: () => _showUpdateNameDialog(item, context, streamController)
    );
  }
  
  static _showUpdateNameDialog(Item item, BuildContext context, StreamController<ItemEvent> streamController) {
    DialogService.createAlertDialog(context, 'Your New Item Name', 'Update')
        .then((value) => streamController.add(ItemEvent.buildClickedEditNameEvent(Item.build(item.getId(), value))));
  }
}
