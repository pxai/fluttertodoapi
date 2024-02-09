import 'package:flutter/material.dart';

class Todo {
  final Key todoId;
  final String content;
  final bool completed;

  Todo({
    required this.todoId,
    required this.content,
    this.completed = false,
  });

  String toString() {
    return 'Todo{todoId: $todoId, content: $content, completed: $completed}';
  }
}
