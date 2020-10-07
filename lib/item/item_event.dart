import 'Item.dart';
import 'item_event_type.dart';

class ItemEvent {
  Item item;
  ItemEventType type;
  
  ItemEvent({this.item, this.type});

  static build(Item item, ItemEventType type) {
    return ItemEvent(item: item, type: type);
  }

  static buildRemovedEvent(Item item) {
    return build(item, ItemEventType.REMOVED_ITEM);
  }

  static buildAddedEvent(Item item) {
    return build(item, ItemEventType.ADDED_ITEM);
  }

  static buildClickedEditEvent(Item item) {
    return build(item, ItemEventType.CLICKED_EDIT);
  }
  
}
