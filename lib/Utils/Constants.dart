import 'package:flutter/cupertino.dart';
import 'package:flutter_mvp/main/viewmodel/todo_categorymodel.dart';

class Constants{
   static List<CategoryViewModel> todoCategoryList = [
    CategoryViewModel(name:"General",icon:IconData(57380,fontFamily: "MaterialIcons")),
    CategoryViewModel(name:"Routine",icon:IconData(58300,fontFamily: "MaterialIcons")),
    CategoryViewModel(name:"Home",icon:IconData(57898,fontFamily: "MaterialIcons")),
    CategoryViewModel(name:"Work",icon:IconData(58657,fontFamily: "MaterialIcons")),
  ];


}