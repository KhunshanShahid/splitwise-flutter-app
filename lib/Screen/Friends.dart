import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:splitwise/Components/Button.dart';
import 'package:splitwise/Components/CustomFormField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:splitwise/Components/NavDrawer.dart';

class Friends extends StatefulWidget {
  const Friends({Key? key}) : super(key: key);

  @override
  State<Friends> createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  final TextEditingController _searchFriend = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore database = FirebaseFirestore.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _friends = [];
  bool _loading = false; // Added a loading flag

  @override
  void initState() {
    super.initState();
    fetchFriends();
  }

  Future<void> _addFriend() async {
    setState(() {
      _loading = true; 
    });

    final currentUserEmail = _auth.currentUser?.email;
    final currentUserID = _auth.currentUser?.uid;
    final currentUserName = _auth.currentUser?.displayName;

    if (_searchFriend.text == currentUserEmail) {
      print('You cannot add yourself as a friend. ${currentUserName}');
      return;
    }

    final isFriendAlreadyAdded =
        _friends.any((friendData) => friendData['email'] == _searchFriend.text);
    if (isFriendAlreadyAdded) {
      print("This friend is already added.");
      return;
    }

    try {
      final usersCollection = FirebaseFirestore.instance.collection("users");
      final querySnapshot = await usersCollection
          .where("email", isEqualTo: _searchFriend.text)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final addFriendData = querySnapshot.docs[0].data();
        print(addFriendData['name']);
        print(_auth.currentUser);
        final friendDbData = _firestore
            .collection("users")
            .doc(currentUserID)
            .collection("friends")
            .doc();
        await friendDbData.set(addFriendData);
        setState(() {
          _friends.add(addFriendData);
        });
        print("Friend added successfully!");
        _searchFriend.clear();
      } else {
        print("No friend data found for the given email.");
      }
    } catch (error) {
      print("Error adding friend: $error");
    } finally {
      setState(() {
        _loading = false; 
      });
    }
  }

  Future<void> fetchFriends() async {
    setState(() {
      _loading = true; 
    });

    try {
      final currentUserId = _auth.currentUser?.uid;
      final friendsCollection =
          FirebaseFirestore.instance.collection("users/$currentUserId/friends");
      print('hello ${friendsCollection}');
      final querySnapshot = await friendsCollection.get();
      final newFriends = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      setState(() {
        _friends = newFriends;
      });
      print(_friends);
    } catch (error) {
      print("Error fetching friends data: $error");
    } finally {
      setState(() {
        _loading = false; 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: const Text('Friends', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 21, 22, 23),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(
              height: 12,
            ),
            CustomFormField(
              fieldController: _searchFriend,
              label: "Add Friends",
            ),
            const SizedBox(
              height: 12,
            ),
            _loading
                ? CircularProgressIndicator()
                : CustomButton(fn: _addFriend, label: "Add"),
            const SizedBox(
              height: 25,
            ),
            for (Map<String, dynamic> friend in _friends)
              CustomButton(fn: _addFriend, label: friend['name']),   
          ],
        ),
      ),
    );
  }
}
