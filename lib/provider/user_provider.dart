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
      state = User.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<bool> signUpUser(String email, String password) async {
    final response =
        await http.post(Uri.parse('http://localhost:3000/users.json'),
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
    print("Result status code: ${response.statusCode}");
    if (response.statusCode == 201) {
      final result = jsonDecode(response.body) as Map<String, dynamic>;
      print("Result from sign up: $result");
      return true;
    } else {
      throw Exception('Failed to load user. Code: ${response.statusCode}');
    }
  }
}
