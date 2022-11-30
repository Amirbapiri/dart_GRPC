import 'package:grpc_server/grpc_server.dart';

class CategoriesServices implements ICategoriesServices {
  @override
  Category? createCategory(Category category) {
    categories.add({"id": category.id, "name": category.name});
    return category;
  }

  @override
  Empty? deleteCategory(Category category) {
    categories.removeWhere((element) => element["id"] == category.id);
    return Empty();
  }

  @override
  Category? editCategory(Category category) {
    try {
      var categoryIdx =
          categories.indexWhere((ctItem) => ctItem["id"] == category.id);
      categories[categoryIdx]["name"] = category.name;
    } catch (e) {
      print("❌ error: $e");
    }
    return category;
  }

  @override
  List<Category>? getCategories() {
    return categories.map((e) => helper.getCategoryFromMap(e)).toList();
  }

  @override
  Category? getCategoryById(int id) {
    var category = Category();
    var result = categories.where((element) => element["id"] == id).toList();
    if (result.isNotEmpty) {
      category = helper.getCategoryFromMap(result.first);
    }
    return category;
  }

  @override
  Category? getCategoryByName(String name) {
    var category = Category();
    var result =
        categories.where((element) => element["name"] == name).toList();
    if (result.isNotEmpty) {
      category = helper.getCategoryFromMap(result.first);
    }
    return category;
  }
}
