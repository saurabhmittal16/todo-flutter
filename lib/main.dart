import 'package:flutter/material.dart';

void main() {
    runApp(
        MaterialApp(
            title: 'To-Do List',
            home: MyApp(),
        )
    );
}

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
            body: Home(
                todos: <ToDo>[
                    ToDo(title: 'Eat', done: false),
                    ToDo(title: 'Sleep', done: false),
                    ToDo(title: 'Repeat', done: false),
                ],
            )
        );
    }
}

class Home extends StatefulWidget {
    Home({this.todos});
    final todos;

    @override
    _HomeState createState() => _HomeState(todos);
}

class _HomeState extends State<Home> {
    List<ToDo> todos;
    _HomeState(this.todos);

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

    @override
    Widget build(BuildContext context) { 
        return ToDoList(todos: this.todos,);
    }
}

class ToDoList extends StatelessWidget {
    final List<ToDo> todos;

    ToDoList({@required this.todos,});

    Widget buildbody(BuildContext context, int index) {
        return ListTile(
            leading: CircleAvatar(child: Text(todos[index].title[0]),),
            title: Row(
                key: Key('$index'),
                children: <Widget>[
                    Expanded(
                        child: GestureDetector(
                            onTap: () {
                                print('Set $index');
                            },
                            child: Text(todos[index].title),
                        )
                    ),
                    IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                            print('Deleting $index');
                        },
                    )
                ],
            )
        );
    }

    @override
    Widget build(BuildContext context) {
        return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (BuildContext context, int index) => buildbody(context, index)
        );
    }
}