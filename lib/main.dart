import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mvp/main/presenter/todo_presenter.dart';
import 'package:flutter_mvp/service/db.dart';
import 'file:///D:/flutter_workspace/flutter_mvp/lib/main/view/todo_component.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await DB.init();
  runApp(
      new MaterialApp(
        title: 'My tasks',
        home: new HomePage(new TodoBasicPresenter()),
      )
  );
}