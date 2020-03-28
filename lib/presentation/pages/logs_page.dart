import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LogsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Logs Debugger'),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<String>('logs').listenable(),
        builder: (BuildContext context, Box<String> value, Widget child) {
          final logs = value.values.toList().reversed.toList();
          if (logs.isEmpty) {
            return Center(
              child: Text('Nessun log presente'),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.separated(
              itemCount: logs.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    logs[index].substring(0, logs[index].indexOf(' ')),
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  leading: Icon(Icons.add),
                  subtitle:
                      Text(logs[index].substring(logs[index].indexOf(' ') + 1)),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider();
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.clear),
        onPressed: () {
          Hive.box<String>('logs').clear();
        },
      ),
    );
  }
}