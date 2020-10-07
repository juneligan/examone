import 'package:examone/cart_view_service.dart';
import 'package:examone/dialog_service.dart';
import 'package:flutter/cupertino.dart';

import 'cart.dart';
import 'cart_service.dart';

class InheritedInjection extends InheritedWidget {
  final DialogService dialogService;
  final CartService cartService;
  final CartViewService cartViewService;
  final Widget child;
  final List<Cart> carts;

  InheritedInjection({Key key,
                      this.dialogService,
                      this.cartService,
                      this.cartViewService,
                      this.carts,
                      this.child}) : super(key: key, child: child);

  static InheritedInjection of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType();
  }

  @override
  bool updateShouldNotify(InheritedInjection oldWidget) {
    return true;
  }

}
