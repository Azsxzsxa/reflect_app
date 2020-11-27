import 'package:flutter/cupertino.dart';

abstract class CategoryModel{
  int id;

  static fromMap() {}
  toMap() {}
}

class CategoryViewModel extends CategoryModel {
  static String table = 'todo_categories';

  int id;
  String name;
  IconData icon;


  CategoryViewModel({this.id, this.name, this.icon});
  CategoryViewModel.empty();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {'name': name,'codePoint':icon.codePoint ,'fontFamily': icon.fontFamily};

    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  static CategoryViewModel fromMap(Map<String, dynamic> map) {
    var icon = IconData( map['codePoint'],fontFamily: map['fontFamily']);
    return CategoryViewModel(
        id: map['id'], name: map['name'], icon: icon
    );
  }
}
