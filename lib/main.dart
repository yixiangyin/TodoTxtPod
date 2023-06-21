import 'package:flutter/material.dart';
import 'package:learn_flutter_demo_app/models/todo.dart';
import 'services/todoService.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        )),
      home: const TodoList(),
    );
  }
}

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  late Future<List<Todo>> futureTodosList;
  final Set<Todo> _doneList = <Todo>{};

  @override
  void initState() {
    super.initState();
    futureTodosList = TodoService().getTodos();
  }

  void _pushCompleted() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          final tiles = _doneList.map(
            (todo) {
              return ListTile(
                title: Text(
                  todo.title,
                  style: const TextStyle(fontSize: 18),
                ),
              );
            },
          );
          final divided = tiles.isNotEmpty
              ? ListTile.divideTiles(
                  tiles: tiles,
                  context: context,
                ).toList()
              : <Widget>[];
          return Scaffold(
            appBar: AppBar(
              title: const Text("completed todo list"),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo list"),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: _pushCompleted,
            tooltip: 'completed todo list',
          )
        ],
      ),
      body: FutureBuilder<List<Todo>>(
        future: futureTodosList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final todoList = snapshot.data!;
            return ListView.builder(
              itemCount: todoList.length,
              padding: const EdgeInsets.all(16.0),
              itemBuilder: (context, i) {
                final index = i ~/ 2;
                final todoObj = todoList[index];
                if (i.isOdd) return const Divider();
                final completed = _doneList.contains(todoObj);
                return ListTile(
                    title: Text(
                      todoObj.title,
                      style: TextStyle(
                          fontSize: 18,
                          decoration: completed
                              ? TextDecoration.lineThrough
                              : TextDecoration.none),
                    ),
                    onTap: (() {
                      setState(() {
                        if (completed) {
                          _doneList.remove(todoObj);
                        } else {
                          _doneList.add(todoObj);
                        }
                      });
                    }));
              },
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
