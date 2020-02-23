import 'package:flutter/material.dart';
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
        title: Text('Digital Inventory'),
      ),
      body: ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {
          return Card(
            color: Colors.white10,
            elevation: 2.0,
            child: ListTile(
              title: Text(this.itemList[position].name),
              subtitle:
                  Text('Expiring: ${this.itemList[position].expiryDate}'),
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
          _navigateToDetail(Item('', '', ''), 'New Item');
        },
      ),
    );
  }

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

  void _delete(BuildContext context, Item item) async {
    int result = await dbHelper.delete(item.id);
    print('deleted $result: ${item.name}');
    updateListView();
  }

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

}
