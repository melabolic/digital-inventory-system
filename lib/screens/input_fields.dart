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
  // here, we're creating a global key to keep track and validate our user inputs
  var _formKey = GlobalKey<FormState>();

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

    // the widget WillPopScope enables us to control the leading buttons actions on the appbar
    return WillPopScope(
      onWillPop: () {
        moveToLastScreen(); // takes us back to the last screen
        return;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () =>
                moveToLastScreen(), // takes us back to the last screen
          ),
          title: Text(appBarTitle),
        ),
        body: _mainBody(), // main code that displays the input fields
      ),
    );
  }

  // creating the widget that displays the input fields
  Widget _mainBody() {
    return Form(
      key: _formKey, // using this key to get the current instance of our form
      child: Padding(
        padding: EdgeInsets.only(top: 12.0, left: 24.0, right: 24.0),
        child: ListView(
          children: <Widget>[
            // updating the name entry
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextFormField(
                textCapitalization: TextCapitalization.words,
                controller: nameController,
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Please enter a name';
                  } else if (value.length < 3) {
                    return 'Item name is too short';
                  }
                },
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
                child: TextFormField(
                  controller: dateController,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Expiry date is required';
                    } else if (value.length < 10) {
                      return 'Date is not valid';
                    }
                  },
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
              child: TextFormField(
                controller: weightController,
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Please enter the weight';
                  }
                },
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
                        setState(
                          () {
                            if (_formKey.currentState.validate()) {
                              debugPrint("Save button clicked");
                              _save();
                            }
                          },
                        );
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
