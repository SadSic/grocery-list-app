import 'package:flutter/material.dart';
import 'package:shopping_list/data/dummy_items.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/pages/new_item_page.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  final List<GroceryItem> _groceryItems = [];

  void _addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(builder: (context) => const NewItemPage()),
    );

    if (newItem == null) return;

    setState(() {
      _groceryItems.add(newItem);
    });
  }

  void _removeItem(GroceryItem item) {
    setState(() {
      _groceryItems.remove(item);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.name} removed.'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grocery List'),
      ),
      body: _groceryItems.isEmpty
          ? Center(
              child: Text('No Items added yet.'),
            )
          : ListView.builder(
              itemCount: _groceryItems.length,
              itemBuilder: (context, index) {
                final item = _groceryItems[index];
                return Dismissible(
                  onDismissed: (direction) {
                    _removeItem(item);
                  },
                  key: ValueKey(item.id),
                  child: ListTile(
                    title: Text(item.name),
                    subtitle: Text('Quantity: ${item.quantity}'),
                    leading: Container(
                      width: 24,
                      height: 24,
                      color: item.category.color,
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        child: const Icon(Icons.add),
      ),
    );
  }
}
