import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:splitwise/Components/NavDrawer.dart';

class SplitExpense extends StatefulWidget {
  const SplitExpense({Key? key}) : super(key: key);

  @override
  State<SplitExpense> createState() => _SplitExpenseState();
}

class _SplitExpenseState extends State<SplitExpense> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late List<Map<String, dynamic>> _expenses;

  @override
  void initState() {
    super.initState();
    _expenses = [];
    fetchExpenses();
  }

  Future<void> fetchExpenses() async {
    final currentUser = _auth.currentUser;

    if (currentUser != null) {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('expenses').get();

      final expenses = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .where((expense) {
        final paidByCurrentUser =
            expense['paidBy']['id'] == currentUser.uid ||
                expense['paidBy']['value'] == currentUser.email;

        final currentUserInParticipants =
            expense['participants'].any((participant) =>
                participant['id'] == currentUser.uid ||
                participant['value'] == currentUser.email);

        return paidByCurrentUser || currentUserInParticipants;
      }).toList();

      setState(() {
        _expenses = expenses;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: const Text('Split Expense'),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: ListView.builder(
        itemCount: _expenses.length,
        itemBuilder: (context, index) {
          final expense = _expenses[index];
          final currentUser = _auth.currentUser;

          if (currentUser != null) {

            final currentUserInParticipants =
                expense['participants'].any((participant) =>
                    participant['id'] == currentUser.uid ||
                    participant['value'] == currentUser.email);

            return Card(
              color: Colors.black,
              child: ListTile(
                title: Text(expense['description'],style: TextStyle(color: Colors.white),),
                subtitle: Text('Total Amount: ${expense['totalAmount']}',style: TextStyle(color: Colors.white),),
                trailing: currentUserInParticipants
                    ? RichText(
                        text: TextSpan(
                          text: 'You Owe amount to ',
                          style: const TextStyle(color: Colors.blue),
                          children: [
                            TextSpan(
                              text: '${expense['paidBy']['label']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      )
                    : null,
              ),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/NewExpense');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
