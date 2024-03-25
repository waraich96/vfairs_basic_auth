import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: InAppWebViewExample(key: key),
    );
  }
}

class InAppWebViewExample extends StatefulWidget {
  InAppWebViewExample({Key? key}) : super(key: key);

  @override
  InAppWebViewExampleState createState() => InAppWebViewExampleState();
}

class InAppWebViewExampleState extends State<InAppWebViewExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("vFairs Basic Auth")),
      body: InAppWebView(
        initialUrlRequest:
            URLRequest(url: WebUri("https://auth.e1education.dk")),
        onReceivedHttpAuthRequest: (controller, challenge) async {
          // Prompt the user to enter their username and password
          String? username;
          String? password;
          await showDialog(
              context: context,
              builder: (context) {
                TextEditingController usernameController =
                    TextEditingController();
                TextEditingController passwordController =
                    TextEditingController();
                return AlertDialog(
                  title: const Text('Authentication Required'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        controller: usernameController,
                        decoration:
                            const InputDecoration(labelText: 'Username'),
                      ),
                      TextField(
                        controller: passwordController,
                        decoration:
                            const InputDecoration(labelText: 'Password'),
                        obscureText: true,
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: const Text('Enter'),
                      onPressed: () {
                        username = usernameController.text;
                        password = passwordController.text;
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              });

          if (username != null && password != null) {
            return HttpAuthResponse(
                username: username ?? '',
                password: password ?? '',
                action: HttpAuthResponseAction.PROCEED);
          } else {
            return HttpAuthResponse(action: HttpAuthResponseAction.CANCEL);
          }
        },
      ),
    );
  }
}
