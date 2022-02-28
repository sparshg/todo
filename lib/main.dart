import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.grey[900],
        colorScheme: ColorScheme.dark(),
        fontFamily: 'Poppins',
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: const [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Text(
                  "To Do",
                  style: TextStyle(
                    fontSize: 52,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ),
            ),
            Expanded(child: Task()),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: null,
          label: Text('Add Task'),
          icon: Icon(Icons.add),
          backgroundColor: Colors.blueGrey[700],
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}

class Task extends StatefulWidget {
  const Task({Key? key}) : super(key: key);

  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> {
  List<String> tasks = [
    "Swipe left to dismiss",
    "Add more",
    "worlde",
    "worldr"
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: tasks.length,
      padding: const EdgeInsets.symmetric(vertical: 16),
      separatorBuilder: (BuildContext context, int index) =>
          const Divider(height: 4),
      itemBuilder: (BuildContext context, int index) {
        BorderRadius _radius = BorderRadius.zero;
        if (tasks.length == 1) {
          _radius = Styles.roundedListBorder;
        } else {
          if (index == 0) {
            _radius = Styles.topListBorder;
          } else if (index == tasks.length - 1) {
            _radius = Styles.bottomListBorder;
          }
        }

        return ClipRRect(
          borderRadius: _radius,
          child: Dismissible(
            background: Container(
              child: Icon(Icons.restore_from_trash_outlined),
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 20),
              color: Colors.red,
            ),
            direction: DismissDirection.endToStart,
            key: UniqueKey(),
            onDismissed: (DismissDirection direction) {
              setState(() {
                tasks.removeAt(index);
              });
            },
            child: Card(
              child: ListTile(
                title: Text(
                  'Item ${tasks[index]}',
                ),
                contentPadding: EdgeInsets.all(12),
              ),
              color: Colors.grey[800],
              margin: EdgeInsets.zero,
            ),
          ),
        );
      },
    );
  }
}

class Styles {
  static const _rounded = 28.0;

  static const topListBorder = BorderRadius.vertical(
    top: Radius.circular(_rounded),
  );
  static const bottomListBorder = BorderRadius.vertical(
    bottom: Radius.circular(_rounded),
  );
  static const roundedListBorder = BorderRadius.all(Radius.circular(_rounded));
}
