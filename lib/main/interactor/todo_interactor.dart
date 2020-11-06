
import 'package:flutter_mvp/Utils/date_formatter.dart';
import 'package:flutter_mvp/main/presenter/todo_presenter.dart';
import 'package:flutter_mvp/main/viewmodel/todo_viewmodel.dart';
import 'package:flutter_mvp/service/db.dart';

class InteractorListener{
  void onUpdateSuccess(){}
}

class TodoInteractor{
  TodoPresenter todoPresenter;
  TodoInteractor(this.todoPresenter);

  Future<List<TodoViewModel>> getList() async{
    List<Map<String, dynamic>> _results = await DB.todayList(TodoViewModel.table,DateFormatter.getCurrentDate());
    return _results.map((item) => TodoViewModel.fromMap(item)).toList();

  }

  void deleteItem(TodoViewModel item) async{
    DB.delete(TodoViewModel.table, item);
    todoPresenter.onUpdateSuccess();
  }

  void saveItem(TodoViewModel item) async{
    await DB.insert(TodoViewModel.table, item);
    todoPresenter.onUpdateSuccess();
  }

  void update(TodoViewModel item) async{
    await DB.update(TodoViewModel.table, item);
    todoPresenter.onUpdateSuccess();
  }

}