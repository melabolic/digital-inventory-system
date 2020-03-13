// creating the item class to hold our database items

class Item {
  int _id;
  String _name;
  String _expiryDate;
  String _weight;

  Item(this._name, this._expiryDate, this._weight);
  Item.withId(this._id, this._name, this._expiryDate, this._weight);

  // sqflite stores entries in the form of a map, so we need to transcribe our
  // inputs into the appropriate format
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['name'] = _name;
    map['expiry_date'] = _expiryDate;
    map['weight'] = _weight;

    return map;
  }

  // we need the function below to help us convert our mapped object
  // back to a general list item
  Item.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._name = map['name'];
    this._expiryDate = map['expiry_date'];
    this._weight = map['weight'];
  }

  // creating simple getters for the respective fields
  int get id => _id;
  String get name => _name;
  String get expiryDate => _expiryDate;
  String get weight => _weight;

  // creating simple set functions to modify the values of our items
  set name(String newName) {
    this._name = newName;
  }
  set expiryDate(String newDate) {
    this._expiryDate = newDate;
  }
  set weight(String newWeight) {
    this._weight = newWeight;
  }
}