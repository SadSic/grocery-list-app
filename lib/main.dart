import 'package:flutter/material.dart';
import 'package:shopping_list/pages/grocery_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Groceries',
      theme: ThemeData(
        fontFamily: 'Lato',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xffffd6a5),
          primary: const Color.fromARGB(255, 23, 144, 238),
          secondary: const Color.fromARGB(255, 88, 209, 243),
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 50, 58, 60),
        useMaterial3: true,
      ),
      home: GroceryList(),
    );
  }
}
