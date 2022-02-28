import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskData extends ChangeNotifier {
  static late SharedPreferences _prefs;
  static Future init() async => _prefs = await SharedPreferences.getInstance();
  static const String _key = 'tasks';
  static Future saveList(List<String> newVal) async =>
      await _prefs.setStringList(_key, newVal);
  static List<String>? getList() => _prefs.getStringList(_key);

  final List<String> _taskList = getList() ??
      [
        "Swipe left to dismiss",
        "Long press to edit",
        "Try adding more tasks!",
        "More features soon :)",
      ];

  List<String> get taskList => _taskList;

  void add(String task) {
    _taskList.add(task);
    saveList(_taskList);
    notifyListeners();
  }

  void remove(int index) {
    _taskList.removeAt(index);
    saveList(_taskList);
    notifyListeners();
  }

  void edit(int index, String val) {
    _taskList[index] = val;
    saveList(_taskList);
    notifyListeners();
  }
}
