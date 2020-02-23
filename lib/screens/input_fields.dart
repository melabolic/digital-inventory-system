import 'package:flutter/material.dart';
import 'package:sqflite_app/models/item.dart';
import 'package:sqflite_app/utils/database_helper.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class InputFields extends StatefulWidget {
  final Item item;
  final String appBarTitle;

  InputFields(this.item, this.appBarTitle);

  @override
  _InputFieldsState createState() {
    return _InputFieldsState(this.item, this.appBarTitle);
  }
}

class _InputFieldsState extends State<InputFields> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  Item item;
  String appBarTitle;

  _InputFieldsState(this.item, this.appBarTitle);

  TextEditingController nameController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  MaskedTextController dateController =
      MaskedTextController(mask: "00/00/0000");

  @override
  Widget build(BuildContext context) {
    nameController.text = item.name;
    weightController.text = item.weight;
    dateController.text = item.expiryDate;

    return WillPopScope(
      onWillPop: () {
        moveToLastScreen();
        return;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => moveToLastScreen(),
          ),
          title: Text(appBarTitle),
        ),
        body: _mainBody(),
      ),
    );
  }

  // creating the widget that displays the text editors
  Widget _mainBody() {
    return Padding(
      padding: EdgeInsets.only(top: 12.0, left: 24.0, right: 24.0),
      child: ListView(
        children: <Widget>[
          // updating the name entry
          Padding(
            padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
            child: TextField(
              textCapitalization: TextCapitalization.words,
              controller: nameController,
              keyboardType: TextInputType.text,
              onChanged: (value) {
                debugPrint(value);
                updateName();
              },
              decoration: InputDecoration(
                  labelText: 'Item Name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0))),
            ),
          ),
          // updating the expiry date
          Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                controller: dateController,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  debugPrint(value);
                  updateDate();
                },
                decoration: InputDecoration(
                    hintText: "DD/MM/YYYY",
                    labelText: 'Expiry Date',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0))),
              )),
          // updating the weight entry
          Padding(
            padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
            child: TextField(
              controller: weightController,
              keyboardType: TextInputType.numberWithOptions(),
              onChanged: (value) {
                debugPrint(value);
                updateWeight();
              },
              decoration: InputDecoration(
                  labelText: 'Weight (in grams)',
                  hintText: '1kg = 1000g',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0))),
            ),
          ),
          // Save and Delete Buttons
          Padding(
            padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                    color: Theme.of(context).primaryColorLight,
                    textColor: Theme.of(context).primaryColorDark,
                    child: Text(
                      'Save',
                      textScaleFactor: 1.5,
                    ),
                    onPressed: () {
                      setState(() {
                        debugPrint("Save button clicked");
                        _save();
                      });
                    },
                  ),
                ),
                Container(
                  width: 15.0,
                ),
                Expanded(
                  child: RaisedButton(
                    color: Theme.of(context).primaryColorLight,
                    textColor: Theme.of(context).primaryColorDark,
                    child: Text(
                      (item.id != null) ? 'Delete' : 'Cancel',
                      textScaleFactor: 1.5,
                    ),
                    onPressed: () {
                      setState(() {
                        debugPrint("Delete button clicked");
                        _delete();
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _save() async {
    moveToLastScreen();
    if (item.id != null) {
      // When the id != 0, which means it will be updating an entry
      await databaseHelper.update(item);
    } else {
      // when it is not yet a real entry
      await databaseHelper.insert(item);
    }
  }

  void _delete() async {
    moveToLastScreen();
    // There are two cases here:
    // 1. When the item is trying to delete a new note
    if (item.id == null) {
      return;
    }
    // 2. When the item is trying to delete an existing note
    await databaseHelper.delete(item.id);
  }

  void updateName() {
    item.name = nameController.text;
  }

  void updateDate() {
    item.expiryDate = dateController.text;
  }

  void updateWeight() {
    item.weight = weightController.text;
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
}
