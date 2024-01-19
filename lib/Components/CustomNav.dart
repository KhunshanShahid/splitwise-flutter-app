import 'package:flutter/material.dart';

class CustomNav extends StatelessWidget {
  final String title;
  const CustomNav({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title,style: const TextStyle(fontSize: 20,color: Colors.white),),
      backgroundColor: const Color.fromARGB(255,21, 22, 23),
      leading: const BackButton(color: Colors.white,),
    );
  }
}
