

class Item {
  int id;
  String name;
  String itemKey;

  Item({this.id, this.name, this.itemKey});

  static build(int id, String name) {
    return Item(id: id, name: name);
  }

  static empty() {
    return Item(id: null, name: null);
  }

  bool isNull() {
    return this.id == null && name == null;
  }

  bool isNotNull() {
    return !isNull();
  }

  int getId() {
    return this.id;
  }

  String getName() {
    return this.name;
  }

  remove(Item item) {
    // should save
  }

  setName(String name) {
    this.name = name;
  }

  Map<String, dynamic> toJson() {

    return {
      'id': this.id,
      'name': this.name,
    };
  }

  static Item fromJson(Map<String, dynamic> json) {
    return Item.build(json['id'], json['name']);
  }

}
