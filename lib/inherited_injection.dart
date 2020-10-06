import 'package:flutter/cupertino.dart';

class InheritedInjection extends InheritedWidget {
  final Widget child;

  InheritedInjection({Key key, this.child}) : super(key: key, child: child);

  static InheritedInjection of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(InheritedInjection) as InheritedInjection);
  }

  @override
  bool updateShouldNotify(InheritedInjection oldWidget) {
    return true;
  }

}
