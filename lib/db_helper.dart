import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'package:shoppping_cart/cart_model.dart';
import 'package:path/path.dart';
class DBhelper
{
  static Database? _db;

  Future<Database?> get db async{
    if(_db != null)
      {
        return _db!;
      }

    _db = await initDatabase();
    return db!;
  }

  // initDatabase() async {
  //   io.Directory documentDirectory = await getApplicationDocumentsDirectory();
  //   String path = join(documentDirectory.toString(), 'cart.db');
  //   var db = await openDatabase(path,version: 1,onCreate:_onCreate,);
  //   print('Database Create');
  //   return db;
  // }

  Future<Database> initDatabase() async {
    io.Directory documentDirectory =
    await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.toString(), 'cart.db');
    var db = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
    // Check if the "cart" table exists
    var tableExists = await db
        .query("sqlite_master", where: "type = 'table' and name = 'cart'");
    if (tableExists.isEmpty) {
      // Create the "cart" table if it does not exist
      await _onCreate(db, 1);
    }
    print('Database Created');
    return db;
  }


  _onCreate(Database db, int version) async {
    await db
        .execute(
        'CREATE TABLE cart (id INTEGER PRIMARY KEY ,'
            ' productId VARCHAR UNIQUE,productName TEXT,'
            'initialPrice INTEGER,'
            ' productPrice INTEGER , '
            'quantity INTEGER,'
            ' unitTag TEXT ,'
            ' image TEXT )');
    print('Created  a databse');
  }

    Future<Cart> insert(Cart cart) async{
    //print(cart.toMap());
    var dbClient = await db;
    print(111);
    if (cart.toMap() != Null )
      {
        print("Some Null Value");
      }
    await dbClient!.insert('cart', cart.toMap());
    print('Data inserted');
    return cart;
    }

  Future<List<Cart>> getCartList() async{
    var dbClient = await db;
    final List<Map<String,Object?>>  queryResult = await dbClient!.query('cart');
    return queryResult.map((e) => Cart.fromMap(e)).toList();
  }

  Future<int> delete(int id) async{
    var dbClient = await db;
    return await dbClient!.delete(
      'cart',
      where: 'id = ?',
      whereArgs: [id]
    );
  }

  Future<int> updateQuantity(Cart cart) async{
    var dbClient = await db;
    return await dbClient!.update(
        'cart',
        cart.toMap(),
      where: 'id = ?',
      whereArgs: [cart.id]
    );
  }
}