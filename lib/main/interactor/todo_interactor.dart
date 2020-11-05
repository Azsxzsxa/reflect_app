
import 'package:flutter_mvp/Utils/date_formatter.dart';
import 'package:flutter_mvp/main/presenter/todo_presenter.dart';
import 'package:flutter_mvp/main/viewmodel/todo_viewmodel.dart';
import 'package:flutter_mvp/service/db.dart';

class TodoInteractor{
  Future<List<TodoViewModel>> getList(){}
  void saveItem(TodoViewModel item){}
  void update(TodoViewModel item){}
  void deleteItem(TodoViewModel item){}
}

class TodoBasicInteractor implements TodoInteractor{
  TodoBasicPresenter todoPresenter;
  TodoBasicInteractor(this.todoPresenter);

  @override
  Future<List<TodoViewModel>> getList() async{
    List<Map<String, dynamic>> _results = await DB.todayList(TodoViewModel.table,DateFormatter.getCurrentDate());
    return _results.map((item) => TodoViewModel.fromMap(item)).toList();

  }

  @override
  void deleteItem(TodoViewModel item) async{
    DB.delete(TodoViewModel.table, item);
    todoPresenter.deleteCallback();
  }

  @override
  void saveItem(TodoViewModel item) async{
    await DB.insert(TodoViewModel.table, item);
    todoPresenter.saveCallback();
  }

  @override
  void update(TodoViewModel item) async{
    dynamic result = await DB.update(TodoViewModel.table, item);
    todoPresenter.toggleCallback();
  }

}