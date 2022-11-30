import 'dart:io';
import 'dart:math';

import 'package:grpc/grpc.dart';
import 'package:grpc_server/src/generated/groceries.pbgrpc.dart';

class Client {
  ClientChannel? channel;
  GroceriesServiceClient? stub;
  var response;
  bool executionInProgress = true;

  Future<void> main() async {
    //Server's listening on port 50000
    channel = ClientChannel(
      "localhost",
      port: 50000,
      options: const ChannelOptions(
        credentials: ChannelCredentials.insecure(),
      ),
    );
    stub = GroceriesServiceClient(
      channel!,
      options: CallOptions(
        timeout: Duration(seconds: 30),
      ),
    );

    while (executionInProgress) {
      try {
        print("----- Welcome to this dummy CMD API -----");
        print("------Believe me, you're the only one using it 😆 ------");
        print("----------------------------------------------------------");
        print("---- What do you want to do? ----");
        print("🔸1: View all products");
        print("🔸2: Add new product");
        print("🔸3: Edit product");
        print("🔸4: Get product");
        print("🔸5: Delete product \n");
        print("🔸6: View all categories");
        print("🔸7: Add new category");
        print("🔸8: Edit category");
        print("🔸9: Get category");
        print("🔸10: Delete category \n");
        print("🔸11: Get all products of given category");

        var option = int.parse(stdin.readLineSync()!);
        switch (option) {
          case 1:
            final Items response = await stub!.getAllItems(Empty());
            print("---- Store products ----");
            for (var item in response.items) {
              print(
                  "✅: ${item.name} (id: ${item.id}) | categoryId: ${item.categoryId}");
            }
            break;
          case 2:
            print("Enter product name: ");
            String name = stdin.readLineSync()!;
            var item = await _findItemByName(name);
            if (item.id != 0) {
              print("❌ product already exists.");
            } else {
              print("Enter product's category name: ");
              String catName = stdin.readLineSync()!;
              final Category category = await _findCategoryByName(catName);

              if (category.id == 0) {
                print(
                    "❌ Category doesn't exist. Try create the category first.");
              } else {
                item = Item()
                  ..name = name
                  ..id = _randomId()
                  ..categoryId = category.id;
                response = await stub!.createItem(item);
                print("✅ Product has been added.");
              }
            }
            break;
          case 3:
            print("Enter product name");
            String name = stdin.readLineSync()!;
            final Item item = await _findItemByName(name);
            if (item.id != 0) {
              print("Enter new name for it: ");
              String newProductName = stdin.readLineSync()!;
              item.name = newProductName;
              final Item response = await stub!.editItem(item);
              if (response.name == item.name) {
                print(
                    "✅ Product updated: name ${response.name} (id: ${response.id})");
              } else {
                print(
                    "❌ Failure in updating the product with the given name: $name");
              }
            } else {
              print("❌ product doesn't exist. Try creating it.");
            }
            break;
          case 4:
            print("Enter product name");
            String name = stdin.readLineSync()!;
            final Item item = await _findItemByName(name);
            if (item.id != 0) {
              print("✅ product found | name ${item.name}");
            } else {
              print("❌ product doesn't exist. Try creating it.");
            }
            break;
          case 5:
            print("Enter product name: ");
            var name = stdin.readLineSync()!;
            final Item item = await _findItemByName(name);
            if (item.id != 0) {
              await stub!.deleteItem(item);
              print("✅ product deleted | name ${item.name}");
            } else {
              print("❌ product doesn't exist. Try creating it maybe.");
            }
            break;
          case 6:
            Categories response = await stub!.getAllCategories(Empty());
            print("---- Store categories ----");
            for (var category in response.categories) {
              print("⚡: ${category.name} (id: ${category.id})");
            }
            break;
          case 7:
            print("Enter category name: ");
            var name = stdin.readLineSync()!;
            var category = await _findCategoryByName(name);
            if (category.id != 0) {
              print(
                  "⛔ Category already exists: category ${category.name} (id: ${category.id})");
            } else {
              category = Category()
                ..id = _randomId()
                ..name = name;
              response = await stub!.createCategory(category);
              print(
                  "✅ Category created: name ${category.name} (id: ${category.id})");
            }
            break;
          case 8:
            print("Enter category name: ");
            var name = stdin.readLineSync()!;
            final Category category = await _findCategoryByName(name);
            if (category.id != 0) {
              print("Enter new name for it: ");
              var newName = stdin.readLineSync()!;
              category.name = newName;
              final Category response = await stub!.editCategory(category);
              if (response.name == category.name) {
                print(
                    "✅ Category updated: name ${response.name} (id: ${response.id})");
              } else {
                print("⛔ Category modification failed 😭");
              }
            } else {
              print("⛔ No category found with the given name: $name");
            }
            break;
          case 9:
            print("Enter the category name ");
            var name = stdin.readLineSync()!;
            var category = await _findCategoryByName(name);
            if (category.id != 0) {
              print(
                  "✅ Category found | name ${category.name} id ${category.id}");
            } else {
              print("⛔ No category found with the given name: $name");
            }
            break;
          case 10:
            print("Enter the category name ");
            var name = stdin.readLineSync()!;
            var category = await _findCategoryByName(name);
            if (category.id != 0) {
              await stub!.deleteCategory(category);
              print("✅ Category deleted");
            } else {
              print("⛔ No category found with the given name: $name");
            }
            break;
          case 11:
            print("Enter category name to see its products: ");
            var name = stdin.readLineSync()!;
            var category = await _findCategoryByName(name);
            if (category.id != 0) {
              var result = await stub!.getItemsByCategory(category);
              print("---- all products for the $name category ----");
              for (var item in result.items) {
                print(
                    "✅: ${item.name} (id: ${item.id}) | categoryId: ${item.categoryId}");
              }
            } else {
              print("⛔ No category found with the given name: $name");
            }
            break;
          default:
            print("Why did you enter an invalid option? 🥺");
        }
      } catch (e) {
        print(e);
      }

      print("Do you want to exit the store? (Y/n)");
      var result = stdin.readLineSync()?.toLowerCase() ?? "y";
      executionInProgress = result != "y";
    }

    await channel!.shutdown();
  }

  Future<Category> _findCategoryByName(String name) async {
    var category = Category()..name = name;
    category = await stub!.getCategory(category);
    return category;
  }

  Future<Item> _findItemByName(String name) async {
    var item = Item()..name = name;
    item = await stub!.getItem(item);
    return item;
  }

  int _randomId() => Random(1000).nextInt(9999);
}

void main() {
  final client = Client();
  client.main();
}
