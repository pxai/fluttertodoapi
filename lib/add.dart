import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'provider/todolist_provider.dart';

class AddTodo extends ConsumerWidget {
  const AddTodo({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController controller = TextEditingController();
    return Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(labelText: 'Enter Todo'),
            ),
          ),
          TextButton(
              onPressed: () {
                // how to get todoListProvider.notifier
                ref.read(todoListProvider.notifier).add(controller.text);
                Navigator.of(context).pop();
              },
              child: Text('Add Todo'))
        ])));
  }
}
