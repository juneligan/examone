import 'package:examone/item/item_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cart_service.dart';

class UserPreferences {

  static final UserPreferences _instance = UserPreferences._ctor();
  factory UserPreferences() {
    return _instance;
  }

  UserPreferences._ctor();

  SharedPreferences _sharedPreferences;
  CartService _cartService;
  ItemService _itemService;

  init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _itemService = ItemService(_sharedPreferences);
    _cartService = CartService(_sharedPreferences, _itemService);
  }

  get preferences {
    return _sharedPreferences;
  }

  get cartService {
    return _cartService;
  }

  get itemService {
    return _itemService;
  }

  get data {
    return _sharedPreferences.getString('data') ?? '';
  }

  Future setData(String value) {
    return _sharedPreferences.setString('data', value);
  }
}
