import 'package:flutter/material.dart';

class FoodCard extends StatelessWidget {
  final String categoryName;
  final String imagePath;
  final int numberOfItem;


  FoodCard({this.categoryName, this.imagePath, this.numberOfItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 20.0),
      child:Card(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        child:Row(
          children: <Widget>[
            Image(
              image:AssetImage(imagePath),
              height: 65,
              width: 65,
            ),
            SizedBox(width: 20.0,),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(categoryName,style: TextStyle(fontWeight: FontWeight.bold,fontSize:20.0,color: Colors.deepOrange),),
                Text(numberOfItem.toString()+" kinds ",style: TextStyle(fontStyle: FontStyle.italic),)
              ],
            )
          ],

        ) ,
      ),
      )
    );
  }
}
