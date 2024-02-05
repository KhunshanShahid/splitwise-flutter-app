import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splitwise/Provider/LoginProvider.dart';
import 'package:splitwise/Screen/Login.dart';
import 'package:splitwise/Screen/SignUp.dart';

class NavDrawer extends StatelessWidget {
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 21, 22, 23),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          ListTile(
            trailing: const Icon(Icons.input, color: Colors.white),
            title: const Text('Menu', style: TextStyle(color: Colors.white)),
            onTap: () async {
              Provider.of<LoginProvider>(context, listen: false).logoutUser();
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('login', false);
              Navigator.of(context).pushNamed('/');
              auth.signOut();
            },
          ),
          const SizedBox(
            height: 20,
          ),
          Image.asset(
            "./logo.png",
            height: 50,
            width: 50,
          ),
          const SizedBox(
            height: 50,
          ),
          ListTile(
            leading: const Icon(Icons.input, color: Colors.white),
            title: const Text('Home', style: TextStyle(color: Colors.white)),
            onTap: () => {Navigator.of(context).pushNamed('/')},
          ),
          const Divider(),
          Consumer<LoginProvider>(
            builder: (context, auth, child) {
              return auth.isUser
                  ? _loggedInItems(context)
                  : _loggedOutItems(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.input, color: Colors.white),
            title: const Text('Privacy', style: TextStyle(color: Colors.white)),
            onTap: () => {Navigator.of(context).pushNamed('/privacy')},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.input, color: Colors.white),
            title: const Text('Terms & Condition',
                style: TextStyle(color: Colors.white)),
            onTap: () => {Navigator.of(context).pushNamed('/terms')},
          ),
          const SizedBox(
            height: 50,
          ),
          const Expanded(
            child: Center(
              child: Column(
                children: [
                  Text("V1.0.1", style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _loggedInItems(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.input, color: Colors.white),
          title: const Text('Expenses', style: TextStyle(color: Colors.white)),
          onTap: () => {Navigator.of(context).pushNamed('/equalExpense')},
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.settings, color: Colors.white),
          title: const Text('Friends', style: TextStyle(color: Colors.white)),
          onTap: () => {Navigator.of(context).pushNamed('/friends')},
        ),
        const Divider(),
        const SizedBox(
          height: 12,
        ),
      ],
    );
  }

  Widget _loggedOutItems(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.exit_to_app, color: Colors.white),
          title: const Text('Login', style: TextStyle(color: Colors.white)),
          onTap: () => {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => LoginPage(),
              ),
            ),
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.settings, color: Colors.white),
          title: const Text('SignUp', style: TextStyle(color: Colors.white)),
          onTap: () => {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => SignUpPage()),
            ),
          },
        ),
        const Divider(),
      ],
    );
  }
}
