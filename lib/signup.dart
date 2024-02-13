import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertodostate/completed.dart';
import 'provider/user_provider.dart';
import 'models/user.dart';
import 'signin.dart';

class SignUpPage extends ConsumerWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider.notifier);
    TextEditingController emailController =
        TextEditingController(text: "myemail8@email.com");
    TextEditingController passwordController =
        TextEditingController(text: "mypassword1");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Sign Up"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Username',
              ),
              controller: emailController,
            ),
            TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
                controller: passwordController),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        const CompletedPage(title: "Completed Todos")));
              },
              child: TextButton(
                child: Text('Sign Up'),
                onPressed: () async {
                  final email = emailController.text;
                  bool result = await user.signUpUser(
                      emailController.text, passwordController.text);
                  print("This is the result: $result  - $email");
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SignInPage(email: '')));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
