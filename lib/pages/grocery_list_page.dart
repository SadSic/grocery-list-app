import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/pages/edit_item_page.dart';
import 'package:shopping_list/pages/new_item_page.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryItems = [];
  var _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    final url = Uri.https('grocerylistapp-6ebd0-default-rtdb.firebaseio.com',
        'shopping-list.json');
    try {
      final response = await http.get(url);

      if (response.statusCode >= 400) {
        setState(() {
          _error = 'Failed to load items. Please try again later.';
        });
      }

      final Map<String, dynamic>? responseData = json.decode(response.body);

      setState(() {
        _isLoading = false;
      });

      if (responseData == null) {
        return;
      }

      final List<GroceryItem> responseItems = [];
      for (final item in responseData.entries) {
        final category = categories.entries
            .firstWhere(
              (catItem) => catItem.value.name == item.value['category'],
            )
            .value;
        responseItems.add(
          GroceryItem(
            id: item.key,
            title: item.value['name'],
            quantity: item.value['quantity'],
            category: category,
          ),
        );
      }

      setState(() {
        _groceryItems = responseItems;
      });
    } catch (error) {
      _error = 'Something went wrong. Please try again later.';
    }
  }

  void _addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(builder: (context) => const NewItemPage()),
    );

    if (newItem == null) {
      return;
    }

    setState(() {
      _groceryItems.add(newItem);
    });
  }

  void _removeItem(GroceryItem item) async {
    final url = Uri.https('grocerylistapp-6ebd0-default-rtdb.firebaseio.com',
        'shopping-list/${item.id}.json');
    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      return;
    }

    setState(() {
      _groceryItems.remove(item);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.title} removed.'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _updateItem(GroceryItem item) async {
    print(item.id);
    final updatedItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (context) => EditItemPage(
          oldItem: item,
        ),
      ),
    );

    if (updatedItem == null) {
      return;
    }

    // final index = _groceryItems.indexWhere((i) => i.id == item.id);
    // if (index >= 0) {
    //   setState(() {
    //     _groceryItems[index] = updatedItem;
    //   });
    // }
    item = updatedItem;
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text('No Items added yet.'),
    );

    if (_isLoading) {
      content = Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (context, index) {
          final item = _groceryItems[index];
          return Dismissible(
            onDismissed: (direction) {
              _removeItem(item);
            },
            key: ValueKey(item.id),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.25),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text(
                      item.title,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Quantity: ${item.quantity}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                    ),
                    leading: Icon(
                      item.category.icon,
                      color: item.category.color,
                      size: 28,
                    ),
                    trailing: Container(
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: Color.fromARGB(255, 123, 123, 123),
                            ),
                            onPressed: () => _updateItem(item),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete_forever,
                              color: Color.fromARGB(255, 245, 84, 56),
                            ),
                            onPressed: () => _removeItem(item),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          );
        },
      );
    }

    if (_error != null) {
      content = Center(
        child: Text(_error!),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FontAwesomeIcons.bagShopping,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Text(
              'Grocery List',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(
              height: 8.0,
            ),
            Expanded(
              child: content,
            ),
          ],
        ),
      ),
      floatingActionButton: !_isLoading && _error == null
          ? FloatingActionButton(
              backgroundColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
              ),
              onPressed: _addItem,
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            )
          : null,
    );
  }
}
