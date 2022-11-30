import 'package:grpc_server/grpc_server.dart';

abstract class ICategoriesServices {
  factory ICategoriesServices() => CategoriesServices();

  Category? getCategoryByName(String name) => null;

  Category? getCategoryById(int id) => null;

  Category? createCategory(Category category) => null;

  Category? editCategory(Category category) => null;

  Empty? deleteCategory(Category category) => null;

  List<Category>? getCategories() => null;
}

final categoriesServices = ICategoriesServices();
