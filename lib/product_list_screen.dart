import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';
import 'package:shoping_cart/cart_model.dart';
import 'package:shoping_cart/cart_screen.dart';
import 'cart_provider.dart';
import 'database.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {

  DatabaseRepository dbRepo = DatabaseRepository.instance;
  // CartProvider cartProvider = CartProvider();
  List<String> productName = ['Mango' , 'Orange' , 'Grapes' , 'Banana' , 'Chery' , 'Peach','Mixed Fruit Basket',] ;
  List<String> productUnit = ['KG' , 'Dozen' , 'KG' , 'Dozen' , 'KG' , 'KG','KG',] ;
  List<int> productPrice = [10, 20 , 30 , 40 , 50, 60 , 70 ] ;

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
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CartScreen()));
              },
              child: Center(
                child: badges.Badge(
                  badgeContent: Consumer<CartProvider>(
                      builder: (context, value, child){
                    return Text(value.getCounter().toString());
                  }),
                  badgeAnimation: const badges.BadgeAnimation.rotation(
                    animationDuration: Duration(milliseconds: 500),
                  ),
                  child: const Icon(Icons.shopping_bag_outlined),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: ListView.builder(
                    itemCount: productName.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Image(
                                  image: NetworkImage(productImage[index]),
                                  width: 100,
                                  height: 100,
                                ),
                                const SizedBox(width: 15,),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(productName[index], style: const TextStyle(fontSize: 20,)),
                                          Padding(
                                            padding: const EdgeInsets.only(right: 20),
                                            child: Text(r'$'+ productPrice[index].toString(), style: const TextStyle(fontWeight: FontWeight.bold),),
                                          ),
                                        ],
                                      ),
                                      Text(productUnit[index]),
                                      const SizedBox(height: 5,),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Padding(
                                          padding: const EdgeInsets.only(right: 5),
                                          child: InkWell(
                                            onTap: (){
                                              CartModal cartModalInstance =
                                              CartModal(
                                                  productId: index,
                                                  productName: productName[index].toString(),
                                                  initialPrice: productPrice[index],
                                                  productPrice: productPrice[index],
                                                  productQuantity: 1,
                                                  unitTag: productUnit[index].toString(),
                                                  productImage: productImage[index].toString()
                                              );
                                              dbRepo.insert(cartModal: cartModalInstance).then((value) {
                                                cart.addTotalPrice(double.parse(productPrice[index].toString()));
                                                cart.addCounter();
                                              }).onError((error, stackTrace) {
                                                // print(error.toString());
                                              });
                                            },
                                            child: Container(
                                              height: 30,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                color: Colors.green,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: const Center(
                                                  child: Text('Add to cart', style: TextStyle(color: Colors.white),)),
                                            ),
                                          ),
                                        ),

                                      ),

                                    ],),
                                ),


                              ],
                            )
                          ],
                        ),
                      );
                    })),
          ],
        ),
      ),
    );
  }
}
