import 'package:flutter/material.dart';
import 'login_page.dart';

void main() {
  runApp(const PegasusTrasherApp());
}

class PegasusTrasherApp extends StatelessWidget {
  const PegasusTrasherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pegasus Trasher',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'ShareTechMono',
      ),
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
