import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_app/models/item.dart';
import 'package:sqflite_app/screens/input_fields.dart';
import 'package:sqflite_app/utils/database_helper.dart';

class DisplayItems extends StatefulWidget {
  @override
  _DisplayItemsState createState() => _DisplayItemsState();
}

class _DisplayItemsState extends State<DisplayItems> {
  DatabaseHelper dbHelper = DatabaseHelper();
  
  List<Item> itemList;
  int count = 0;

  String get result => null;

  @override
  Widget build(BuildContext context) {
    if (itemList == null) {
      itemList = List<Item>();
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Your Inventory'),
      ),
      body: ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {
          return Card(
            // we want our cards to change color based on its expiry date
            color: _getCardBackgroundColor(this.itemList[position].expiryDate), 
            elevation: 2.0,
            child: ListTile(
              title: Text(this.itemList[position].name),
              subtitle:
                  Text('Expiry: ' + _formatString(this.itemList[position].expiryDate)),
              trailing: GestureDetector(
                child: Icon(Icons.delete),
                onTap: () {
                  _delete(context, this.itemList[position]);
                },
              ),
              onTap: () {
                debugPrint('ListTile tapped');
                _navigateToDetail(this.itemList[position], 'Edit Item');
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Item',
        elevation: 2.0,
        child: Icon(Icons.add),
        onPressed: () {
          print("FAB clicked");
          _navigateToDetail(Item('', DateTime.now().toString(), ''), 'New Item');
        },
      ),
    );
  }

  // pushes the new route to our app
  void _navigateToDetail(Item item, String title) async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InputFields(item, title),
      ),
    );
    if (result == true) {
      updateListView();
    }
  }

  String _formatString(String date) {
    return DateFormat.yMMMd().format(DateTime.parse(date));
  }

  // deletes entries from our database
  void _delete(BuildContext context, Item item) async {
    int result = await dbHelper.delete(item.id);
    print('deleted $result: ${item.name}');
    updateListView();
  }

  // function that updates the ListView whenever a change has been made
  void updateListView() {
    final Future<Database> dbFuture = dbHelper.initDB();
    dbFuture.then((database) {
      Future<List<Item>> itemListFuture = dbHelper.getItemList();
      itemListFuture.then((itemList) {
        setState(
          () {
            this.itemList = itemList;
            this.count = itemList.length;
          },
        );
      });
    });
    print(itemList);
    print(count);
  }

  Color _getCardBackgroundColor(String date) {
    DateTime temp = DateTime.parse(date);
    if (temp.isBefore(DateTime.now())) {
      return Colors.red[400];
    } else {
      return Colors.white10;
    }
  }
}
