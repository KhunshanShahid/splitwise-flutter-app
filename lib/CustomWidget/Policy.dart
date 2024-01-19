import 'package:flutter/material.dart';
import 'package:splitwise/Components/CustomNav.dart';

class Policy extends StatelessWidget {
  final String heading;
  final String termstitle;
  const Policy({super.key,required this.heading,required this.termstitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomNav(title: heading),
      ),
      backgroundColor: Color.fromARGB(255,21, 22, 23),
      body:  SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Scrollbar(
            child: Text(
              termstitle,
              style: const TextStyle(fontSize: 14,color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
