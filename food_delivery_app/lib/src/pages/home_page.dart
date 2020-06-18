import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/data/food_data.dart';
import 'package:food_delivery_app/src/models/Food.dart';
import 'package:food_delivery_app/src/widget/bought_food.dart';
import 'package:food_delivery_app/src/widget/food_category.dart';
import 'package:food_delivery_app/src/widget/home_top_info.dart';
import 'package:food_delivery_app/src/widget/search_field.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final List<Food>_foodList=food;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 50, 20, 0.0),
        children: <Widget>[
          Home_Top(),
          Foodcategory(),
          SizedBox(height: 18.0,),
          SearchField(),
          SizedBox(height: 18.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Frequently Bought Food",
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold
                ),
              ),
              GestureDetector(
                onTap: (){},
                child: Text(
                  "<View all>",
                  style: TextStyle(
                      color: Colors.orangeAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 18.0,),
          Column(
            children:_foodList.map(_buildFoodItems).toList(),
          )
        ],
      ),
    );


  }
  Widget _buildFoodItems(Food food){
    return Container(
      margin: EdgeInsets.only(bottom: 20.0),
      child: BoughtFood(
        id: food.id,
        name: food.name,
        imagePath: food.imagePath,
        category: food.category,
        discount: food.discount,
        price: food.price,
        ratings: food.ratings,
      ),
    );
  }

}

