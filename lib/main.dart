import 'package:flutter/material.dart';

import 'todo.dart';
import 'db.dart';

var db = new DB();

void main() async {
    await db.init();

    runApp(
        MaterialApp(
            title: 'To-Do List',
            home: ToDoList(
                todos: await db.todos(),
            ),
        )
    );
}

class ToDoList extends StatefulWidget {
    ToDoList({this.todos});
    final todos;

    @override
    _ToDoListState createState() => _ToDoListState(todos);
}

class _ToDoListState extends State<ToDoList> {
    List<ToDo> todos;
    _ToDoListState(this.todos);

    void addToDo(String text) {
        var temp = ToDo(title: text, done: false, id: todos.length+1);
        setState(() {
            todos.add(temp);
        });
        db.insertTodo(temp);
    }

    void removeToDo(int id) {
        setState(() {
            todos = todos.where((t) => t.id != id).toList();
        });
        db.deleteToDo(id);
    }

    void setToDoStatus(int id) {
        int i;
        for(i=0; i<todos.length; i++) {
            if (todos[i].id == id) {
                setState(() {
                    todos[i].toggleDone();
                });
                break;
            }
        }
        db.updateTodo(todos[i]);
    }

    void updateToDo(int id, String newValue) {
        int i;
        for(i=0; i<todos.length; i++) {
            if (todos[i].id == id) {
                setState(() {
                    todos[i].setTitle(newValue);
                });
                break;
            }
        }
        db.updateTodo(todos[i]);
    }

    // build body for the home
    Widget buildBody(BuildContext context) {
        if (todos.length > 0) {
            return ListView.builder(
                itemCount: todos.length,
                itemBuilder: (BuildContext context, int index) {
                    return ToDoListItem(
                        index: index, 
                        todo: todos[index],
                        onRemove: removeToDo,
                        onChangeDone: setToDoStatus,
                        onUpdate: updateToDo
                    );
                }
            );
        } else {
            return Center(
                child: Text('Nothing on your list'),
            );
        }
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text('To-Do App'),
                actions: <Widget>[
                    IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () async {
                            String response = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => NewToDoListItem())
                            );
                            if (response != null) {
                                addToDo(response);
                            }
                        },
                    )
                ],
            ),
            body: buildBody(context)
        );
    }
}

class ToDoListItem extends StatelessWidget {
    final ToDo todo;
    final int index;
    final onRemove;
    final onChangeDone;
    final onUpdate;

    ToDoListItem({
        @required this.todo, 
        @required this.index, 
        @required this.onRemove,
        @required this.onChangeDone,
        @required this.onUpdate
    });

    TextStyle _getTextStyle(BuildContext context) {
        if (!todo.done) return null;

        return TextStyle(
            color: Colors.black54,
            decoration: TextDecoration.lineThrough,
        );
    }

    Color _getColor(BuildContext context) {
        return todo.done ? Colors.black54 : Theme.of(context).primaryColor;
    }

    @override
    Widget build(BuildContext context) {
        return ListTile(
            leading: CircleAvatar(
                child: Text(todo.title[0]),
                backgroundColor: _getColor(context),
            ),
            title: Row(
                key: Key('$index'),
                children: <Widget>[
                    Expanded(
                        child: GestureDetector(
                            onTap: () {
                                onChangeDone(todo.id);
                            },
                            child: Text(
                                '${todo.id}. ${todo.title}',
                                style:  _getTextStyle(context)
                            ),
                        )
                    ),
                    IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () async {
                            String response = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => UpdateToDoListItem(todo.title))
                            );
                            if (response != null) {
                                onUpdate(todo.id, response);
                                // Show snackbar on updating
                                Scaffold.of(context)
                                    ..removeCurrentSnackBar()
                                    ..showSnackBar(SnackBar(
                                        content: Text('Updated'),
                                    ));
                            }
                        },
                    ),
                    IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                            onRemove(todo.id);
                            // Show snackbar on deleting
                            Scaffold.of(context)
                                ..removeCurrentSnackBar()
                                ..showSnackBar(SnackBar(
                                    content: Text('Deleted'),
                                ));
                        },
                    )
                ],
            )
        );
    }
}

class NewToDoListItem extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text('Add To-Do'),
            ),
            body: ToDoListItemForm(null)
        );
    }
}

class UpdateToDoListItem extends StatelessWidget {
    final String initialValue;
    UpdateToDoListItem(this.initialValue);

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text('Update To-Do'),
            ),
            body: ToDoListItemForm(initialValue)
        );
    }
}

class ToDoListItemForm extends StatefulWidget {
    final String initialValue;
    ToDoListItemForm(this.initialValue);

    @override
    _ToDoListItemFormState createState() => _ToDoListItemFormState(this.initialValue);
}

class _ToDoListItemFormState extends State<ToDoListItemForm> {
    final _formKey = GlobalKey<FormState>();
    final String intitialValue;
    TextEditingController _controller;

    _ToDoListItemFormState(this.intitialValue);

    @override
    void initState() {
        super.initState();
        _controller = new TextEditingController(text: intitialValue);
    }

    @override
    Widget build(BuildContext context) {
        return Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                        TextFormField(
                            controller: _controller,
                            validator: (value) {
                                if (value.isEmpty) {
                                    return 'Please enter some text';
                                }
                            },
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: RaisedButton(
                                onPressed: () {
                                    if (_formKey.currentState.validate()) {
                                        Navigator.pop(context, _controller.text);
                                    }
                                },
                                child: Text('Submit'),
                            ),
                        ),
                    ],
                ),
            ),
        );
    }
}