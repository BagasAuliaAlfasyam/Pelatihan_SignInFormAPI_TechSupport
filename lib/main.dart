import 'package:alice/alice.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:pelatihan_jagoit_1/views/signin_form.dart';

Logger logger = Logger();
Alice alice = Alice();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: alice.getNavigatorKey(),
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Inspector()
    );
  }
}

class Inspector extends StatelessWidget {
  const Inspector({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Form Samples',
      theme: ThemeData(
        colorSchemeSeed: Colors.teal,
      ),
      builder: (context, child) {
        return Scaffold(
          body: Stack(
            children: [
              const SignInForm(),
              child ?? const SizedBox(),
              if (kDebugMode)
                Positioned(
                  bottom: 2,
                  left: 2,
                  child: GestureDetector(
                    child: const Icon(
                      Icons.info_outline,
                      color: Color.fromRGBO(0, 0, 0, 1),
                      size: 24,
                    ),
                    onTap: () async {
                      alice.showInspector();
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
