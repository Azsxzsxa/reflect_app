import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mvp/Utils/date_formatter.dart';
import 'package:flutter_mvp/main/presenter/todo_presenter.dart';
import 'package:flutter_mvp/main/view/todo_edit_component.dart';
import 'package:flutter_mvp/main/viewmodel/todo_categorymodel.dart';
import 'package:flutter_mvp/main/viewmodel/todo_viewmodel.dart';

import 'file:///D:/flutter_workspace/flutter_mvp/lib/main/view/todo_view.dart';

class HomePage extends StatefulWidget {
  final TodoPresenter presenter;

  HomePage(this.presenter, {Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin
    implements TodoView {
  String _taskText = "";
  String _taskDetails = "";
  var _dateTime = new DateTime.now();
  List<TodoViewModel> _tasks = [];
  List<CategoryViewModel> _categories = [];

  List<Widget> get _items => _tasks.map((item) => format(item)).toList();

  TextStyle _style = TextStyle(
      fontSize: 24,
      color: Colors.black54,
      fontFamily: "Quicksand",
      fontWeight: FontWeight.w600);

  bool _detailedText = false;
  bool _categoryTask = false;

  // var _selectedCategory = {
  //   'General': false,
  //   'Routine': false,
  //   'Home': false,
  //   'Work': false
  // };

  Map<String, bool> _selectedCategory = new Map();

  FocusNode detailsFocusNode;

  @override
  void initState() {
    this.widget.presenter.initView = this;
    super.initState();
    detailsFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    detailsFocusNode.dispose();
    super.dispose();
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

  void formatCategory(CategoryViewModel item) {
    Column(
      children: [
        Container(
          color: _selectedCategory[item.name] ? Colors.red : Colors.transparent,
          child: IconButton(
            icon: Icon(item.icon,
                color: _selectedCategory[item.name]
                    ? Colors.white70
                    : Colors.black45,
                size: 30),
            onPressed: () {
              setState(() {
                _selectedCategory[item.name] = !_selectedCategory[item.name];
              });
            },
          ),
        ),
        Text(item.name)
      ],
    );
  }

  void _create(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
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
                          _taskText = value;
                        },
                        autofocus: true,
                      ),
                      AnimatedSizeAndFade(
                        vsync: this,
                        child: _detailedText
                            ? Visibility(
                                visible: true,
                                child: TextField(
                                  focusNode: detailsFocusNode,
                                  decoration: InputDecoration(
                                      hintText: 'More details ...',
                                      border: InputBorder.none),
                                  onChanged: (value) {
                                    _taskDetails = value;
                                  },
                                ),
                              )
                            : Visibility(
                                visible: false,
                                child: Text(''),
                              ),
                        fadeDuration: const Duration(milliseconds: 150),
                        sizeDuration: const Duration(milliseconds: 300),
                      ),
                      AnimatedSizeAndFade(
                        vsync: this,
                        child: _categoryTask
                            ? Visibility(
                                visible: true,
                                child: Container(
                                  width: double.infinity,
                                  child: Container(
                                    height: 70,
                                    child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: [
                                        for (int index = 0;
                                            index < _categories.length;
                                            index++)
                                          Column(
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                                                color: _selectedCategory[
                                                        _categories[index].name]
                                                    ? Colors.red
                                                    : Colors.transparent,
                                                child: IconButton(
                                                  icon: Icon(
                                                      _categories[index].icon,
                                                      color: _selectedCategory[
                                                              _categories[index]
                                                                  .name]
                                                          ? Colors.white70
                                                          : Colors.black45,
                                                      size: 30),
                                                  onPressed: () {
                                                    setState(() {
                                                      _selectedCategory[
                                                              _categories[index]
                                                                  .name] =
                                                          !_selectedCategory[
                                                              _categories[index]
                                                                  .name];
                                                    });
                                                  },
                                                ),
                                              ),
                                              Text(_categories[index].name)
                                            ],
                                          )
                                      ],
                                    ),
                                  ),
                                  // child: SingleChildScrollView(
                                  //   scrollDirection: Axis.horizontal,
                                  //   child: Container(
                                  //     color: Colors.green,
                                  //     child: Row(
                                  //       mainAxisAlignment:
                                  //           MainAxisAlignment.spaceAround,
                                  //       children: [
                                  //         for (int index = 0;
                                  //             index < _categories.length;
                                  //             index++)
                                  //           Column(
                                  //             children: [
                                  //               Container(
                                  //                 color: _selectedCategory[
                                  //                         _categories[index].name]
                                  //                     ? Colors.red
                                  //                     : Colors.transparent,
                                  //                 child: IconButton(
                                  //                   icon: Icon(
                                  //                       _categories[index].icon,
                                  //                       color: _selectedCategory[
                                  //                               _categories[index]
                                  //                                   .name]
                                  //                           ? Colors.white70
                                  //                           : Colors.black45,
                                  //                       size: 30),
                                  //                   onPressed: () {
                                  //                     setState(() {
                                  //                       _selectedCategory[
                                  //                               _categories[index]
                                  //                                   .name] =
                                  //                           !_selectedCategory[
                                  //                               _categories[index]
                                  //                                   .name];
                                  //                     });
                                  //                   },
                                  //                 ),
                                  //               ),
                                  //               Text(_categories[index].name)
                                  //             ],
                                  //           )
                                  //       ],
                                  //     ),
                                  //   ),
                                  // ),
                                ),
                              )
                            : Visibility(
                                visible: false,
                                child: Text(''),
                              ),
                        fadeDuration: const Duration(milliseconds: 150),
                        sizeDuration: const Duration(milliseconds: 300),
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
                                if (_detailedText) {
                                  detailsFocusNode.requestFocus();
                                }
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.category_outlined,
                                color: Colors.black45),
                            tooltip: 'Select category',
                            onPressed: () {
                              setState(() {
                                _categoryTask = !_categoryTask;
                              });
                            },
                          )
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
      if (_taskText.isNotEmpty) {
        String taskDate = DateFormatter.getFormattedDate(_dateTime);
        this.widget.presenter.saveItem(new TodoViewModel(
            task: _taskText,
            details: _taskDetails,
            complete: false,
            date: taskDate));
        _taskText = "";
        _taskDetails = "";
        _dateTime = DateTime.now();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks',
            style: new TextStyle(
                color: Colors.black54,
                fontSize: 25,
                fontWeight: FontWeight.w700)),
        backgroundColor: Colors.white70,
        elevation: 0.0,
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {},
                child: Icon(
                  Icons.card_giftcard_outlined,
                  color: Colors.black54,
                ),
              )),
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  print('calendar top');
                },
                child: Icon(
                  Icons.calendar_today_outlined,
                  color: Colors.black54,
                ),
              )),
        ],
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    height: 75,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          // spreadRadius: 10,
                          blurRadius: 15,
                          offset: Offset(8, 8), // changes position of shadow
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 14.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Today",
                                  style: TextStyle(
                                      fontSize: 22,
                                      color: Color(0xFFF67B50),
                                      // fontFamily: "Quicksand",
                                      fontWeight: FontWeight.w600))),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text("17-11-2020",
                                  style: new TextStyle(
                                      fontSize: 18,
                                      color: Colors.black38,
                                      fontFamily: "Quicksand",
                                      fontWeight: FontWeight.w600))),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 14.0),
                    child: Row(
                      children: [
                        Spacer(flex: 9),
                        Icon(Icons.arrow_back_ios_outlined,
                            color: Colors.black38),
                        Spacer(flex: 1),
                        Icon(Icons.arrow_forward_ios_outlined,
                            color: Colors.black38),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Flexible(child: ListView(children: _items)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _detailedText = false;
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

  @override
  void loadedCategories(List<CategoryViewModel> categoryList) {
    _categories = categoryList;
    _categories.forEach((element) {
      _selectedCategory[element.name] = false;
    });
  }
}
