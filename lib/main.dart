import 'package:flutter/material.dart';
import 'package:shopping/models/shopping_list.dart';
import 'package:shopping/ui/items_screen.dart';
import 'package:shopping/ui/shopping_list_dialog.dart';
import 'package:shopping/util/dbhelper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shopping List',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
      ),
      home: const ShList(),
    );
  }
}

class ShList extends StatefulWidget {
  const ShList({super.key});

  @override
  State<ShList> createState() => _ShListState();
}

class _ShListState extends State<ShList> {
  final DbHelper helper = DbHelper();
  List<ShoppingList> shoppingList = []; // Initialized to avoid null errors
  late final ShoppingListDialog dialog;

  @override
  void initState() {
    super.initState();
    dialog = ShoppingListDialog();
    showData(); // Fetch data only once when widget initializes
  }

  Future<void> showData() async {
    await helper.openDb();
    List<ShoppingList> lists = await helper.getLists();
    setState(() {
      shoppingList = lists;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shopping List', style: TextStyle(fontWeight: FontWeight.w500))),
      body: ListView.builder(
        itemCount: shoppingList.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(shoppingList[index].id.toString()),
            onDismissed: (direction) {
              String strName = shoppingList[index].name;
              helper.deleteList(shoppingList[index]);
              setState(() {
                shoppingList.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$strName deleted")));
            },
            child: ListTile(
              leading: CircleAvatar(
                child: Text(shoppingList[index].priority.toString()),
              ),
              title: Text(shoppingList[index].name),
              trailing: IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => dialog.buildDialog(context, shoppingList[index], false),
                  );
                },
                icon: const Icon(Icons.edit),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ItemsScreen(shoppingList: shoppingList[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => dialog.buildDialog(context, ShoppingList(0, '', 0), true),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.pink,
      ),
    );
  }
}
