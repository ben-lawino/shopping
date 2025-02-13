import 'package:flutter/material.dart';
import 'package:shopping/models/shopping_list.dart';
import 'package:shopping/util/dbhelper.dart';

class ShoppingListDialog{
  final txtName = TextEditingController();
  final txtPriority =TextEditingController();

  Widget buildDialog(BuildContext context, ShoppingList list, bool isNew){
    DbHelper helper = DbHelper();

    if(!isNew) {
      txtName.text = list.name;
      txtPriority.text = list.priority.toString();
    }
    return AlertDialog(
      title: Text((isNew)?'New shopping list' : 'Edit shopping list'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: txtName,
              decoration: InputDecoration(
                hintText: 'shopping List Name'
              ),
            ),
            TextField(
              controller: txtPriority,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  hintText: 'shopping List Priority(1-3)'
              ),
            ),
            ElevatedButton(onPressed: (){
              list.name = txtName.text;
              list.priority = int.parse(txtPriority.text);
              helper.insertList(list);
              Navigator.pop(context);
            },
                child: Text('Save Shopping List')),
          ],
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0)
      ),
    );
  }
}