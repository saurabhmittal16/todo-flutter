import 'package:flutter/material.dart';

void main() {
    runApp(
        MaterialApp(
            title: 'To-Do List',
            home: MyApp(),
        )
    );
}

typedef void VoidCallback(int i);

class ToDo {
    String title;
    bool done;

    ToDo({this.title, this.done});
}

class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text('To-Do App'),
                actions: <Widget>[
                    IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                            print('Add new to-do');
                        },
                    )
                ],
            ),
            body: ToDoList(
                todos: <ToDo>[
                    ToDo(title: 'Eat', done: false),
                    ToDo(title: 'Sleep', done: false),
                    ToDo(title: 'Repeat', done: false),
                ],
            )
        );
    }
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
        setState(() {
            todos.add(
                ToDo(title: text, done: false)
            );
        });
    }

    void removeToDo(int i) {
        setState(() {
            todos.removeAt(i);
        });
    }

    void setToDoStatus(int i) {
        setState(() {
          todos[i] = ToDo(
            title: todos[i].title,
            done: !todos[i].done
          );
        });
    }

    @override
    Widget build(BuildContext context) {
        return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (BuildContext context, int index) {
                return ToDoListItem(
                    index: index, 
                    todo: todos[index],
                    onRemove: removeToDo,
                    onChangeDone: setToDoStatus
                );
            }
        );
    }
}

class ToDoListItem extends StatelessWidget {
    final ToDo todo;
    final int index;
    final VoidCallback onRemove;
    final VoidCallback onChangeDone;

    ToDoListItem({
        @required this.todo, 
        @required this.index, 
        @required this.onRemove,
        @required this.onChangeDone
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
                                print('Set $index');
                                onChangeDone(index);
                            },
                            child: Text(
                                todo.title,
                                style:  _getTextStyle(context)
                            ),
                        )
                    ),
                    IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                            print('Deleting $index');
                            onRemove(index);
                        },
                    )
                ],
            )
        );
    }
}