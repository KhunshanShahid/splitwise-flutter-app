import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:splitwise/Components/Button.dart';
import 'package:splitwise/Components/CustomFormField.dart';
import 'package:splitwise/Logic/RandomNumber.dart';

class NewExpense extends StatefulWidget {
  @override
  _NewExpenseState createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final TextEditingController _description = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Map<String, dynamic>? _currentUserData;
  List<Map<String, dynamic>> _friends = [];
  Map<String, dynamic>? _selectedPayer;
  List<Map<String, dynamic>> _selectedFriends = [];
  bool _loading = false;

  void initState() {
    super.initState();
    fetchFriends();
  }

  Future<void> fetchFriends() async {
    setState(() {
      _loading = true;
    });

    try {
      final currentUserId = _auth.currentUser?.uid;
      final friendsCollection =
          FirebaseFirestore.instance.collection("users/$currentUserId/friends");
      final querySnapshot = await friendsCollection.get();
      final newFriends = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        _currentUserData = {
          'id': currentUser.uid,
          'name': currentUser.displayName ?? '',
          'email': currentUser.email ?? '',
        };
        newFriends.insert(0, _currentUserData!);
      }
      setState(() {
        _friends = newFriends;
      });
    } catch (error) {
      print("Error fetching friends data: $error");
    } finally {
      setState(() {
        _loading =
            false; // Set loading to false when fetching friends completes (success or failure)
      });
    }
  }

  Future<void> addExpense() async {
    setState(() {
      _loading = true; // Set loading to true when adding expense starts
    });

    final randomNum = hooksFunction().generateRandomNumber();
    final customId = 'custom_id_$randomNum';
    try {
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        final Map<String, dynamic> expenseData = {
          'creator': currentUser.displayName ?? '',
          'description': _description.text,
          'id': customId,
          'owed': {
            customId: [],
          },
          'paidBy': {
            'id': _selectedPayer?['id'],
            'label': _selectedPayer?['name'],
            'value': _selectedPayer?['email'],
          },
          'participants': _selectedFriends
              .where((friend) =>
                  friend['id'] != _selectedPayer?['id'] &&
                  friend['email'] != _selectedPayer?['email'])
              .map((friend) {
            return {
              'id': friend['id'],
              'label': friend['name'],
              'value': friend['email'],
            };
          }).toList(),
          'totalAmount': _amountController.text,
        };
        await FirebaseFirestore.instance
            .collection('expenses')
            .doc(customId)
            .set(expenseData);
        print(expenseData);
      }
      Navigator.of(context).pushNamed('/equalExpense');
    } catch (e) {
      print('Error during login: $e');
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Expense')),
      backgroundColor: Colors.black,
      body: Padding(
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
              label: "Total Amount",
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16.0),
            DropdownButtonFormField(
              value: _selectedPayer,
              items: _selectedFriends
                  .map(
                    (friend) => DropdownMenuItem(
                      value: friend,
                      child: Text(friend['name'] ?? ''),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedPayer = value as Map<String, dynamic>?;
                });
              },
              decoration: InputDecoration(
                labelText: 'Select Friend',
              ),
            ),
            const SizedBox(height: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _friends.map((friend) {
                return CheckboxListTile(
                  title: Text(friend['name'] ?? ''),
                  value: _selectedFriends.contains(friend),
                  onChanged: (value) {
                    setState(() {
                      if (value != null && value) {
                        _selectedFriends.add(friend);
                      } else {
                        _selectedFriends.remove(friend);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16.0),
            _loading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : CustomButton(fn: addExpense, label: "Add Expense"),
          ],
        ),
      ),
    );
  }
}
