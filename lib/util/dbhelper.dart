import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  final int version = 1;
  Database? db; // Make the database nullable

  Future<Database> openDb() async {
    if (db == null) {
      db = await openDatabase(
        join(await getDatabasesPath(), 'shopping.db'),
        onCreate: (database, version) {
          database.execute(
            'CREATE TABLE lists('
                'id INTEGER PRIMARY KEY, '
                'name TEXT, '
                'priority INTEGER)',
          );
          database.execute(
            'CREATE TABLE items ('
                'id INTEGER PRIMARY KEY, '
                'idList INTEGER, '
                'name TEXT, '
                'quantity TEXT, '
                'notes TEXT, '
                'FOREIGN KEY(idList) REFERENCES lists(id))',
          );
        },
        version: version,
      );
    }
    return db!; // Return the non-null database
  }
}