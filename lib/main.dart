import 'styles.dart';
import 'taskdata.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await TaskData.init();
  runApp(
    ChangeNotifierProvider(
      create: (context) => TaskData(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do',
      theme: Styles.themeData,
      home: MyHomePage(title: 'To-Do'),
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
          children: [
            const Align(
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
            Divider(color: Colors.transparent),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                // onPrimary: darkerGreen,
                primary: Colors.transparent,
                onPrimary: Theme.of(context).colorScheme.primary,
                shape: const StadiumBorder(),
                padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
                side: BorderSide(
                  width: 2.5,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              label: Text('Add Task', style: TextStyle(fontSize: 20)),
              icon: Icon(Icons.add, size: 32),
              onPressed: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) => Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    child: Popup(),
                  ),
                );
              },
            ),
            Divider(color: Colors.transparent),
          ],
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
  @override
  Widget build(BuildContext context) {
    final tasks = context.watch<TaskData>().taskList;

    if (tasks.length == 0) {
      return Column(
        children: [
          Spacer(),
          Icon(Icons.add, size: 256, color: Styles.grey),
          Text(
            "Add a new task\nSwipe left to mark complete\nLong press to edit",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
          ),
          Spacer(flex: 2),
        ],
      );
    }

    return ClipRRect(
      borderRadius: Styles.roundedListBorder,
      child: ListView.separated(
        physics: BouncingScrollPhysics(),
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
                child: Icon(Icons.check, size: 32),
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: 32),
                color: Colors.green,
              ),
              direction: DismissDirection.horizontal,
              key: UniqueKey(),
              onDismissed: (DismissDirection direction) {
                setState(() {
                  context.read<TaskData>().remove(index);
                });
              },
              child: Card(
                child: ListTile(
                  title: Text(
                    tasks[index],
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  onLongPress: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (BuildContext context) => Padding(
                        padding: MediaQuery.of(context).viewInsets,
                        child:
                            Popup(edit: true, index: index, val: tasks[index]),
                      ),
                    );
                  },
                ),
                color: Styles.grey,
                margin: EdgeInsets.zero,
              ),
            ),
          );
        },
      ),
    );
  }
}

class Popup extends StatefulWidget {
  const Popup({Key? key, this.val = '', this.index, this.edit = false})
      : super(key: key);
  final String val;
  final int? index;
  final bool edit;

  @override
  State<Popup> createState() => _PopupState();
}

class _PopupState extends State<Popup> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.value = TextEditingValue(text: widget.val);
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Styles.grey,
        borderRadius: Styles.topListBorder,
      ),
      child: Padding(
        padding: EdgeInsets.all(36),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "Add new task",
              style: TextStyle(fontSize: 36),
            ),
            TextField(
              controller: _controller,
              autofocus: true,
              onSubmitted: (String value) {
                widget.edit
                    ? context.read<TaskData>().edit(widget.index!, value)
                    : context.read<TaskData>().add(value);
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      ),
    );
  }
}
