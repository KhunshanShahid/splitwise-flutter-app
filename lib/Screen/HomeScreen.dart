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
        backgroundColor: Color.fromARGB(255, 21, 22, 23),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.black,
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "BillBuddy",
            style: TextStyle(color: Colors.blue, fontSize: 24),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 52,
          ),
          Text(
            "Effortless expense collaboration starts here, powered by your dependable BillBuddy.",
            style: TextStyle(color: Colors.white, fontSize: 20),
            textAlign: TextAlign.center,
          ),
          Text(
            "BillBuddy redefines shared expense collaboration. Seamlessly powered by its dependable support, BillBuddy revolutionizes the way you manage costs together. No more complexities or confusion – just streamlined sharing and effortless tracking. With BillBuddy, simplify your financial teamwork and enjoy a smoother journey towards shared financial goals.",
            style: TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
