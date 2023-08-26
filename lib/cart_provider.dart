
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppping_cart/cart_model.dart';
import 'package:shoppping_cart/db_helper.dart';

class cartProvider with ChangeNotifier {
  DBhelper db= DBhelper();
  int _counter = 0;
  int get counter => _counter;

  double _totalPrice = 0.0;
  double get totalPtice => _totalPrice;

  late Future<List<Cart>> _cart;
  Future<List<Cart>> get cart=> _cart;

  Future<List<Cart>> getData() async{
    _cart = db.getCartList();
    return _cart;
  }

  void _setPrefItems() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('cart_item', _counter);
    prefs.setDouble('total_price', _totalPrice);
    notifyListeners();
  }

  void _getPrefItems() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _counter = prefs.getInt('cart_item') ?? 0;
    _totalPrice= prefs.getDouble('total_price')??0.0;
    notifyListeners();
  }

  void incCounter()
  {
    _counter++;
    _setPrefItems();
    notifyListeners();
  }

  void deccCounter()
  {
    _counter--;
    _setPrefItems();
    notifyListeners();
  }

  int getCounter()
  {
    _getPrefItems();
    return _counter;
  }

  void incTotalPrice(double productPrice)
  {
    _totalPrice = totalPtice + productPrice;
    _setPrefItems();
    notifyListeners();
  }

  void decTotalPrice(double productPrice)
  {
    _totalPrice = _totalPrice - productPrice;
    _setPrefItems();
    notifyListeners();
  }

  double getTotalPrice()
  {
    _getPrefItems();
    return _totalPrice;
  }

}