import 'package:grpc_server/grpc_server.dart';

abstract class IItemsServices {
  factory IItemsServices() => ItemsServices();

  Item? getItemByName(String name) => null;

  Item? getItemById(int id) => null;

  Item? createItem(Item item) => null;

  Item? editItem(Item item) => null;

  Empty? deleteItem(Item item) => null;

  List<Item>? getItems() => null;

  List<Item>? getItemsByCategory(int categoryId) => null;
}

final itemsServices = IItemsServices();
