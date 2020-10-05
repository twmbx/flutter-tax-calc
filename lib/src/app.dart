import 'package:flutter/material.dart';
import 'home_screen.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zambian Salary Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: Home(title: 'Zambian Salary Calculator'),
    );
  }
}
