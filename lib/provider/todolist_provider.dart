import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/models/todo.dart';

final todoListProvider = StateNotifierProvider<TodoListNotifier, List<Todo>>(
    (ref) => TodoListNotifier());

class TodoListNotifier extends StateNotifier<List<Todo>> {
  TodoListNotifier() : super([]);

  void add(String content) {
    state = [
      ...state,
      Todo(todoId: UniqueKey(), content: content, completed: false)
    ];
    print("Current state: $state");
  }

  void completeTodo(Todo todo) {
    state = [
      for (final item in state)
        if (item.todoId == todo.todoId)
          Todo(
              todoId: todo.todoId,
              content: todo.content,
              completed: !todo.completed)
        else
          item
    ];
  }

  void remove(Key todoId) {
    state = state.where((element) => element.todoId != todoId).toList();
  }
}
