import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopping/models/shopping_list.dart';
import 'package:shopping/ui/items_screen.dart';
import 'package:shopping/ui/shopping_list_dialog.dart';
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
      theme: ThemeData(primarySwatch: Colors.deepPurple,
      appBarTheme: AppBarTheme(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white
      )),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Shopping List',
            style: TextStyle( fontWeight: FontWeight.w500),
          ),
        ),
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
  late ShoppingListDialog dialog;

  Future showData() async {
    await helper.openDb();
    shoppingList = await helper.getLists();

    setState(() {
      shoppingList = shoppingList;
    });
  }

  @override
  void initState(){
    dialog = ShoppingListDialog();
    super.initState();
  }

  Widget build(BuildContext context) {
    showData();
    return ListView.builder(
        itemCount: (shoppingList != null) ? shoppingList.length : 0,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: CircleAvatar(
              child: Text(shoppingList[index].priority.toString()),
            ),
            title: Text(shoppingList[index].name),
            trailing: IconButton(onPressed: () {
              showDialog(context: context, builder: (BuildContext context) =>
              dialog.buildDialog(context, shoppingList[index], false));
            }, icon: Icon(Icons.edit)),
            onTap: (){
              Navigator.push(context,
              MaterialPageRoute(builder: (context) => ItemsScreen(shoppingList: shoppingList[index],)));
            },
          );
        });
  }
}
