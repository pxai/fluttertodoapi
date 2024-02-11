import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '/models/user.dart';

final userProvider =
    StateNotifierProvider<UserNotifier, User>((ref) => UserNotifier());

class UserNotifier extends StateNotifier<User> {
  UserNotifier() : super(User(id: 0, email: '', password: ''));

  Future<void> signInUser(String email, String password) async {
    final user = User(
      id: 0,
      email: '',
      password: '',
    );
    final response =
        await http.post(Uri.parse('http://localhost:3000/users/sign_in.json'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'user': {
                'email': email,
                'password': password,
              }
            }));

    if (response.statusCode == 200) {
      user.setToken(jsonDecode(response.body).token);
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<User> signUpUser(String email, String password) async {
    final response =
        await http.post(Uri.parse('http://localhost:3000/users/sign_up.json'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'user': {
                'email': email,
                'password': password,
              }
            }));
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load user');
    }
  }
}
