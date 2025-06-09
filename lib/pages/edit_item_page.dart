import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/category.dart';
import 'package:shopping_list/models/grocery_item.dart';

class EditItemPage extends StatefulWidget {
  final GroceryItem? oldItem;

  const EditItemPage({super.key, this.oldItem});

  @override
  State<EditItemPage> createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  final _formKey = GlobalKey<FormState>();
  late String _enteredName;
  late int _enteredQuantity;
  late Category? _selectedCategory;
  var _isSending = false;

  @override
  void initState() {
    super.initState();
    _enteredName = widget.oldItem!.title;
    _enteredQuantity = widget.oldItem!.quantity;
    _selectedCategory = widget.oldItem!.category;
  }

  void _resetForm() {
    _formKey.currentState!.reset();
  }

  void _confirmAddItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      FocusScope.of(context).unfocus();
      setState(() {
        _isSending = true;
      });
      final url = Uri.https('grocerylistapp-6ebd0-default-rtdb.firebaseio.com',
          'shopping-list/${widget.oldItem?.id}.json');
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            'title': _enteredName,
            'quantity': _enteredQuantity,
            'category': _selectedCategory?.name,
          },
        ),
      );

      if (!context.mounted) {
        return;
      }

      final responseData = json.decode(response.body);
      setState(() {
        _isSending = false;
      });

      print(responseData);

      Navigator.of(context).pop(
        GroceryItem(
          id: widget.oldItem!.id,
          title: _enteredName,
          quantity: _enteredQuantity,
          category: _selectedCategory!,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(24.0),
      borderSide: BorderSide(
        color: Color.fromRGBO(0, 0, 0, 0),
      ),
    );

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            'Edit Item',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
          ),
        ),
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 8),
                      TextFormField(
                        enableSuggestions: false,
                        maxLength: 50,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Name',
                          labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          floatingLabelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          helperStyle: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          fillColor: Theme.of(context).colorScheme.primary,
                          filled: true,
                          enabledBorder: border,
                          focusedBorder: border,
                        ),
                        initialValue: _enteredName,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.trim().length < 1 ||
                              value.trim().length > 50) {
                            return 'Must be between 1 and 50 characters long.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _enteredName = value!;
                        },
                      ),
                      Row(
                        children: [
                          Container(
                            width: 110,
                            child: TextFormField(
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              decoration: InputDecoration(
                                labelText: 'Quantity',
                                labelStyle: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                                floatingLabelStyle: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                                fillColor:
                                    Theme.of(context).colorScheme.primary,
                                filled: true,
                                enabledBorder: border,
                                focusedBorder: border,
                              ),
                              initialValue: _enteredQuantity.toString(),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    int.tryParse(value) == null ||
                                    int.tryParse(value)! <= 0) {
                                  return 'Must be a positive integer.';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _enteredQuantity = int.parse(value!);
                              },
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField(
                              iconDisabledColor: Colors.white,
                              iconEnabledColor: Colors.white,
                              decoration: InputDecoration(
                                fillColor:
                                    Theme.of(context).colorScheme.primary,
                                filled: true,
                                enabledBorder: border,
                                focusedBorder: border,
                              ),
                              value: _selectedCategory,
                              items: [
                                for (final category in categories.entries)
                                  DropdownMenuItem(
                                    value: category.value,
                                    child: Row(
                                      children: [
                                        Icon(
                                          category.value.icon,
                                          color: category.value.color,
                                          size: 20,
                                        ),
                                        SizedBox(width: 9),
                                        Text(
                                          category.value.name,
                                          style: _selectedCategory !=
                                                  category.value
                                              ? const TextStyle(
                                                  color: Colors.black)
                                              : TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _selectedCategory = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: _isSending ? null : _resetForm,
                            child: Text(
                              'Reset',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: _isSending ? null : _confirmAddItem,
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary),
                            child: Text(
                              'Save',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            if (_isSending)
              Container(
                decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.20)),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
