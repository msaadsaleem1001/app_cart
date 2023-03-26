import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoping_cart/cart_model.dart';
import 'package:shoping_cart/cart_provider.dart';
import 'package:badges/badges.dart' as badges;
import 'package:shoping_cart/database.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  DatabaseRepository db = DatabaseRepository.instance;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Products'),
          centerTitle: true,
          backgroundColor: Colors.teal,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Center(
                child: badges.Badge(
                  badgeContent:
                      Consumer<CartProvider>(builder: (context, value, child) {
                    return Text(value.getCounter().toString());
                  }),
                  badgeAnimation: const badges.BadgeAnimation.rotation(
                    animationDuration: Duration(milliseconds: 500),
                  ),
                  child: const Icon(Icons.shopping_bag_outlined),
                ),
              ),
            ),
          ],
        ),
        body: Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FutureBuilder(
                    future: cart.getCartItems(),
                    builder: (context, AsyncSnapshot<List<CartModal>> snapshot) {
                          if(snapshot.data!.isEmpty){
                            return Center(child: Text('Cart is empty.', style: Theme.of(context).textTheme.displaySmall ));
                          }
                          else{
                            return Expanded(
                              child: ListView.builder(
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Image(
                                                image: NetworkImage(snapshot
                                                    .data![index].productImage
                                                    .toString()),
                                                width: 100,
                                                height: 100,
                                              ),
                                              const SizedBox(
                                                width: 15,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text(
                                                            snapshot.data![index].productName
                                                                .toString(),
                                                            style: const TextStyle(
                                                              fontSize: 20,
                                                            )),
                                                        IconButton(
                                                            onPressed: (){
                                                              db.delete(snapshot.data![index].id!.toInt()).then((value) {
                                                                cart.removeCounter();
                                                                cart.removeTotalPrice(double.parse(snapshot.data![index].productPrice.toString()));
                                                              }).onError((error, stackTrace) {
                                                                // print(error.toString());
                                                              });

                                                            },
                                                            icon: Icon(Icons.delete_rounded, color: Colors.redAccent.withOpacity(0.7),))
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(snapshot.data![index].unitTag
                                                            .toString()),
                                                        Text(r' $'+snapshot.data![index].productPrice
                                                            .toString()),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Align(
                                                      alignment: Alignment.centerRight,
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(right: 10, bottom: 10),
                                                        child: Container(
                                                          height: 30,
                                                          width: 80,
                                                          decoration: BoxDecoration(
                                                            color: Colors.green,
                                                            borderRadius:
                                                            BorderRadius.circular(
                                                                10),
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 5),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                InkWell(
                                                                    onTap: (){
                                                                      int quantity = snapshot.data![index].productQuantity!;
                                                                      int price = snapshot.data![index].initialPrice!;
                                                                      quantity--;
                                                                      int? newPrice = price * quantity;
                                                                      if(quantity > 0){
                                                                        db.updateQuantity(
                                                                            CartModal(
                                                                                id: snapshot.data![index].id,
                                                                                productId: snapshot.data![index].productId,
                                                                                productName: snapshot.data![index].productName,
                                                                                initialPrice: price,
                                                                                productPrice: newPrice,
                                                                                productQuantity: quantity,
                                                                                unitTag: snapshot.data![index].unitTag,
                                                                                productImage: snapshot.data![index].productImage)
                                                                        ).then((value) {
                                                                          quantity = 0;
                                                                          price = 0;
                                                                          newPrice = 0;
                                                                          cart.removeTotalPrice(double.parse(snapshot.data![index].initialPrice.toString()));
                                                                        }).onError((error, stackTrace) {
                                                                          // print(error.toString());
                                                                        });
                                                                      }
                                                                    },
                                                                    child: const Icon(Icons.remove, color: Colors.white, size: 20,)),
                                                                Text(
                                                                  snapshot.data![index].productQuantity.toString(),
                                                                  style: const TextStyle(
                                                                      color: Colors.white),
                                                                ),
                                                                InkWell(
                                                                    onTap: (){
                                                                      int quantity = snapshot.data![index].productQuantity!;
                                                                      int price = snapshot.data![index].initialPrice!;
                                                                      quantity++;
                                                                      int? newPrice = price * quantity;
                                                                      db.updateQuantity(
                                                                          CartModal(
                                                                              id: snapshot.data![index].id,
                                                                              productId: snapshot.data![index].productId,
                                                                              productName: snapshot.data![index].productName,
                                                                              initialPrice: price,
                                                                              productPrice: newPrice,
                                                                              productQuantity: quantity,
                                                                              unitTag: snapshot.data![index].unitTag,
                                                                              productImage: snapshot.data![index].productImage)
                                                                      ).then((value) {
                                                                        quantity = 0;
                                                                        price = 0;
                                                                        newPrice = 0;
                                                                        cart.addTotalPrice(double.parse(snapshot.data![index].initialPrice.toString()));
                                                                      }).onError((error, stackTrace) {
                                                                        // print(error.toString());
                                                                      });
                                                                    },
                                                                    child: const Icon(Icons.add, color: Colors.white, size: 20,)),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                            );
                          }
                    }),
              ],
            ),
            Visibility(
              visible: cart.getTotalPrice() == 0.0? false : true,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10,),
                  width: double.infinity,
                  height: 30,
                  color: Colors.black,
                  child: Consumer<CartProvider>(builder: (context, value, child){
                    return ReUseAbleRow(totalPrice: r'$'+value.getTotalPrice().toString());
                  }),
                ),
              ),
            ),
          ]
        ),
      ),
    );
  }
}


class ReUseAbleRow extends StatelessWidget {
  final String totalPrice;
  const ReUseAbleRow({super.key, required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Total Price:', style: TextStyle(color: Colors.white)),
        Text(totalPrice.toString(), style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}
