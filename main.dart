import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() => runApp(TodoApp());

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      themeMode: ThemeMode.system,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: TodoScreen(),
    );
  }
}

class Todo {
  final String title;
  final DateTime timeStamp;
  bool isDone;

  Todo({
    required this.title,
    required this.timeStamp,
    this.isDone = false,
  });
}

class TodoScreen extends StatefulWidget {
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  List<Todo> todos = [];

  void addTodo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newTodo = '';
        return AlertDialog(
          title: Text('Add Todo'),
          content: TextField(
            onChanged: (value) {
              newTodo = value;
            },
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                setState(() {
                  todos.add(Todo(
                    title: newTodo,
                    timeStamp: DateTime.now(),
                  ));
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void toggleTodoDone(int index) {
    setState(() {
      todos[index].isDone = !todos[index].isDone;
    });
  }

  void removeTodoAtIndex(int index) {
    setState(() {
      todos.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo App'),
      ),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (BuildContext context, int index) {
          final todo = todos[index];
          return Dismissible(
            key: Key(todo.title),
            onDismissed: (direction) {
              removeTodoAtIndex(index);
            },
            child: Card(
              margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ListTile(
                leading: Checkbox(
                  value: todo.isDone,
                  onChanged: (value) {
                    toggleTodoDone(index);
                  },
                ),
                title: Text(
                  todo.title,
                  style: TextStyle(
                    decoration: todo.isDone
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                subtitle: Text(
                  DateFormat.yMMMd().add_jm().format(todo.timeStamp),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    removeTodoAtIndex(index);
                  },
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addTodo,
        child: Icon(Icons.add),
      ),
    );
  }
}
