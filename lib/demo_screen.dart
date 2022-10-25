import 'package:flutter/material.dart';

class DemoScreen extends StatefulWidget {
  DemoScreen({super.key, required this.id});

  int id;

  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(widget.id.toString())),
    );
  }
}
