import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splitwise/Components/Button.dart';
import 'package:splitwise/Components/CustomFormField.dart';
import 'package:splitwise/Provider/LoginProvider.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false; // Added a loading flag

  Future<void> _signUp() async {
    setState(() {
      _loading = true; // Set loading to true when signing up starts
    });

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (userCredential.user != null) {
        await userCredential.user?.updateDisplayName(_nameController.text);
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'id': userCredential.user!.uid,
          'name': _nameController.text,
          'email': _emailController.text,
        });

        _nameController.clear();
        _emailController.clear();
        _passwordController.clear();
        LoginProvider auth = Provider.of<LoginProvider>(context, listen: false);
        auth.loginUser();
        setState((){});
        Navigator.of(context).pushNamed('/friends');
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('login', true);
        print(
            'User signed up and data saved to Firestore: ${userCredential.user?.email}');
      } else {
        print('Error: user is null after sign up.');
      }
    } catch (e) {
      print('Error during signup: $e');
    } finally {
      setState(() {
        _loading = false; // Set loading to false when signing up completes (success or failure)
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up', style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 21, 22, 23),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Welcome. We exist to make expense easier.",
              style: TextStyle(fontSize: 24, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Sign Up",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            const SizedBox(
              height: 20,
            ),
            CustomFormField(
                fieldController: _nameController, label: "UserName"),
            const SizedBox(height: 16.0),
            CustomFormField(fieldController: _emailController, label: "Email"),
            const SizedBox(height: 16.0),
            CustomFormField(
                fieldController: _passwordController, label: "Password",check: true,),
            const SizedBox(height: 16.0),
            _loading
                ? CircularProgressIndicator() 
                : CustomButton(fn: _signUp, label: "Sign Up"),
          ],
        ),
      ),
    );
  }
}
