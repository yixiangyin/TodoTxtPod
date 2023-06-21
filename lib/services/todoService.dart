import 'package:learn_flutter_demo_app/models/todo.dart';
import 'package:learn_flutter_demo_app/repository/todoRepository.dart';

class TodoService {
  late final TodoRepository todoRepository;

  TodoService() {
    todoRepository = HTTPTodoRepository();
  }

  Future<List<Todo>> getTodos() => todoRepository.getTodos();
}