import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:shopping_list/models/category.dart';

const categories = {
  Categories.vegetables: Category(
    'Vegetables',
    Color.fromARGB(255, 49, 249, 92),
    FontAwesomeIcons.leaf,
  ),
  Categories.fruit: Category(
    'Fruit',
    Color.fromARGB(255, 245, 47, 33),
    FontAwesomeIcons.appleWhole,
  ),
  Categories.meat: Category(
    'Meat',
    Color.fromARGB(210, 243, 165, 39),
    FontAwesomeIcons.drumstickBite,
  ),
  Categories.dairy: Category(
    'Dairy',
    Color.fromARGB(255, 0, 208, 255),
    FontAwesomeIcons.cow,
  ),
  Categories.carbs: Category(
    'Carbs',
    Color.fromARGB(255, 246, 189, 109),
    FontAwesomeIcons.bowlRice,
  ),
  Categories.sweets: Category(
    'Sweets',
    Color.fromARGB(255, 244, 66, 247),
    FontAwesomeIcons.candyCane,
  ),
  Categories.spices: Category(
    'Spices',
    Color.fromARGB(255, 251, 60, 26),
    FontAwesomeIcons.pepperHot,
  ),
  Categories.convenience: Category(
    'Convenience',
    Color.fromARGB(255, 201, 38, 255),
    FontAwesomeIcons.toolbox,
  ),
  Categories.hygiene: Category(
    'Hygiene',
    Color.fromARGB(255, 0, 225, 255),
    FontAwesomeIcons.soap,
  ),
  Categories.other: Category(
    'Other',
    Color.fromARGB(255, 15, 72, 231),
    FontAwesomeIcons.gamepad,
  ),
};
