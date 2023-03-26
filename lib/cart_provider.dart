// ignore_for_file: unused_element

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoping_cart/cart_model.dart';
import 'package:shoping_cart/database.dart';

class CartProvider with ChangeNotifier {

  int counter = 0;
  // ignore: unused_element
  int get _counter => counter;
  double totalPrice = 0;
  double get _totalPrice => totalPrice;


  late Future<List<CartModal>> _cart;
  Future<List<CartModal>> get cart => _cart;

  Future<List<CartModal>> getCartItems () async{
    _cart = DatabaseRepository.instance.getCartItems();
    return _cart;
  }


  void setPrefItems () async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('cartItems', counter);
    prefs.setDouble('totalPrice', totalPrice);
    notifyListeners();
  }
  // void removePrefs () async{
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.clear();
  // }

  void getPrefItems () async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    counter = prefs.getInt('cartItems') ?? 0;
    totalPrice = prefs.getDouble('totalPrice') ?? 0.0;
    notifyListeners();
  }



  void addCounter(){
    counter++;
    setPrefItems();
    notifyListeners();
  }

  void removeCounter(){
    counter--;
    setPrefItems();
    notifyListeners();
  }

  int getCounter () {
    getPrefItems();
    return counter;
  }



  void addTotalPrice(double productPrice){
    totalPrice = totalPrice + productPrice;
    setPrefItems();
    notifyListeners();
  }

  void removeTotalPrice(double productPrice){
    totalPrice = totalPrice - productPrice;
    setPrefItems();
    notifyListeners();
  }

  double getTotalPrice () {
    getPrefItems();
    return totalPrice;
  }



}