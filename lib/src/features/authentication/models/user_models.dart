import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String? id;
  final String email;
  final String phone;
  final String name;
  String photoURL;
  final String password;
  var firebaseUser =
      FirebaseAuth.instance.currentUser; //user fireauth đang signin

  UserModel({
    this.id,
    required this.email,
    required this.password,
    required this.name,
    required this.phone,
    required this.photoURL,
  });

  toJson() {
    return {
      "Uid": firebaseUser!.uid,
      "Email": email,
      "Password": password,
      "Name": name,
      "Phone": phone,
      "PhotoURL": photoURL,
    };
  }

  //Bước 1: - Map user fetched từ Firebase tới UserModel
  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
      id: document.id,
      email: data["Email"],
      password: data["Password"],
      name: data["Name"],
      phone: data["Phone"],
      photoURL: data["PhotoURL"],
    );
  }
}
