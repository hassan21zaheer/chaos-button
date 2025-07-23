import 'package:chaosbutton/chaosbutton.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Chaos Button Example')),
        body: Center(
          child: ChaosButton(
            width: 250.0,
            height: 70.0,
            borderRadius: BorderRadius.circular(20.0),
            backgroundColor: Colors.grey[900]!,
            lineColors: [Colors.cyan, Colors.pink, Colors.amber, Colors.teal],
            animationDuration: Duration(milliseconds: 400),
            onTap: () => print('Chaos Button Pressed!'),
          ),
        ),
      ),
    );
  }
}