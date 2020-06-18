import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/data/category_Data.dart';
import 'package:food_delivery_app/src/models/category.dart';
import 'package:food_delivery_app/src/widget/FoodCard.dart';

class Foodcategory extends StatelessWidget {

  final List<Category> _categories=categories;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
          itemCount: _categories.length,

          itemBuilder: (BuildContext context,int index){
          return FoodCard(
            categoryName: _categories[index].categoryName,
          imagePath: _categories[index].imagePath,
          numberOfItem: _categories[index].numberOfItems,);
          }),
    );
  }
}
