import 'package:flutter/material.dart';
import 'package:splitwise/Components/NavDrawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Image.asset('./logo.png', width: 153, height: 53),
        backgroundColor: Color.fromARGB(255,21, 22, 23),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
    );
  }
}