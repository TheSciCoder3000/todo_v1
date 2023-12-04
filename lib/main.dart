import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_v1/Todo.dart';
import 'package:vibration/vibration.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TodoPage(),
    );
  }
}

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {

  List<Todo> todoList = [];

  void showToast({String text = "Tara Sir Jopak, Kape tayo"}) {
    CherryToast.success(
      toastDuration: const Duration(milliseconds: 5000),
      title: Text(text, style: const TextStyle(color: Colors.black))
    ).show(context);
  }

  void removeItem(int id) {
    setState(() {
      todoList = todoList.where((todoItem) => todoItem.id != id).toList();
      vibrateMe();
    });
  }

  Future<void> vibrateMe() async {
    if (await Vibration.hasVibrator() as bool) {
        Vibration.vibrate();
    }
  }

  void initializeList() {
    setState(() {
      todoList = [
        Todo(0, "Eat breakfast", false),
        Todo(1, "Go to sleep", false),
        Todo(2, "Invite Sir Jopak to Starbucks", false),
        Todo(3, "Eat lunch", true),
        Todo(4, "Play games", false),
        Todo(5, "Sleep again", false),
        Todo(6, "Please let me sleep", false),
        Todo(7, "Next Sem nlang Please", false),
      ];
    });
  }

  @override
  void initState() {
    initializeList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vibrating Todo list /w Toast"),
        backgroundColor: Colors.greenAccent,
        actions: [
          IconButton(
            onPressed: initializeList, 
            icon: const Icon(Icons.refresh)
          )
        ],
      ),
      body: ListView(
        children: todoList.map((todoItem) => TodoItem(
          title: todoItem.title,
          status: todoItem.status,
          onDelete: () => removeItem(todoItem.id),
          onToggle: () => (todoItem.id == 5 || todoItem.id == 2) ? showToast(text: "Tama na yan") : showToast(),
        )).toList(),
      ),
    );
  }
}


class TodoItem extends StatelessWidget {
  const TodoItem({super.key, required this.title, required this.status, this.onDelete, this.onToggle});
  final String title;
  final bool status;
  final VoidCallback? onDelete;
  final VoidCallback? onToggle;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: const ValueKey(0),
        startActionPane: ActionPane(
          extentRatio: 0.32,
          motion: const ScrollMotion(), 
          children: [
            SlidableAction(
              autoClose: true,
              onPressed: (context) => onDelete!(),
              icon: Icons.delete,
              label: "Delete",
              backgroundColor: Colors.redAccent,
            )
          ]
        ),
        endActionPane: ActionPane(
          motion: const ScrollMotion(), 
          extentRatio: 0.18,
          children: [
            SlidableAction(
              autoClose: true,
              icon: Icons.check,
              backgroundColor: Colors.amber,
              onPressed: (context) => onToggle!(),
            )
          ]
        ),
      child: ListTile(
        title: Text(title),
      ),
    );
  }
}