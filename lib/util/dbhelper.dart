import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:shopping/models/list_items.dart';
import 'package:shopping/models/shopping_list.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  final int version = 1;
  Database? db;

  // Open the database and enable foreign keys
  Future<Database> openDb() async {
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
    return db!;
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

  //Retrieve the contents of the list tables
  Future <List<ShoppingList>> getLists() async{
    final List<Map<String, dynamic>> maps = await db!.query('lists');
    return List.generate(maps.length, (i){
      return ShoppingList(
        maps[i]['id'],
        maps[i]['name'],
        maps[i]['priority'],);
    });
  }
}
