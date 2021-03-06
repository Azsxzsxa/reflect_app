import 'package:flutter_mvp/main/viewmodel/todo_categorymodel.dart';
import 'package:flutter_mvp/main/viewmodel/todo_viewmodel.dart';

import 'file:///D:/flutter_workspace/flutter_mvp/lib/main/interactor/todo_interactor.dart';
import 'file:///D:/flutter_workspace/flutter_mvp/lib/main/view/todo_view.dart';

// class TodoPresenter{
//   set initView(TodoView value){}
//
//   void deleteItem(TodoViewModel item){}
//   void toggleItem(TodoViewModel item){}
//   void updateItem(int id, String task,String description, String date){}
//   void saveItem(TodoViewModel item){}
//   void refresh(){}
//
// }

class TodoPresenter implements InteractorListener {
  TodoView _view;
  List<TodoViewModel> _todoList;
  List<CategoryViewModel> _categoryList;
  TodoInteractor todoBasicInteractor;

  TodoPresenter() {
    this._todoList = [];
    this.todoBasicInteractor = new TodoInteractor(this);
  }

  void _loadList() async {
    _categoryList = await todoBasicInteractor.getCategoryList();
    _todoList = await todoBasicInteractor.getList();


    Map<String, List<TodoViewModel>> tasksMap = new Map();

    _todoList.forEach((element) {
      if (tasksMap[element.category] == null) {
        tasksMap[element.category] = [];
      }
      tasksMap[element.category].add(element);
    });
    _view.refreshList(tasksMap,_categoryList);
    // _view.loadedCategories(_categoryList);
  }

  set initView(TodoView value) {
    _view = value;
    _loadList();
  }

  void deleteItem(TodoViewModel item) {
    todoBasicInteractor.deleteItem(item);
  }

  void toggleItem(TodoViewModel item) {
    todoBasicInteractor.update(item);
  }

  void updateItem(int id, bool complete, String task, String details,
      String date, String category) {
    TodoViewModel updatedTask = new TodoViewModel();
    updatedTask.id = id;
    updatedTask.complete = complete;
    updatedTask.task = task;
    updatedTask.details = details;
    updatedTask.date = date;
    updatedTask.category = category;
    todoBasicInteractor.update(updatedTask);
  }

  void saveItem(TodoViewModel item) {
    todoBasicInteractor.saveItem(item);
  }

  @override
  void onUpdateSuccess() async {
    _todoList = await todoBasicInteractor.getList();
    _categoryList = await todoBasicInteractor.getCategoryList();
    Map<String, List<TodoViewModel>> tasksMap = new Map();

    _todoList.forEach((element) {
      if (tasksMap[element.category] == null) {
        tasksMap[element.category] = [];
      }
      tasksMap[element.category].add(element);
    });

    _view.refreshList(tasksMap,_categoryList);
  }
}
