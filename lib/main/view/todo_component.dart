import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mvp/Utils/date_formatter.dart';
import 'package:flutter_mvp/main/presenter/todo_presenter.dart';
import 'package:flutter_mvp/main/view/todo_edit_component.dart';
import 'package:flutter_mvp/main/viewmodel/todo_viewmodel.dart';

import 'file:///D:/flutter_workspace/flutter_mvp/lib/main/view/todo_view.dart';

class HomePage extends StatefulWidget {
  final TodoPresenter presenter;

  HomePage(this.presenter, {Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> implements TodoView {
  String _task="";
  var _dateTime = new DateTime.now();
  List<TodoViewModel> _tasks = [];

  List<Widget> get _items => _tasks.map((item) => format(item)).toList();
  TextStyle _style = TextStyle(fontSize: 24, color: Colors.black);

  bool _detailedText = false;

  @override
  void initState() {
    this.widget.presenter.initView = this;
    super.initState();
  }

  Widget format(TodoViewModel item) {
    return Dismissible(
      key: Key(item.id.toString()),
      child: Padding(
        padding: EdgeInsets.fromLTRB(12, 6, 12, 4),
        // child: FlatButton(
        child:
            Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          // Icon(item.complete == true ? Icons.radio_button_checked : Icons.radio_button_unchecked),
          Checkbox(
            value: item.complete,
            onChanged: (bool newValue) {
              print('new value: $newValue');
              item.complete = newValue;
              // _toggle(item);
              this.widget.presenter.toggleItem(item);
              // _toggle(item);
            },
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Container(
                    child: Stack(
                  alignment: Alignment.centerLeft,
                  children: <Widget>[
                    SizedBox(
                      width: double.infinity,
                      child: FlatButton(
                        onPressed: () => {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return EditTodoScreen(
                                task: item, presenter: this.widget.presenter);
                          }))
                        },
                        child: null,
                      ),
                    ),
                    IgnorePointer(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: RichText(
                          text: TextSpan(
                            text: item.task,
                            style: _style,
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
              ],
            ),
          ),
        ]),
      ),
      onDismissed: (DismissDirection direction) {
        _tasks.remove(item);
        this.widget.presenter.deleteItem(item);
      },
    );
  }

  void _create(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            decoration: InputDecoration(
                                hintText: 'Today I will ...',
                                border: InputBorder.none),
                            onChanged: (value) {
                              _task = value;
                            },
                            autofocus: true,
                          ),
                          Visibility(
                            visible: _detailedText,
                            child: TextField(
                              decoration: InputDecoration(
                                  hintText: 'More details ...',
                                  border: InputBorder.none),
                              onChanged: (value) {
                                _task = value;
                              },
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.calendar_today_outlined,
                                    color: Colors.black45),
                                tooltip: 'Increase volume by 10',
                                onPressed: () {
                                  showDatePicker(
                                      context: context,
                                      initialDate: _dateTime == null
                                          ? DateTime.now()
                                          : _dateTime,
                                      firstDate: DateTime(2001),
                                      lastDate: DateTime(2021))
                                      .then((date) {
                                    setState(() {
                                      _dateTime = date;
                                    });
                                  });
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.article_outlined,
                                    color: Colors.black45),
                                tooltip: 'Add details',
                                onPressed: () {
                                  setState(() {
                                    _detailedText = !_detailedText;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              );
            });
      },
    ).whenComplete(() {
      if(_task.isNotEmpty){
        String taskDate =
        DateFormatter.getFormattedDate(_dateTime);
        this.widget.presenter.saveItem(
            new TodoViewModel(
                task: _task,
                complete: false,
                date: taskDate));
        _task = "";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tasks')),
      body: Center(child: ListView(children: _items)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _create(context);
        },
        tooltip: 'New TODO',
        child: Icon(Icons.library_add),
      ),
    );
  }

  @override
  void refreshList(List<TodoViewModel> todoList) {
    print('refresh list');
    _tasks = todoList;
    setState(() {});
  }

// void _checkboxPress(TodoViewModel item){
//   this.widget.presenter.toggleItem(item);
// }
//
// void _toggle(TodoViewModel item) async {
//   // item.complete = !item.complete;
//   dynamic result = await DB.update(TodoViewModel.table, item);
//   print(result);
//   refresh();
// }
//
// void _delete(TodoViewModel item) async {
//   DB.delete(TodoViewModel.table, item);
//   refresh();
// }
//
// void _save() async {
//   Navigator.of(context).pop();
//   TodoViewModel item = TodoViewModel(task: _task, complete: false);
//
//   await DB.insert(TodoViewModel.table, item);
//   setState(() => _task = '');
//   refresh();
// }

// void refresh() async {
//   List<Map<String, dynamic>> _results = await DB.query(TodoViewModel.table);
//   _tasks = _results.map((item) => TodoViewModel.fromMap(item)).toList();
//   setState(() {});
// }
// @override
// void refreshList(List<TodoViewModel> todoList) async {
//   // List<Map<String, dynamic>> _results = await DB.query(TodoViewModel.table);
//   // _tasks = _results.map((item) => TodoViewModel.fromMap(item)).toList();
//   _tasks = todoList;
//   setState(() {});
// }
}