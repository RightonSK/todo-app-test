import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app2/main_model.dart';

class AddPage extends StatelessWidget {
  final MainModel model;
  AddPage(this.model);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MainModel>.value(
      value: model,
      child: Scaffold(
        appBar: AppBar(
          title: Text('新規追加'),
        ),
        body: Consumer<MainModel>(builder: (context, model, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: "追加するtodo",
                    hintText: 'ゴミを出す',
                  ),
                  onChanged: (text) {
                    model.newTodoText = text;
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                RaisedButton(
                    child: Text('追加する'),
                    onPressed: () async {
                      //todo: firestoreに値を追加する
                      await model.add();
                      Navigator.pop(context);
                    }),
                SizedBox(
                  height: 16,
                ),
                TextField(
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person),
                    hintText: 'What do people call you?',
                    hintStyle:
                        TextStyle(height: 7, fontWeight: FontWeight.bold),
                    labelText: 'Name *',
                    labelStyle:
                        TextStyle(height: 5, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
