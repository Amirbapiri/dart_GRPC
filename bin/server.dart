import 'package:grpc/grpc.dart';
import 'package:grpc_server/grpc_server.dart';

class GroceriesService extends GroceriesServiceBase {
  @override
  Future<Category> createCategory(ServiceCall call, Category category) async {
    return categoriesServices.createCategory(category)!;
  }

  @override
  Future<Item> createItem(ServiceCall call, Item request) async {
    return itemsServices.createItem(request)!;
  }

  @override
  Future<Empty> deleteCategory(ServiceCall call, Category request) async {
    return categoriesServices.deleteCategory(request)!;
  }

  @override
  Future<Empty> deleteItem(ServiceCall call, Item request) async {
    itemsServices.deleteItem(request);
    return Empty();
  }

  @override
  Future<Category> editCategory(ServiceCall call, Category request) async {
    final Category cat = categoriesServices.editCategory(request)!;
    return cat;
  }

  @override
  Future<Item> editItem(ServiceCall call, Item request) async {
    final Item item = itemsServices.editItem(request)!;
    return item;
  }

  @override
  Future<Categories> getAllCategories(ServiceCall call, Empty request) async {
    return Categories()..categories.addAll(categoriesServices.getCategories()!);
  }

  @override
  Future<Items> getAllItems(ServiceCall call, Empty request) async {
    return Items()..items.addAll(itemsServices.getItems()!);
  }

  @override
  Future<Category> getCategory(ServiceCall call, Category request) async {
    return categoriesServices.getCategoryByName(request.name)!;
  }

  @override
  Future<Item> getItem(ServiceCall call, Item request) async {
    return itemsServices.getItemByName(request.name)!;
  }

  @override
  Future<AllItemsOfCategory> getItemsByCategory (
      ServiceCall call, Category request)  async {
    return AllItemsOfCategory(
      items: itemsServices.getItemsByCategory(request.id),
      categoryId: request.id,
    );

  }
}

Future<void> main() async {
  final server = Server(
    [GroceriesService()],
    const <Interceptor>[],
    CodecRegistry(codecs: [
      GzipCodec(),
      IdentityCodec(),
    ]),
  );
  await server.serve(port: 50000);
  print("Server started listening on port: ${server.port}");
}
