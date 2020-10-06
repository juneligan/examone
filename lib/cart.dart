import 'item.dart';

class Cart {
  int id;
  String name;
  List<Item> items;

  Cart(int id, String name, List<Item> items) {
    this.id = id;
    this.name = name;
    this.items = items;
  }

  static build(int id, String name) {
    return new Cart(id, name, []);
  }

  String getName() {
    return this.name;
  }

  setItems(List<Item> items) {
    this.items = items;
  }

  addItem(Item item) {
    items.add(item);
  }

  removeItem(Item item) {
    items = items.where((e) => e.id != item.id);
    // should save
  }

  setName(String name) {
    this.name = name;
  }

  Map<String, dynamic> toJson() {
    final listOfStringItems = this.items.map((e) => e.toJson()).join(",");

    return {
        'id': this.id,
        'name': this.name,
        'items': listOfStringItems
      };
  }
//  static Cart fromJson(Map<String, dynamic> json) {
//      : name = json['name'],
//        age = json['age'],
//        location = json['location'];

  static Cart fromJson(Map<String, dynamic> json) {
    Cart cart = Cart.build(json['id'], json['name']);

  }

  getAllItems() {
    return items;
  }

}
