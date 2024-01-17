import 'package:shopping_list_app/data/categories.dart';

import 'category_model.dart';

class GroceryItem {
  const GroceryItem(
      {required this.id,
      required this.name,
      required this.quantity,
      required this.category});
  final String id;
  final String name;
  final int quantity;
  final Category category;
  factory GroceryItem.fromJson(String key, Map<String, dynamic> json) {
    return GroceryItem(
      id: key,
      name: json['name'],
      quantity: json['quantity'],
      category: categories.entries
          .firstWhere(
              (element) => element.value.categoryName == json['category'])
          .value,
    );
  }
  static List<GroceryItem> listFromJson(Map<String, dynamic> jsonList) {
    List<GroceryItem> newList = [];
    jsonList.forEach((key, value) {
      newList.add(GroceryItem.fromJson(key, value));
    });
    return newList;
  }
}
