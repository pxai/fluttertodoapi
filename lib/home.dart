import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertodostate/completed.dart';
import 'package:fluttertodostate/detail.dart';
import 'models/todo.dart';
import 'detail.dart';
import 'add.dart';
import 'provider/todolist_provider.dart';

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Todo> todos = ref.watch(todoListProvider);
    List<Todo> unCompletedTodos =
        todos.where((element) => element.completed == false).toList();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(title),
        ),
        body: ref.watch(todosProvider).when(loading: () {
          return const CircularProgressIndicator();
        }, error: (error, stack) {
          return Text('Error: $error');
        }, data: (data) {
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(data[index].name),
                trailing: Checkbox(
                  value: data[index].completed,
                  onChanged: (bool? value) {
                    ref
                        .read(todoListProvider.notifier)
                        .completeTodo(data[index]);
                  },
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => DetailPage(id: data[index].id)));
                },
              );
            },
          );
        }),
        floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const AddTodo()));
                },
                tooltip: 'Increment',
                child: const Icon(Icons.add),
              ),
              FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          const CompletedPage(title: "Completed Todos")));
                },
                tooltip: 'Completed',
                child: const Icon(Icons.check_circle_outline),
              ),
              FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          const CompletedPage(title: "See detail")));
                },
                tooltip: 'Completed',
                child: const Icon(Icons.check_circle_outline),
              ),
            ]) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
