import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:splitwise/Components/Button.dart';
import 'package:splitwise/Components/CustomFormField.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splitwise/Provider/LoginProvider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false; // Added a loading flag

  Future<void> _login() async {
    setState(() {
      _loading = true; // Set loading to true when login starts
    });

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);

      _emailController.clear();
      _passwordController.clear();

      LoginProvider auth = Provider.of<LoginProvider>(context, listen: false);
      auth.loginUser();
      setState(() {});
      Navigator.of(context).pushNamed('/friends');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('login', true);
      print('User signed up: ${userCredential.user?.email}');
    } catch (e) {
      print('Error during signup: $e');
    } finally {
      setState(() {
        _loading = false; // Set loading to false when login completes (success or failure)
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 21, 22, 23),
        iconTheme: const IconThemeData(color: Colors.white),
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
              "Login",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            const SizedBox(
              height: 20,
            ),
            CustomFormField(fieldController: _emailController, label: "Email"),
            const SizedBox(height: 16.0),
            CustomFormField(
              fieldController: _passwordController,
              label: "Password",
              check: true,
            ),
            const SizedBox(height: 16.0),
            _loading
                ? CircularProgressIndicator() // Display loader if loading is true
                : CustomButton(fn: _login, label: "Login"),
          ],
        ),
      ),
    );
  }
}
