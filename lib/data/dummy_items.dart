import 'package:shopping_list/models/category.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/data/categories.dart';

final groceryItems = [
  GroceryItem(
      id: 'a',
      title: 'Milk',
      quantity: 1,
      category: categories[Categories.dairy]!),
  GroceryItem(
      id: 'b',
      title: 'Bananas',
      quantity: 5,
      category: categories[Categories.fruit]!),
  GroceryItem(
      id: 'c',
      title: 'Beef Steak',
      quantity: 1,
      category: categories[Categories.meat]!),
];
