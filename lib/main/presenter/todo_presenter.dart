import 'file:///D:/flutter_workspace/flutter_mvp/lib/main/interactor/todo_interactor.dart';
import 'file:///D:/flutter_workspace/flutter_mvp/lib/main/view/todo_view.dart';
import 'package:flutter_mvp/main/viewmodel/todo_viewmodel.dart';

class TodoPresenter{
  set initView(TodoView value){}

  void deleteItem(TodoViewModel item){}
  void toggleItem(TodoViewModel item){}
  void updateItem(int id, String task,String description, String date){}
  void saveItem(TodoViewModel item){}
  void refresh(){}

}

class TodoBasicPresenter implements TodoPresenter{
  TodoView _view;
  List<TodoViewModel> _todoList;
  TodoBasicInteractor todoBasicInteractor;

  TodoBasicPresenter() {
    this._todoList = [];
    this.todoBasicInteractor = new TodoBasicInteractor(this);
    // _loadList();
  }

  void _loadList() async{
    _todoList = await todoBasicInteractor.getList();
    print('load list presenter $_todoList');
    _view.refreshList(_todoList);
  }

  @override
  set initView(TodoView value) {
    _view = value;
    _loadList();

  }

  void toggleCallback(){
    refresh();
    _view.refreshList(_todoList);
  }

  void saveCallback(){
    refresh();
    _view.refreshList(_todoList);
  }

  void deleteCallback(){
    refresh();
    _view.refreshList(_todoList);
  }



  @override
  void deleteItem(TodoViewModel item){
    todoBasicInteractor.deleteItem(item);
  }

  @override
  void toggleItem(TodoViewModel item){
    todoBasicInteractor.update(item);
  }

  @override
  void updateItem(int id, String task,String description, String date) {
    TodoViewModel updatedTask = new TodoViewModel();
    updatedTask.id = id;
    updatedTask.task = task;
    updatedTask.date = date;
    todoBasicInteractor.update(updatedTask);
  }

  @override
  void saveItem(TodoViewModel item){
    todoBasicInteractor.saveItem(item);
  }

  @override
  void refresh() async{
    List<TodoViewModel> tasklist = await todoBasicInteractor.getList();
    _todoList = tasklist;
    _view.refreshList(_todoList);
  }




  
}