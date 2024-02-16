import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertodoapi/completed.dart';
import 'package:fluttertodoapi/signup.dart';
import 'provider/user_provider.dart';
import 'models/user.dart';
import 'home.dart';

class SignInPage extends ConsumerWidget {
  const SignInPage({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController emailController = TextEditingController(text: email);
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
                onPressed: () async {
                  // how to get todoListProvider.notifier
                  final result = await ref
                      .read(userProvider.notifier)
                      .signInUser(
                          emailController.text, passwordController.text);
                  print(
                      "This is the result: ${ref.watch(userProvider).toString()}");
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          const MyHomePage(title: 'My tasks')));
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
