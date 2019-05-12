import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'todo.dart';

class DB {
    Database database;

    init() async {
        this.database = await openDatabase(
            join(await getDatabasesPath(), 'todo_database.db'),
            onCreate: (db, version) {
                return db.execute(
                    "CREATE TABLE todos(id INTEGER PRIMARY KEY, title TEXT, done INT)",
                );
            },
            version: 1,
        );
    }

    Future<void> insertTodo(ToDo todo) async {
        await database.insert(
            'todos',
            todo.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
        );
    }

    Future<List<ToDo>> todos() async {
        final List<Map<String, dynamic>> maps = await database.query('todos');

        // Convert the List<Map<String, dynamic> into a List<ToDo>.
        return List.generate(maps.length, (i) {
            return ToDo(
                id: maps[i]['id'],
                title: maps[i]['title'],
                done: maps[i]['done'] == 1 ? true : false,
            );
        });
    }

    Future<void> updateTodo(ToDo todo) async {
        await database.update(
            'todos',
            todo.toMap(),
            where: "id = ?",
            whereArgs: [todo.id],
        );
    }

    Future<void> deleteToDo(int id) async {
        await database.delete(
            'todos',
            where: "id = ?",
            whereArgs: [id],
        );
    }
}