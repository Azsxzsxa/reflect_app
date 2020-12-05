import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mvp/main/viewmodel/todo_categorymodel.dart';

class Constants{
   static List<CategoryViewModel> todoCategoryList = [
    CategoryViewModel(name:"General",icon:const IconData(57380,fontFamily: "MaterialIcons")),
    CategoryViewModel(name:"Routine",icon:const IconData(58300,fontFamily: "MaterialIcons")),
    CategoryViewModel(name:"Home",icon:const IconData(57898,fontFamily: "MaterialIcons")),
    CategoryViewModel(name:"Work",icon:const IconData(58657,fontFamily: "MaterialIcons")),
  ];




}