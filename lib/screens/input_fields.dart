import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:sqflite_app/assets/color_swatch.dart';
import 'package:intl/intl.dart';
import 'package:sqflite_app/models/item.dart';
import 'package:sqflite_app/utils/database_helper.dart';
import 'package:sqflite_app/assets/custom_fonts.dart';

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
  DateTime currentDate;

  @override
  Widget build(BuildContext context) {
    currentDate = DateTime.parse(item.expiryDate);

    nameController.text = item.name;
    weightController.text = item.weight;

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
          title: Text(
            appBarTitle,
            style: headerStyle,
          ),
          centerTitle: true,
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
              padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
              child: TextFormField(
                style: bodyStyle2,
                autofocus: true,
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
                    labelStyle: bodyStyle2,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0))),
              ),
            ),
            // updating the expiry date
            Padding(
              padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
              child: DateTimeField(
                style: bodyStyle2,
                format: DateFormat('yyyy-MM-dd'),
                initialValue: currentDate,
                onShowPicker: (context, currentValue) {
                  return DatePicker.showDatePicker(
                    context,
                    theme: DatePickerTheme(
                        cancelStyle: cancelStyle,
                        itemStyle: itemStyle,
                        doneStyle: doneStyle,
                        backgroundColor: Theme.of(context).primaryColor),
                    showTitleActions: true,
                    minTime: DateTime(2000, 1, 1),
                    maxTime: DateTime(2050, 12, 12),
                    currentTime: currentDate,
                    onChanged: (date) => debugPrint(date.toString()),
                    onConfirm: (date) {
                      updateDate(date);
                    },
                  );
                },
                decoration: InputDecoration(
                    labelText: 'Item Best Before',
                    labelStyle: bodyStyle2,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0))),
              ),
            ),
            // updating the weight entry
            Padding(
              padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
              child: TextFormField(
                style: bodyStyle2,
                controller: weightController,
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Please enter the weight';
                  } else if (int.parse(value) < 0) {
                    return 'Weight is negative';
                  }
                },
                keyboardType: TextInputType.numberWithOptions(),
                onChanged: (value) {
                  debugPrint(value);
                  updateWeight();
                },
                decoration: InputDecoration(
                    labelText: 'Weight (in grams)',
                    labelStyle: bodyStyle2,
                    hintText: 'e.g. 200g',
                    hintStyle: subtitleStyle,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0))),
              ),
            ),
            // Save and Delete Buttons (with lots of formatting)
            Padding(
              padding: EdgeInsets.only(
                top: 12.0,
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      padding: EdgeInsets.only(top: 6.0, bottom: 8.0),
                      color: accentColor,
                      textColor: Theme.of(context).primaryColorDark,
                      child: Text(
                        'SAVE',
                        style: saveButtonStyle,
                        textScaleFactor: 1.2,
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
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                    ),
                  ),
                  Container(
                    width: 24.0,
                  ),
                  Expanded(
                    child: RaisedButton(
                      padding: EdgeInsets.only(top: 8.0, bottom: 10.0),
                      color: mainBackground,
                      textColor: accentColor,
                      child: Text(
                        (item.id != null) ? 'DELETE' : 'CANCEL',
                        style: delButtonStyle,
                        textScaleFactor: 1.2,
                      ),
                      onPressed: () {
                        setState(() {
                          debugPrint("Delete button clicked");
                          _delete();
                        });
                      },
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: accentColor),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
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

  /* These functions help us save, delete, and revert to the previous screen */
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

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  /* The functions below helps us update our entry fields for an item */
  void updateName() {
    item.name = nameController.text;
  }

  void updateDate(DateTime date) {
    item.expiryDate = DateFormat('yyyy-MM-dd').format(date).toString();
    debugPrint('new date: ${item.expiryDate}');
  }

  void updateWeight() {
    item.weight = weightController.text;
  }

}
