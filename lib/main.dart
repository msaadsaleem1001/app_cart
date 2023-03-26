import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoping_cart/cart_provider.dart';
import 'product_list_screen.dart';

void main() {
  runApp(const ShoppingCart());
}

class ShoppingCart extends StatelessWidget {
  const ShoppingCart({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => CartProvider(),
      child: Builder(builder: (BuildContext context){
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const ProductListScreen(),
        );
      }),
    );
  }
}
