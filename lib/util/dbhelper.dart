import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:shopping/models/list_items.dart';
import 'package:shopping/models/shopping_list.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  final int version = 1;
  Database? db;

  static final DbHelper _dbHelper =DbHelper._internal();

  DbHelper._internal();

  factory DbHelper (){
    return _dbHelper;
  }

  // Open the database and enable foreign keys
  Future<Database?> openDb() async {
    if (db == null) {
      db = await openDatabase(
        join(await getDatabasesPath(), 'shopping.db'),
        onCreate: (database, version) {
          // Create the lists table with auto-incrementing id
          database.execute(
            'CREATE TABLE lists('
                'id INTEGER PRIMARY KEY AUTOINCREMENT, ' // Add AUTOINCREMENT for auto id
                'name TEXT, '
                'priority INTEGER)',
          );

          // Create the items table with foreign key constraint
          database.execute(
            'CREATE TABLE items ('
                'id INTEGER PRIMARY KEY AUTOINCREMENT, ' // Add AUTOINCREMENT for auto id
                'idList INTEGER, '
                'name TEXT, '
                'quantity TEXT, '
                'note TEXT, '
                'FOREIGN KEY(idList) REFERENCES lists(id))',
          );
        },
        version: version,
      );

      // Enable foreign key support in SQLite
      await db!.execute('PRAGMA foreign_keys = ON;');
    }
    return db;
  }

  // Insert a shopping list into the database
  Future<int> insertList(ShoppingList list) async {
    // Insert the list into the 'lists' table and return the inserted id
    int id = await this.db!.insert('lists',
      list.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  // Insert an item into the database
  Future<int> insertItem(ListItem item) async {
    // Insert the item into the 'items' table and return the inserted id
    int id = await this.db!.insert('items',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  // Retrieves the contents of the 'lists' table from the database
  Future<List<ShoppingList>> getLists() async {
    // Query the 'lists' table and get a list of maps
    final List<Map<String, dynamic>> maps = await db!.query('lists');

    // Generate and return a list of ShoppingList objects from the maps
    return List.generate(maps.length, (i) {
      return ShoppingList(
        maps[i]['id'],        // Map the 'id' field
        maps[i]['name'],      // Map the 'name' field
        maps[i]['priority'],  // Map the 'priority' field
      );
    });
  }

  // Retrieves the list of items from the 'items' table for a specific list ID
  Future<List<ListItem>> getItems(int idList) async {
    // Query the 'items' table with a condition to filter by the given list ID
    final List<Map<String, dynamic>> maps = await db!.query(
      'items',
      where: 'idList = ?', // SQL WHERE clause
      whereArgs: [idList], // Arguments for the WHERE clause
    );

    // Generate and return a list of ListItem objects from the query result
    return List.generate(maps.length, (i) {
      return ListItem(
        maps[i]['id'],        // Map the 'id' field
        maps[i]['idList'],    // Map the 'idList' field
        maps[i]['name'],      // Map the 'name' field
        maps[i]['quantity'],  // Map the 'quantity' field
        maps[i]['note'],      // Map the 'note' field
      );
    });
  }


  Future <int> deleteList(ShoppingList list) async{
    int result = await db!.delete("items", where: "idList = ?",
    whereArgs: [list.id]);
      result = await db!.delete("lists", where: "idList = ?",
        whereArgs: [list.id]);
    return result;
  }

}
