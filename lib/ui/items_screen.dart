import 'package:flutter/material.dart';
import 'package:shopping/models/list_items.dart';
import 'package:shopping/models/shopping_list.dart';
import 'package:shopping/util/dbhelper.dart';

// Screen to display and manage items in a shopping list
class ItemsScreen extends StatefulWidget {
  final ShoppingList shoppingList;

  const ItemsScreen({super.key, required this.shoppingList});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  late DbHelper helper; // Database helper for managing items
  List<ListItem> items = []; // List to store items fetched from the database

  @override
  void initState() {
    super.initState();
    helper = DbHelper(); // Initialize database helper
    showData(widget.shoppingList.id); // Fetch items based on the shopping list ID
  }

  // Fetches items for the given shopping list ID from the database
  Future showData(int idList) async {
    await helper.openDb(); // Open the database
    items = await helper.getItems(idList); // Fetch items from the database
    setState(() {
      items = items; // Update the state with the fetched items
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.shoppingList.name), // Display the shopping list name in the app bar
      ),
      body: ListView.builder(
        itemCount: items.length, // Count the number of items to display
        itemBuilder: (BuildContext context, int index) {
          // Display each item in a ListTile
          return ListTile(
            title: Text(items[index].name), // Display the item's name
            subtitle: Text(
                'Quantity: ${items[index].quantity} - Note: ${items[index].note}'), // Display quantity and note
            trailing: IconButton(
                onPressed: () {}, // Placeholder for edit functionality
                icon: Icon(Icons.edit) // Icon for editing the item
            ),
          );
        },
      ),
    );
  }
}
