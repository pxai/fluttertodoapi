import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '/models/todo.dart';

final todosProvider = StreamProvider.autoDispose<List<Todo>>((ref) async* {
  final response = await http.get(Uri.parse('http://localhost:3000/data'));
  if (response.statusCode == 200) {
    final List<Todo> todos = (jsonDecode(response.body) as List)
        .map((data) => Todo.fromJson(data))
        .toList();
    yield todos;
  } else {
    throw Exception('Failed to load todos');
  }
});

final todoListProvider = StateNotifierProvider<TodoListNotifier, List<Todo>>(
    (ref) => TodoListNotifier());

class TodoListNotifier extends StateNotifier<List<Todo>> {
  TodoListNotifier() : super([]);

  Future<Todo> fetchTodos() async {
    final response = await http.get(Uri.parse('http://localhost:3000/data'));

    if (response.statusCode == 200) {
      return Todo.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load todo');
    }
  }

  Future<Todo> fetchTodo(int id) async {
    final response =
        await http.get(Uri.parse('http://localhost:3000/show/$id'));

    if (response.statusCode == 200) {
      return Todo.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load todo');
    }
  }

  Future<List<Todo>> fetchTodosMock() async {
    await Future.delayed(Duration(seconds: 2));
    return [
      Todo(
        id: 1,
        name: 'Buy milk',
        completed: false,
      ),
      Todo(
        id: 2,
        name: 'Buy eggs',
        completed: true,
      ),
      Todo(
        id: 3,
        name: 'Buy bread',
        completed: false,
      ),
    ];
  }

  void add(int id, String name) {
    state = [...state, Todo(id: id, name: name, completed: false)];
    print("Current state: $state");
  }

  void completeTodo(Todo todo) {
    state = [
      for (final item in state)
        if (item.id == todo.id)
          Todo(id: todo.id, name: todo.name, completed: !todo.completed)
        else
          item
    ];
  }

  void remove(int id) {
    state = state.where((element) => element.id != id).toList();
  }
}
