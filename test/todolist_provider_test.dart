import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertodoapi/provider/todolist_provider.dart';
import 'package:fluttertodoapi/provider/user_provider.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:dio/dio.dart';
import 'package:fluttertodoapi/models/todo.dart';

void main() {
  late ProviderContainer container;
  late TodoListNotifier todoListNotifier;
  final dio = Dio();
  final dioAdapter = DioAdapter(dio: dio);
  setUp(() {
    container = ProviderContainer();
    dio.httpClientAdapter = dioAdapter;
    container.read(todoListProvider.notifier).httpClient = dio;
    todoListNotifier = container.read(todoListProvider.notifier);
  });

  // tearDown();

  test('initial state is empty array', () async {
    dioAdapter.onGet(
      'http://localhost:3000/tasks',
      (server) => server.reply(
        200,
        [],
        // Reply would wait for one-sec before returning data.
        delay: const Duration(seconds: 0),
      ),
    );

    final List<Todo> todos = await todoListNotifier.fetchTodos();
    print("These are todos: $todos");
    expect(todos.length, 0);
  });

  test('initial state with some data', () async {
    dioAdapter.onGet(
      'http://localhost:3000/tasks',
      (server) => server.reply(
        200,
        [
          {"id": 1, "name": "This is it", "completed": true}
        ],
        // Reply would wait for one-sec before returning data.
        delay: const Duration(seconds: 0),
      ),
    );

    final List<Todo> todos = await todoListNotifier.fetchTodos();
    print("These are todos: $todos");
    expect(todos.length, 1);
  });

  // test('initial state is empty array', () async {
  //   when(mockHttpClient.get(Uri.parse('http://localhost:3000/tasks')))
  //       .thenAnswer((_) async => http.Response(
  //           '[{"id": 1, "name": "This is it", "completed": true}]', 200));

  //   final List<Todo> todos = await todoListNotifier.fetchTodos();
  //   expect(todos.length, 1);
  // });
}
