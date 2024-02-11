import 'package:flutter/material.dart';

class Todo {
  final int id;
  final String name;
  final bool completed;

  Todo({
    required this.id,
    required this.name,
    this.completed = false,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      name: json['name'],
      completed: json['completed'],
    );
  }

  Todo copyWith({int? id, String? name, bool? completed}) {
    return Todo(
      id: id ?? this.id,
      name: name ?? this.name,
      completed: completed ?? this.completed,
    );
  }

  String toString() {
    return 'Todo{todoId: $id, content: $name, completed: $completed}';
  }
}
