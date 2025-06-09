import 'package:shopping_list/models/category.dart';

class GroceryItem {
  final String id;
  final String title;
  final int quantity;
  final Category category;

  const GroceryItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.category,
  });
}