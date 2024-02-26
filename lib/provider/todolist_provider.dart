import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import '/models/todo.dart';
import 'user_provider.dart';

final todosProvider = StreamProvider.autoDispose<List<Todo>>((ref) async* {
  final notifier = ref.read(todoListProvider.notifier);
  final List<Todo> todos = await notifier.fetchTodos();
  print("todosProvider> THIS IS IT>  fetchTodo todos : $todos");
  yield todos;
});

// final todosProvider2 = StreamProvider.autoDispose<List<Todo>>((ref) async* {
//   final user = ref.read(userProvider);
//   print("todosProvider fetchTodo user token : ${user.token}");
//   final response =
//       await http.get(Uri.parse('http://localhost:3000/tasks'), headers: {
//     'Content-Type': 'application/json',
//     'Accept': 'application/json',
//     'x-myapi-token': user.token,
//   });
//   if (response.statusCode == 200) {
//     final List<Todo> todos = (jsonDecode(response.body) as List)
//         .map((data) => Todo.fromJson(data))
//         .toList();
//     yield todos;
//   } else {
//     throw Exception('Failed to load todos');
//   }
// });

// final todosProvider3 = StreamProvider.autoDispose<List<Todo>>((ref) async* {
//   final response = await http.get(Uri.parse('http://localhost:3000/data'));
//   if (response.statusCode == 200) {
//     final List<Todo> todos = (jsonDecode(response.body) as List)
//         .map((data) => Todo.fromJson(data))
//         .toList();
//     yield todos;
//   } else {
//     throw Exception('Failed to load todos');
//   }
// });

final todoListProvider = StateNotifierProvider<TodoListNotifier, List<Todo>>(
    (ref) => TodoListNotifier(Dio(), ref));

class TodoListNotifier extends StateNotifier<List<Todo>> {
  TodoListNotifier(this.httpClient, this.ref) : super([]);
  final Ref ref;
  final httpClient;

  Future<List<Todo>> fetchTodos() async {
    final user = ref.read(userProvider);
    print("todosProvider> fetchTodos> user token : ${user!.token}");
    final response = await httpClient.get('http://localhost:3000/tasks',
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'x-myapi-token': user!.token,
        }));
    print(
        "Dio>  is the response: ${response.statusCode} - ${response.data} - ${response.headers}");
    if (response.statusCode == 200) {
      return (response.data as List)
          .map((data) => Todo.fromJson(data))
          .toList();
    } else {
      throw Exception('Failed to load todos');
    }
  }

  Future<Todo> fetchTodo(int id) async {
    final user = ref.read(userProvider);
    print("dio> fetchTodo user token : ${user.token}");
    final response = await httpClient.get('http://localhost:3000/tasks/$id',
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'x-myapi-token': user.token,
        }));

    if (response.statusCode == 200) {
      return Todo.fromJson(response.data as Map<String, dynamic>);
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
