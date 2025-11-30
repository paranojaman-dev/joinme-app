import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/app_user.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _interestsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (doc.exists) {
      final user = AppUser.fromDoc(doc);
      _nameController.text = user.name;
      _ageController.text = user.age.toString();
      _interestsController.text = user.interests;
    }
  }

  Future<void> _saveProfile() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final user = AppUser(
      uid: uid,
      name: _nameController.text,
      age: int.tryParse(_ageController.text) ?? 18,
      interests: _interestsController.text,
    );

    await FirebaseFirestore.instance.collection('users').doc(uid).set(user.toMap());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Profil zapisany! ✅')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edytuj profil')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: InputDecoration(labelText: 'Imię')),
            TextField(controller: _ageController, decoration: InputDecoration(labelText: 'Wiek'), keyboardType: TextInputType.number),
            TextField(controller: _interestsController, decoration: InputDecoration(labelText: 'Zainteresowania')),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _saveProfile, child: Text('Zapisz')),
          ],
        ),
      ),
    );
  }
}
