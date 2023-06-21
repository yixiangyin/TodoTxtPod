class Todo {
  final int userId;
  final int id;
  final String title;
  final bool completed;

  const Todo({
    required this.userId,
    required this.id,
    required this.title,
    required this.completed,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      completed: json['completed'],
    );
  }
  factory Todo.fromTxt(String txt) {
    bool completed = false;
    String title = txt;
    if (txt.startsWith("x ")) {
      completed = true;
      title = txt.substring(2);
    }

    return Todo(
      userId: 0, // TODO
      id: 0,
      title: title,
      completed: completed,
    );
  }
}
