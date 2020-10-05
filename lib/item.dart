class Item {
  int id;
  String name;

  Item(String name) {
    this.name = name;
  }

  static build(String name) {
    return new Item(name);
  }

  Map<String, dynamic> toJson() => {
    'id': this.id,
    'name': this.name
  };
}
