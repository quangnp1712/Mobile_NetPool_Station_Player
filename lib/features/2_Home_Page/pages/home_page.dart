import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final Function callback;

  const HomePage(this.callback, {super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
