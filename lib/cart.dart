import 'item.dart';

class Cart {
  int id;
  String name;
  List<Item> items;

  Cart(String name) {
    this.name = name;
    this.items = [];
  }

  static build(String name) {
    return new Cart(name);
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

  getAllItems() {
    return items;
  }

}
