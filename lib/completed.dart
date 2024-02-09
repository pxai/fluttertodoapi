import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models/todo.dart';
import 'provider/todolist_provider.dart';

class CompletedPage extends ConsumerWidget {
  const CompletedPage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Todo> todos = ref.watch(todoListProvider);
    List<Todo> completedTodos =
        todos.where((element) => element.completed == true).toList();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: ListView.builder(
        itemCount: completedTodos.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(completedTodos[index].content),
            trailing: Checkbox(
              value: todos[index].completed,
              onChanged: (bool? value) {
                ref
                    .read(todoListProvider.notifier)
                    .completeTodo(completedTodos[index]);
              },
            ),
            onLongPress: () {
              ref
                  .read(todoListProvider.notifier)
                  .remove(completedTodos[index].todoId);
            },
          );
        },
      ),
    );
  }
}
