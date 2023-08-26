import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shoppping_cart/cart_model.dart';
import 'package:shoppping_cart/cart_provider.dart';
import 'package:shoppping_cart/cart_screen.dart';
import 'package:shoppping_cart/db_helper.dart';

import 'package:badges/badges.dart' as badge;
class ProductScreeen extends StatefulWidget {
  const ProductScreeen({Key? key}) : super(key: key);




  @override
  State<ProductScreeen> createState() => _ProductScreeenState();
}

class _ProductScreeenState extends State<ProductScreeen> {

  DBhelper? dBhelper = DBhelper() ;

  List<String> productName = ['Mango' , 'Orange' , 'Grapes' , 'Banana' , 'Chery' , 'Peach','Mixed Fruit Basket',] ;
  List<String> productUnit = ['KG' , 'Dozen' , 'KG' , 'Dozen' , 'KG' , 'KG','KG',] ;
  List<int> productPrice = [10, 20 , 30 , 40 , 50, 60 ,70 ] ;
  List<String> productImage = [
    'https://image.shutterstock.com/image-photo/mango-isolated-on-white-background-600w-610892249.jpg' ,
    'https://image.shutterstock.com/image-photo/orange-fruit-slices-leaves-isolated-600w-1386912362.jpg' ,
    'https://image.shutterstock.com/image-photo/green-grape-leaves-isolated-on-600w-533487490.jpg' ,
    'https://media.istockphoto.com/photos/banana-picture-id1184345169?s=612x612' ,
    'https://media.istockphoto.com/photos/cherry-trio-with-stem-and-leaf-picture-id157428769?s=612x612' ,
    'https://media.istockphoto.com/photos/single-whole-peach-fruit-with-leaf-and-slice-isolated-on-white-picture-id1151868959?s=612x612' ,
    'https://media.istockphoto.com/photos/fruit-background-picture-id529664572?s=612x612' ,
  ] ;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<cartProvider>(context);
  //  DBhelper? dBhelper = DBhelper() ;
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: (){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CartScreen())
              );
            },
            child: Center(
              child: badge.Badge(
                child: Icon(Icons.shopping_bag_outlined),
                badgeContent: Text(cart.getCounter().toString()),
                badgeAnimation:badge.BadgeAnimation.rotation(
                  animationDuration: Duration(milliseconds: 300),
                ) ,
              ),
            ),
          ),
          SizedBox(width: 20,)
        ],
      ),
      body: Column(
        children: [
          Expanded( // Important as it gives the actual space required
            child: ListView.builder(
                itemCount: productImage.length,
                itemBuilder: (BuildContext context, int index){
              return Card(
                  child: Row(
                    children: [
                      Container(
                        height: 100,
                          width: 100,
                          child: Image(image: NetworkImage(productImage[index])
                          ),

                      ),
                      SizedBox(width: 20,),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                productName[index],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                            Text(
                               "\$" +productPrice[index].toString() +" per " + productUnit[index],
                              style: TextStyle(color: Colors.green),
                            ),
                            Align(
                              alignment: Alignment.centerRight ,
                              child: InkWell(
                                onTap: (){

                                  Cart mycart = Cart(id: index,
                                      productId: index.toString()
                                      , productName: productName.toString(),
                                      initialPrice: productPrice[index] ,
                                      productPrice: productPrice[index],
                                      quantity: 1,
                                      unitTag: productUnit[index],
                                      image: productImage[index].toString() );
                                  dBhelper!.insert(
                                    //mycart
                                       Cart(id: index,
                                         productId: index.toString(),
                                         productName: productName[index].toString(),
                                         initialPrice: productPrice[index],
                                         productPrice: productPrice[index],
                                         quantity: 1,
                                         unitTag: productUnit[index].toString(),
                                         image: productImage[index].toString(),
                                       )
                                  ).then((value){
                                    print(11);
                                    cart.incTotalPrice(double.parse(productPrice[index].toString()));
                                    cart.incCounter();
                                  }).onError((error, stackTrace)
                                  {
                                    print(error.toString());
                                  }) ;
                                },
                                child: Container(
                                  height: 35,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.green
                                  ),
                                  child: Center(child: Text('Add to Cart')),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
              );
            }
            ),
          ),
        ],
      ),
    );
  }
}


