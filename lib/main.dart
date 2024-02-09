import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertodostate/completed.dart';
import 'add.dart';
import 'completed.dart';
import 'models/todo.dart';
import 'provider/todolist_provider.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Todo App'),
    );
  }
}

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
        body: ListView.builder(
          itemCount: unCompletedTodos.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(unCompletedTodos[index].content),
              trailing: Checkbox(
                value: todos[index].completed,
                onChanged: (bool? value) {
                  ref
                      .read(todoListProvider.notifier)
                      .completeTodo(unCompletedTodos[index]);
                },
              ),
              onLongPress: () {
                ref
                    .read(todoListProvider.notifier)
                    .remove(unCompletedTodos[index].todoId);
              },
            );
          },
        ),
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
            ]) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
