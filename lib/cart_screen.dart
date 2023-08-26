import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppping_cart/cart_model.dart';
import 'package:shoppping_cart/cart_provider.dart';
import 'package:badges/badges.dart' as badge;
import 'package:shoppping_cart/db_helper.dart';
class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  DBhelper dBhelper = DBhelper();
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<cartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Products'),
        centerTitle: true,
        actions: [
          badge.Badge(
            child: Icon(Icons.shopping_bag_outlined),
            badgeContent: Text(cart.getCounter().toString()),
            badgeAnimation:badge.BadgeAnimation.rotation(
              animationDuration: Duration(milliseconds: 300),
            ) ,
          ),
          SizedBox(width: 20,)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            FutureBuilder(
                future: cart.getData(),
                builder: (context,AsyncSnapshot<List<Cart>> snapshot){
                  if(snapshot.hasData)
                    {
                      if(snapshot.data!.isEmpty)
                        {
                          return Center(
                            child: Column(
                              children: [
                                Image(
                                    height: 500,
                                    width: 500,
                                    image: AssetImage('images/empty_cart.png'),
                                ),
                                Text('Cart is empty',
                                  style: Theme.of(context).textTheme.titleLarge,),
                              ],
                            ),
                          );
                        }
                      else
                        {
                          return Expanded(
                            child: ListView.builder(
                                itemCount: snapshot.data!.length ,
                                itemBuilder: (BuildContext context, int index){
                                  return Card(
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 100,
                                          width: 100,
                                          child: Image(
                                              image: NetworkImage(snapshot.data![index].image.toString())
                                          ),

                                        ),
                                        SizedBox(width: 20,),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    snapshot.data![index].productName.toString(),
                                                    style: TextStyle(fontWeight: FontWeight.bold),
                                                  ),
                                                  InkWell(
                                                      onTap: (){
                                                        dBhelper.delete(snapshot.data![index].id!);
                                                        cart.deccCounter();
                                                        cart.decTotalPrice(double.parse(snapshot.data![index].productPrice.toString()));
                                                      },
                                                      child: Icon(Icons.delete)
                                                  ),
                                                ],
                                              ),

                                              SizedBox(height: 5),
                                              Text(
                                                "\$" + snapshot.data![index].initialPrice.toString()
                                                + " per  " + snapshot.data![index].unitTag.toString() ,
                                                style: TextStyle(color: Colors.green),
                                              ),
                                              Align(
                                                alignment: Alignment.centerRight ,
                                                child: InkWell(

                                                  child: Container(
                                                    height: 35,
                                                    width: 100,
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(5),
                                                        color: Colors.green
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        InkWell(
                                                            onTap: (){
                                                              int quantity = snapshot.data![index].quantity!;
                                                              int price = snapshot.data![index].initialPrice!;
                                                              quantity--;
                                                              int? newprice = price * quantity;

                                                              if(quantity >= 1 )
                                                              {
                                                                dBhelper!.updateQuantity(
                                                                    Cart(
                                                                        id: snapshot.data![index].id,
                                                                        productId: snapshot.data![index].productId,
                                                                        productName: snapshot.data![index].productName.toString(),
                                                                        initialPrice: snapshot.data![index].initialPrice,
                                                                        productPrice: newprice,
                                                                        quantity: quantity,
                                                                        unitTag: snapshot.data![index].unitTag.toString(),
                                                                        image: snapshot.data![index].image.toString()
                                                                    )
                                                                ).then((value){
                                                                  newprice = 0;
                                                                  quantity =0;
                                                                  cart.decTotalPrice(double.parse(snapshot.data![index].initialPrice.toString()));
                                                                }).onError((error, stackTrace){
                                                                  print(error.toString());
                                                                });
                                                              }

                                                            },
                                                            child: Icon(Icons.remove ,color: Colors.white,)
                                                        ),
                                                        Text(snapshot.data![index].quantity.toString(), style: TextStyle(color: Colors.white), ),
                                                        InkWell(
                                                            onTap: (){
                                                              int quantity = snapshot.data![index].quantity!;
                                                              int price = snapshot.data![index].initialPrice!;
                                                              quantity++;
                                                              int? newprice = price * quantity;

                                                              dBhelper!.updateQuantity(
                                                                  Cart(
                                                                      id: snapshot.data![index].id,
                                                                      productId: snapshot.data![index].productId,
                                                                      productName: snapshot.data![index].productName.toString(),
                                                                      initialPrice: snapshot.data![index].initialPrice,
                                                                      productPrice: newprice,
                                                                      quantity: quantity,
                                                                      unitTag: snapshot.data![index].unitTag.toString(),
                                                                      image: snapshot.data![index].image.toString()
                                                                  )
                                                              ).then((value){
                                                                newprice = 0;
                                                                quantity =0;
                                                                cart.incTotalPrice(double.parse(snapshot.data![index].initialPrice.toString()));
                                                              }).onError((error, stackTrace){
                                                                print(error.toString());
                                                              });

                                                            },
                                                            child: Icon(Icons.add,color: Colors.white,)
                                                        )
                                                      ],
                                                    ),
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
                          );
                        }

                    }
                  else{
                    return Text('');
                  }
                },
            ),
            Consumer<cartProvider>(
              builder: (context,value,child){
                return Visibility(
                  visible: value.getTotalPrice().toStringAsFixed(2) == "0.00" ? false:true,
                  child: Column(
                    children: [
                     ReUseAbleWidget(title: 'Total', value: r'$'+value.getTotalPrice().toStringAsFixed(2)),

                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ReUseAbleWidget extends StatelessWidget {
  final String title,value;
  const ReUseAbleWidget({Key? key , required this.title,required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,style: Theme.of(context).textTheme.titleSmall,),
          Text(value,style: Theme.of(context).textTheme.titleSmall,)
        ],
      ),
    );
  }
}