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
  late List<ShoppingList> shoppingList;

  Future showData () async{
    await helper.openDb();
    shoppingList = await helper.getLists();

    setState(() {
      shoppingList = shoppingList;
    });
  }

  @override
  Widget build(BuildContext context) {

    showData();
    return ListView.builder(
        itemCount: (shoppingList != null)? shoppingList.length : 0,
        itemBuilder: (BuildContext context, int index){
          return ListTile(
            title: Text(shoppingList[index].name),
          );
        }
    );
  }
}
