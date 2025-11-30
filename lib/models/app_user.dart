import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String uid;
  final String name;
  final int age;
  final String interests;

  AppUser({
    required this.uid,
    required this.name,
    required this.age,
    required this.interests,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'age': age,
      'interests': interests,
    };
  }

  factory AppUser.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppUser(
      uid: data['uid'],
      name: data['name'],
      age: data['age'],
      interests: data['interests'],
    );
  }
}
