import 'package:flutter/material.dart';
import 'package:learn_flutter_demo_app/models/todo.dart';
import 'services/todoService.dart';
import './utils/dialog_box.dart';

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

  // text controller
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureTodosList = TodoService().getTodos();
    futureTodosList.then((todos) {
      for (Todo todo in todos) {
        if (todo.completed) {
          setState(() {
            _doneList.add(todo);
          });
        }
      }
    });
  }

  void saveNewTask() {
    setState(() {
      futureTodosList.then((todos) {
        todos.add(new Todo(
            userId: 0, id: 0, title: _controller.text, completed: false));
      });
      _controller.clear();
    });
    Navigator.of(context).pop();
    // TODO: update storage to ensure persistence
    
  }

  // create a new task
  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
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
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: Icon(Icons.add),
      ),
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
                // if (todoList[index].completed) {
                //   setState(() {
                //     _doneList.add(todoList[index]);
                //   });
                // }
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
