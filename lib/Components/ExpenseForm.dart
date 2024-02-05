import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:splitwise/Components/Button.dart';
import 'package:splitwise/Components/CustomFormField.dart';

class ExpenseForm extends StatefulWidget {
  @override
  _ExpenseFormState createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  final TextEditingController _description = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> _friends = [];
  Map<String, dynamic>? _selectedFriend;

  void initState() {
    super.initState();
    fetchFriends();
  }

  Future<void> fetchFriends() async {
    try {
      final currentUserId = _auth.currentUser?.uid;
      final friendsCollection =
          FirebaseFirestore.instance.collection("users/$currentUserId/friends");
      final querySnapshot = await friendsCollection.get();
      final newFriends = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      setState(() {
        _friends = newFriends;
      });
    } catch (error) {
      print("Error fetching friends data: $error");
    }
  }

  Future<void> _login() async {
    try {
      print('User signed up:');
      // Access the form data using _description.text, _amountController.text, and _selectedFriend
    } catch (e) {
      print('Error during signup: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text('New Expense')),
      body:  Padding(
            padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Share Expense",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomFormField(
                    fieldController: _description,
                    label: "Description",
                  ),
                  const SizedBox(height: 16.0),
                  CustomFormField(
                    fieldController: _amountController,
                    label: "Number",
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16.0),
                  DropdownButtonFormField(
                    value: _selectedFriend,
                    items: _friends
                        .map(
                          (friend) => DropdownMenuItem(
                            value: friend,
                            child: Text(friend['name'] ?? ''),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedFriend = value as Map<String, dynamic>?;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Select Friend',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  CustomButton(fn: _login, label: "Login"),
                ],
              ),
    ));
  }
}
