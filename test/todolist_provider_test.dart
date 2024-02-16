import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertodoapi/provider/todolist_provider.dart';
import 'package:fluttertodoapi/provider/user_provider.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertodoapi/models/todo.dart';
import 'fetch_todos_test.mocks.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late ProviderContainer container;
  late TodoListNotifier todoListNotifier;
  late MockClient mockHttpClient;
  setUp(() {
    container = ProviderContainer();

    container = ProviderContainer();
    mockHttpClient = MockClient();
    container.read(todoListProvider.notifier).httpClient = mockHttpClient;
    todoListNotifier = container.read(todoListProvider.notifier);
  });

  // tearDown();

  test('initial state is empty array', () async {
    when(mockHttpClient.get(Uri.parse('http://localhost:3000/tasks'),
            headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('[]', 200));

    final List<Todo> todos = await todoListNotifier.fetchTodos();
    print("These are todos: $todos");
    expect(todos.length, 0);
  });

  test('initial state with some data', () async {
    when(mockHttpClient.get(Uri.parse('http://localhost:3000/tasks'),
            headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(
            '[{"id": 1, "name": "This is it", "completed": true}]', 200));

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
