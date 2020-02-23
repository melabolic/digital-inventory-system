class User {
  int _id;
  String _name;
  int _age;

  User(this._name, this._age);
  User.withId(this._id, this._name, this._age);

  // simple getter functions
  int get id => _id;
  String get name => _name;
  int get age => _age;

  // simple set functions
  set name(String newName) {
    this._name = newName;
  }
  set age(int newAge) {
    this._age = newAge;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['name'] = _name;
    map['age'] = _age;
    return map;
  }

  User.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._name = map['name'];
    this._age = map['age'];
  }
}