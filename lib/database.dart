// ignore_for_file: depend_on_referenced_packages
import 'package:shoping_cart/constants.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'cart_model.dart';


class DatabaseRepository{

  static final DatabaseRepository instance = DatabaseRepository._init();
  DatabaseRepository._init();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('cart.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
                        create table ${AppConst.tableName} ( 
                        ${AppConst.id} integer primary key autoincrement, 
                        ${AppConst.productId} integer unique not null,
                        ${AppConst.productName} varchar,
                        ${AppConst.initialPrice} integer not null,
                        ${AppConst.productPrice} integer not null,
                        ${AppConst.productQuantity} integer not null,
                        ${AppConst.unitTag} VARCHAR, 
                        ${AppConst.productImage} VARCHAR)
                     ''');
  }

  Future<CartModal> insert({required CartModal cartModal}) async{
    Database db = await instance.database;
    await db.insert(AppConst.tableName, cartModal.toMap());
    return cartModal;
  }

  Future<List<CartModal>> getCartItems() async {
    final db = await instance.database;
    // final List<Map<dynamic, Object?>> result = await db.query(AppConst.tableName);
    final result = await db.query(AppConst.tableName);
    return result.map((json) => CartModal.fromJson(json)).toList();
    // return result.map((e) => CartModal.fromMap(e)).toList();
  }

  Future<void> delete(int id) async {
    try {
      final db = await instance.database;
      await db.delete(
        AppConst.tableName,
        where: '${AppConst.id} = ?',
        whereArgs: [id],
      );
    } catch (e) {
      // print(e.toString());
    }
  }

  Future<void> updateQuantity(CartModal cart) async {
    try {
      final db = await instance.database;
      db.update(
        AppConst.tableName,
        cart.toMap(),
        where: '${AppConst.id} = ?',
        whereArgs: [cart.id],
      );
    } catch (e) {
      print(e.toString());
    }
  }


}