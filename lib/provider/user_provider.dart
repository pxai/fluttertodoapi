import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import '/models/user.dart';

final userProvider =
    StateNotifierProvider<UserNotifier, User>((ref) => UserNotifier());

class UserNotifier extends StateNotifier<User> {
  UserNotifier() : super(User(id: 0, email: '', password: ''));
  final http = Dio();

  Future<void> signInUser(String email, String password) async {
    final user = User(
      id: 0,
      email: '',
      password: '',
    );
    final response = await http.post('http://localhost:3000/users/sign_in.json',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
        data: jsonEncode({
          'user': {
            'email': email,
            'password': password,
          }
        }));
    print("Dio> Result status code: ${response.data}");
    if (response.statusCode == 200) {
      state = User.fromJson(response.data as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<bool> signUpUser(String email, String password) async {
    final response = await http.post('http://localhost:3000/users.json',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
        data: jsonEncode({
          'user': {
            'email': email,
            'password': password,
          }
        }));
    print("Dio> Result status code: ${response.statusCode}");
    if (response.statusCode == 201) {
      final result = jsonDecode(response.data) as Map<String, dynamic>;
      print("Dio> Result from sign up: $result");
      return true;
    } else {
      throw Exception('Failed to load user. Code: ${response.statusCode}');
    }
  }
}
