import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mvp/Utils/date_formatter.dart';
import 'package:flutter_mvp/main/presenter/todo_presenter.dart';
import 'package:flutter_mvp/main/viewmodel/todo_viewmodel.dart';

class EditTodoScreen extends StatefulWidget {
  final TodoViewModel task;
  final TodoPresenter presenter;

  EditTodoScreen({Key key, @required this.task, @required this.presenter})
      : super(key: key);

  @override
  _EditTodoScreenState createState() => _EditTodoScreenState();
}

class _EditTodoScreenState extends State<EditTodoScreen> {
  DateTime _dateTime = new DateTime.now();
  String _displayDate;
  String _displayTask;
  String _displayDescription;

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () async {
          updateItem();
          Navigator.of(context).pop();
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () {
                updateItem();
                Navigator.of(context).pop();
              },
            ),
            actions: [
              Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      print('icon top');
                      updateItem();
                    },
                    child: Icon(
                      Icons.search,
                      size: 26.0,
                    ),
                  )),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  TextFormField(
                      style: TextStyle(fontSize: 25),
                      onChanged: (text) {
                        _displayTask = text;
                      },
                      controller: setInitialText(_displayTask == null
                          ? widget.task.task
                          : _displayTask),
                      decoration: InputDecoration(border: InputBorder.none)),
                  TextFormField(
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Add Deatils',
                          icon: Icon(Icons.article_outlined))),
                  Container(
                    child: Stack(
                      children: [
                        TextFormField(
                            style: TextStyle(fontSize: 20),
                            controller: setInitialText(_displayDate == null
                                ? widget.task.date
                                : _displayDate),
                            enabled: false,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Add Deatils',
                                icon: Icon(Icons.calendar_today_outlined))),
                        SizedBox(
                          width: double.infinity,
                          child: FlatButton(
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
                                  setSelectedDate(date);
                                });
                              });
                            },
                            child: null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  setSelectedDate(DateTime date) {
    _displayDate = DateFormatter.getFormattedDate(date);
    _dateTime = date;
  }

  setInitialText(String s) {
    return TextEditingController(text: s);
  }

  updateItem() {
    if (_displayTask == null) {
      _displayTask = widget.task.task;
    }
    if (_displayDate == null) {
      _displayDate = widget.task.date;
    }
    this
        .widget
        .presenter
        .updateItem(widget.task.id, _displayTask, '', _displayDate);
  }
}
