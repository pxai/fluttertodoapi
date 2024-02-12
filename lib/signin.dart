import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertodostate/completed.dart';
import 'package:fluttertodostate/signup.dart';
import 'provider/user_provider.dart';

class SignInPage extends ConsumerWidget {
  const SignInPage({super.key});

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
        title: Text("Login"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
              controller: emailController,
            ),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
              controller: passwordController,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        const CompletedPage(title: "Completed Todos")));
              },
              child: TextButton(
                child: Text('Login'),
                onPressed: () {
                  // how to get todoListProvider.notifier
                  user.signInUser(
                      emailController.text, passwordController.text);
                },
              ),
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SignUpPage()));
                },
                child: Text('Sign Up')),
          ],
        ),
      ),
    );
  }
}
