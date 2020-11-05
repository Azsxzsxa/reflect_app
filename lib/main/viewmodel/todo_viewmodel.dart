abstract class TodoModel{
  int id;

  static fromMap() {}
  toMap() {}
}

class TodoViewModel extends TodoModel {
  static String table = 'todo_items';

  int id;
  String task;
  bool complete;
  String date;

  TodoViewModel({this.id, this.task, this.complete,this.date});
  TodoViewModel.empty();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {'task': task, 'complete': complete, 'date':date};

    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  static TodoViewModel fromMap(Map<String, dynamic> map) {
    return TodoViewModel(
        id: map['id'], task: map['task'], complete: map['complete'] == 1,date: map['date']
    );
  }
}
