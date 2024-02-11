import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models/todo.dart';
import 'provider/todolist_provider.dart';

class DetailPage extends ConsumerWidget {
  const DetailPage({super.key, required this.id});
  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Future<Todo> todo =
        ref.watch(todoListProvider.notifier).fetchTodo(id);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Detail Page"),
      ),
      body: Center(
        child: FutureBuilder<Todo>(
          future: todo,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print("Data: ${snapshot.data}");
              return Row(children: <Widget>[
                Text(snapshot.data!.name),
                Checkbox(
                  value: snapshot.data!.completed,
                  onChanged: (bool? value) {
                    ref
                        .read(todoListProvider.notifier)
                        .completeTodo(snapshot.data!);
                  },
                ),
                TextButton(
                    onPressed: () {
                      ref
                          .read(todoListProvider.notifier)
                          .remove(snapshot.data!.id);
                    },
                    child: Text('Delete')),
              ]);
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
