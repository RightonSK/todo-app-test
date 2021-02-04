import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_app2/todo.dart';

class MainModel extends ChangeNotifier {
  List<Todo> todoList = [];
  String newTodoText = '';

  //One-time Read
  Future getTodoList() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('todoList').get();
    final docs = snapshot.docs;
    final todoList = docs.map((doc) => Todo(doc)).toList();
    this.todoList = todoList;
    print('bbb');
    print(todoList.length);
    notifyListeners();
  }

  //Realtime changes
  void getTodoListRealtime() {
    final snapshots =
        FirebaseFirestore.instance.collection('todoList').snapshots();
    snapshots.listen((snapshot) {
      final docs = snapshot.docs;
      final todoList = docs.map((doc) => Todo(doc)).toList();
      todoList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      this.todoList = todoList;
      notifyListeners();
    });
  }

  Future add() async {
    final collection = FirebaseFirestore.instance.collection('todoList');
    await collection.add({
      'title': newTodoText,
      'createdAt': Timestamp.now(),
    });
  }

  void reload() {
    notifyListeners();
  }

  Future deleteCheckedItems() async {
    final checkedItems = todoList.where((todo) => todo.isDone).toList();
    final references =
        checkedItems.map((todo) => todo.documentReference).toList();

    WriteBatch batch = FirebaseFirestore.instance.batch();

    references.forEach((reference) {
      batch.delete(reference);
    });

    return batch.commit();
  }

  bool checkShouldActiveComleteButton() {
    final checkedItems = todoList.where((todo) => todo.isDone).toList();
    return checkedItems.length > 0;
  }
}
