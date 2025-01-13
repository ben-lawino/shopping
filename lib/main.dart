import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopping/models/list_items.dart';
import 'package:shopping/models/shopping_list.dart';
import 'package:shopping/util/dbhelper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shopping List',
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      home: Scaffold(
        appBar: AppBar(title: Text('Shopping List'),),
        body: ShList(),
      ),
    );
  }
}

class ShList extends StatefulWidget {
  const ShList({super.key});

  @override
  State<ShList> createState() => _ShListState();
}

class _ShListState extends State<ShList> {
  DbHelper helper = DbHelper();

  Future showData () async{
    await helper.openDb();
    ShoppingList list = ShoppingList(0, 'Bakery', 2);
    int listId = await helper.insertList(list);

    ListItem item = ListItem(0, listId, 'Bread', '1kg', 'done');
    int itemId = await helper.insertItem(item);

    print('List Id: ' + listId.toString());
    print('Item Id: ' + itemId.toString());
  }


  @override
  Widget build(BuildContext context) {

    showData();
    return Container();
  }
}
